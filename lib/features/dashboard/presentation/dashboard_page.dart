import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/cycle_insights.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/period_record.dart';
import '../../../domain/entities/prediction.dart';
import '../../../domain/entities/sync_state.dart';
import '../../../domain/entities/user_cycle_settings.dart';
import 'widgets/cycle_ring.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(activePeriodsProvider);
    final prediction = ref.watch(predictionProvider).valueOrNull;
    final settings = ref.watch(userCycleSettingsProvider).valueOrNull;
    final insights = ref.watch(cycleInsightsProvider).valueOrNull;
    final syncSnapshot = ref.watch(syncSnapshotProvider);

    ref.listen(periodActionsProvider, (_, next) {
      next.whenOrNull(
        error: (_, __) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Perubahan belum dapat disimpan. Data sebelumnya tetap aman.',
            ),
          ),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CycleCareAppBar(
        title: 'CycleCare',
        actions: [
          IconButton(
            tooltip: 'Buka akun dan pengaturan',
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: CycleCareBackground(
        child: periods.when(
          loading: () => const CycleCareLoadingState(),
          error: (_, __) => CycleCareErrorState(
            message:
                'Data lokalmu tetap aman. Coba muat kembali untuk menampilkan catatan terbaru.',
            onRetry: () {
              ref.invalidate(activePeriodsProvider);
              ref.invalidate(cycleInsightsProvider);
            },
          ),
          data: (records) => _DashboardContent(
            records: records,
            prediction: prediction,
            settings: settings,
            insights: insights,
            syncSnapshot: syncSnapshot,
            onRefresh: () async {
              ref.invalidate(activePeriodsProvider);
              ref.invalidate(predictionProvider);
              ref.invalidate(cycleInsightsProvider);
              await ref.read(syncControllerProvider).synchronizeNow();
            },
            onRetrySync: () => ref.read(syncControllerProvider).retry(),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.records,
    required this.prediction,
    required this.settings,
    required this.insights,
    required this.syncSnapshot,
    required this.onRefresh,
    required this.onRetrySync,
  });

  final List<PeriodRecord> records;
  final CyclePrediction? prediction;
  final UserCycleSettingsRecord? settings;
  final CycleInsights? insights;
  final SyncGateSnapshot syncSnapshot;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetrySync;

  @override
  Widget build(BuildContext context) {
    final showFertile = settings?.showFertileWindow == true;
    final showOvulation = settings?.showOvulationEstimate == true;
    final ongoing =
        records.where((record) => record.endDate == null).firstOrNull;
    final timelineData = _buildTimelineData(
      records: records,
      prediction: prediction,
      insights: insights,
      showFertile: showFertile,
      showOvulation: showOvulation,
    );
    final showsSyncBanner = {
      SyncGateStatus.synchronizing,
      SyncGateStatus.offlineReady,
      SyncGateStatus.failed,
    }.contains(syncSnapshot.status);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              CycleCareSpacing.page,
              CycleCareSpacing.md,
              CycleCareSpacing.page,
              112,
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DashboardHeader(syncSnapshot: syncSnapshot),
                      const SizedBox(height: CycleCareSpacing.lg),
                      if (showsSyncBanner) ...[
                        CycleCareSyncBanner(
                          snapshot: syncSnapshot,
                          onRetry: onRetrySync,
                        ),
                        const SizedBox(height: CycleCareSpacing.md),
                      ],
                      _CycleHeroCard(
                        records: records,
                        prediction: prediction,
                        insights: insights,
                        ongoing: ongoing,
                      ),
                      const SizedBox(height: CycleCareSpacing.md),
                      _CycleTimelineCard(
                        data: timelineData,
                        showFertile: showFertile && insights?.fertility != null,
                        showOvulation:
                            showOvulation && insights?.fertility != null,
                        showPrediction: prediction?.ready == true,
                      ),
                      const SizedBox(height: CycleCareSpacing.xxl),
                      const CycleCareSectionHeader(
                        title: 'Perkiraan siklus',
                        subtitle:
                            'Tanggal dapat berubah mengikuti catatan terbaru.',
                      ),
                      const SizedBox(height: CycleCareSpacing.md),
                      _PhaseCards(
                        prediction: prediction,
                        fertility: insights?.fertility,
                        showFertile: showFertile,
                        showOvulation: showOvulation,
                      ),
                      const SizedBox(height: CycleCareSpacing.xxl),
                      _RecentCyclesCard(
                        records: records,
                        statistics: insights?.statistics,
                      ),
                      if (showFertile && insights?.fertility != null) ...[
                        const SizedBox(height: CycleCareSpacing.lg),
                        const _FertilitySafetyNote(),
                      ],
                      const SizedBox(height: CycleCareSpacing.lg),
                      const MedicalDisclaimer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.syncSnapshot});

  final SyncGateSnapshot syncSnapshot;

  @override
  Widget build(BuildContext context) {
    final status = _syncChip(syncSnapshot.status);
    return CycleCareStatusChip(
      label: status.label,
      icon: status.icon,
      tone: status.tone,
    );
  }

  _HeaderStatus _syncChip(SyncGateStatus status) => switch (status) {
        SyncGateStatus.ready => const _HeaderStatus(
            label: 'Tersinkron',
            icon: Icons.cloud_done_outlined,
            tone: CycleCareStatusTone.success,
          ),
        SyncGateStatus.synchronizing => const _HeaderStatus(
            label: 'Menyinkronkan',
            icon: Icons.sync_rounded,
            tone: CycleCareStatusTone.info,
          ),
        SyncGateStatus.offlineReady => const _HeaderStatus(
            label: 'Offline',
            icon: Icons.cloud_off_outlined,
            tone: CycleCareStatusTone.warning,
          ),
        SyncGateStatus.failed => const _HeaderStatus(
            label: 'Perlu sinkronisasi',
            icon: Icons.sync_problem_rounded,
            tone: CycleCareStatusTone.error,
          ),
        _ => const _HeaderStatus(
            label: 'Tersimpan di perangkat',
            icon: Icons.smartphone_rounded,
            tone: CycleCareStatusTone.neutral,
          ),
      };
}

class _HeaderStatus {
  const _HeaderStatus({
    required this.label,
    required this.icon,
    required this.tone,
  });

  final String label;
  final IconData icon;
  final CycleCareStatusTone tone;
}

class _CycleHeroCard extends StatelessWidget {
  const _CycleHeroCard({
    required this.records,
    required this.prediction,
    required this.insights,
    required this.ongoing,
  });

  final List<PeriodRecord> records;
  final CyclePrediction? prediction;
  final CycleInsights? insights;
  final PeriodRecord? ongoing;

  @override
  Widget build(BuildContext context) {
    final status = insights?.status;
    final currentCycleDay = status?.currentCycleDay;
    final predictionRange = _predictionRange(prediction);
    final empty = records.isEmpty;
    final colors = context.cycleCareColors;

    return CycleCareCard(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF38232D)
          : CycleCareColors.surface,
      semanticLabel: _heroSemanticLabel(
        status: status,
        prediction: prediction,
        empty: empty,
      ),
      padding: const EdgeInsets.all(CycleCareSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hari ini',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: CycleCareSpacing.xxs),
                    Text(
                      empty
                          ? 'Mulai catatanmu'
                          : currentCycleDay == null
                              ? 'Data bertambah'
                              : 'Hari $currentCycleDay',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFFFFB2D0)
                                    : CycleCareColors.periodStrong,
                          ),
                    ),
                    const SizedBox(height: CycleCareSpacing.xs),
                    Text(
                      _cycleStatusLabel(status, insights?.fertility),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              if (!empty)
                CycleCareStatusChip(
                  label: status?.isLate == true
                      ? 'Lewat perkiraan'
                      : ongoing == null
                          ? 'Siklus aktif'
                          : 'Period berlangsung',
                  icon: status?.isLate == true
                      ? Icons.schedule_rounded
                      : ongoing == null
                          ? Icons.favorite_outline_rounded
                          : Icons.water_drop_rounded,
                  tone: status?.isLate == true
                      ? CycleCareStatusTone.warning
                      : CycleCareStatusTone.neutral,
                ),
            ],
          ),
          if (status?.isLate == true) ...[
            const SizedBox(height: CycleCareSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(CycleCareSpacing.sm),
              decoration: BoxDecoration(
                color: CycleCareColors.ovulationSoft.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.14
                      : 0.72,
                ),
                borderRadius: BorderRadius.circular(CycleCareRadius.small),
                border: Border.all(color: colors.divider),
              ),
              child: Text(
                'Terlambat ${status!.lateDays} hari dari rentang perkiraan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFFFE082)
                          : CycleCareColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
          const SizedBox(height: CycleCareSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(CycleCareSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.52),
              borderRadius: CycleCareRadius.mediumBorder,
              border: Border.all(color: colors.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: CycleCareSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        empty
                            ? 'Belum ada perkiraan period'
                            : 'Perkiraan period berikutnya',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: CycleCareSpacing.xxs),
                      Text(
                        predictionRange ?? 'Catat beberapa siklus dahulu',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (prediction?.ready == true) ...[
                        const SizedBox(height: CycleCareSpacing.xxs),
                        Text(
                          'Berdasarkan ${prediction!.basedOnCycles} siklus • Keyakinan ${prediction!.confidence?.label.toLowerCase() ?? 'rendah'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: CycleCareSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.push('/add-period', extra: ongoing),
              icon: Icon(
                  ongoing == null ? Icons.add_rounded : Icons.edit_rounded),
              label: Text(ongoing == null ? 'Catat period' : 'Perbarui period'),
            ),
          ),
        ],
      ),
    );
  }

  String _heroSemanticLabel({
    required CycleStatus? status,
    required CyclePrediction? prediction,
    required bool empty,
  }) {
    if (empty) {
      return 'Belum ada catatan siklus. Catat period untuk memulai.';
    }
    return [
      if (status?.currentCycleDay != null)
        'Hari ke-${status!.currentCycleDay} dari siklus.',
      if (status?.currentMenstruationDay != null)
        'Hari ke-${status!.currentMenstruationDay} period.',
      if (status?.isLate == true)
        'Perkiraan period telah lewat ${status!.lateDays} hari.',
      if (prediction?.windowStart != null && prediction?.windowEnd != null)
        'Perkiraan period berikutnya ${DateOnly.display(prediction!.windowStart!)} sampai ${DateOnly.display(prediction.windowEnd!)}.',
    ].join(' ');
  }
}

class _CycleTimelineCard extends StatelessWidget {
  const _CycleTimelineCard({
    required this.data,
    required this.showFertile,
    required this.showOvulation,
    required this.showPrediction,
  });

  final CycleRingData data;
  final bool showFertile;
  final bool showOvulation;
  final bool showPrediction;

  @override
  Widget build(BuildContext context) => CycleCareCard(
        padding: const EdgeInsets.all(CycleCareSpacing.lg),
        semanticLabel: data.semanticLabel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Siklus saat ini',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: CycleCareSpacing.md),
            ExcludeSemantics(child: _CycleTimeline(data: data)),
            const SizedBox(height: CycleCareSpacing.sm),
            Wrap(
              spacing: CycleCareSpacing.md,
              runSpacing: CycleCareSpacing.xs,
              children: [
                const _TimelineLegend(
                  color: CycleCareColors.period,
                  label: 'Period tercatat',
                  icon: Icons.water_drop_rounded,
                ),
                if (showFertile)
                  const _TimelineLegend(
                    color: CycleCareColors.fertileStrong,
                    label: 'Masa subur',
                    icon: Icons.blur_circular_rounded,
                  ),
                if (showOvulation)
                  const _TimelineLegend(
                    color: CycleCareColors.ovulation,
                    label: 'Ovulasi',
                    icon: Icons.sunny_snowing,
                  ),
                if (showPrediction)
                  const _TimelineLegend(
                    color: CycleCareColors.prediction,
                    label: 'Period diperkirakan',
                    icon: Icons.calendar_month_outlined,
                  ),
              ],
            ),
          ],
        ),
      );
}

class _CycleTimeline extends StatelessWidget {
  const _CycleTimeline({required this.data});

  final CycleRingData data;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 34,
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 14,
                decoration: BoxDecoration(
                  color: context.cycleCareColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(CycleCareRadius.pill),
                  border: Border.all(color: context.cycleCareColors.divider),
                ),
              ),
              for (final segment in data.segments)
                Positioned(
                  left: constraints.maxWidth * segment.start.clamp(0, 1),
                  width: math.max(
                    8,
                    constraints.maxWidth *
                        (segment.end - segment.start).clamp(0, 1),
                  ),
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: segment.color,
                      borderRadius: BorderRadius.circular(CycleCareRadius.pill),
                    ),
                  ),
                ),
              if (data.ovulationProgress != null)
                Positioned(
                  left: (constraints.maxWidth - 14) *
                      data.ovulationProgress!.clamp(0, 1),
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: CycleCareColors.ovulation,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.cycleCareColors.textPrimary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              if (data.todayProgress != null)
                Positioned(
                  left: (constraints.maxWidth - 22) *
                      data.todayProgress!.clamp(0, 1),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: context.cycleCareColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.cycleCareColors.textPrimary,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.today_rounded,
                      size: 12,
                      color: context.cycleCareColors.textPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}

class _TimelineLegend extends StatelessWidget {
  const _TimelineLegend({
    required this.color,
    required this.label,
    required this.icon,
  });

  final Color color;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 12, color: color),
          ),
          const SizedBox(width: CycleCareSpacing.xxs),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      );
}

class _PhaseCards extends StatelessWidget {
  const _PhaseCards({
    required this.prediction,
    required this.fertility,
    required this.showFertile,
    required this.showOvulation,
  });

  final CyclePrediction? prediction;
  final FertilityEstimate? fertility;
  final bool showFertile;
  final bool showOvulation;

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[];
    if (showFertile && fertility != null) {
      cards.add(
        _PhaseCard(
          icon: Icons.blur_circular_rounded,
          color: Theme.of(context).colorScheme.secondaryContainer,
          iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
          eyebrow: 'Perkiraan',
          date:
              '${_compactDate(fertility!.fertileWindowStart)}–${_compactDate(fertility!.fertileWindowEnd)}',
          title: 'Masa subur',
          subtitle: 'Keyakinan ${fertility!.confidence.label.toLowerCase()}',
        ),
      );
    }
    if (showOvulation && fertility != null) {
      cards.add(
        _PhaseCard(
          icon: Icons.sunny_snowing,
          color: Theme.of(context).colorScheme.tertiaryContainer,
          iconColor: Theme.of(context).colorScheme.onTertiaryContainer,
          eyebrow: 'Perkiraan',
          date: _compactDate(fertility!.ovulationCenter),
          title: 'Perkiraan ovulasi',
          subtitle: 'Rentang dapat berubah',
        ),
      );
    }
    if (prediction?.ready == true &&
        prediction?.predictedStart != null &&
        prediction?.windowStart != null &&
        prediction?.windowEnd != null) {
      final days = DateOnly.differenceInDays(
        prediction!.predictedStart!,
        DateTime.now(),
      );
      cards.add(
        _PhaseCard(
          icon: Icons.update_rounded,
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF38232D)
              : CycleCareColors.predictionSoft,
          iconColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFFFB2D0)
              : CycleCareColors.periodStrong,
          eyebrow: 'Berikutnya',
          date: _predictionRange(prediction)!,
          title: 'Period berikutnya',
          subtitle: days >= 0
              ? 'Sekitar $days hari lagi'
              : 'Rentang perkiraan telah lewat',
        ),
      );
    }

    if (cards.isEmpty) {
      return CycleCareCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.auto_graph_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: CycleCareSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data belum cukup',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: CycleCareSpacing.xxs),
                  const Text(
                    'Catat beberapa siklus agar perkiraan menjadi lebih personal.',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 580
                ? 2
                : 1;
        final width =
            (constraints.maxWidth - CycleCareSpacing.md * (columns - 1)) /
                columns;
        return Wrap(
          spacing: CycleCareSpacing.md,
          runSpacing: CycleCareSpacing.md,
          children:
              cards.map((card) => SizedBox(width: width, child: card)).toList(),
        );
      },
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.eyebrow,
    required this.date,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final String eyebrow;
  final String date;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => CycleCareCard(
        color: color,
        semanticLabel: '$title. $date. $subtitle.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: CycleCareSpacing.xs),
                Expanded(
                  child: Text(
                    eyebrow,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: iconColor,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: CycleCareSpacing.lg),
            Text(date, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: CycleCareSpacing.xxs),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: CycleCareSpacing.xxs),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
}

class _RecentCyclesCard extends StatelessWidget {
  const _RecentCyclesCard({required this.records, required this.statistics});

  final List<PeriodRecord> records;
  final CycleStatistics? statistics;

  @override
  Widget build(BuildContext context) {
    final recent = [...records]
      ..sort((first, second) => first.startDate.compareTo(second.startDate));
    final visible =
        recent.length > 3 ? recent.sublist(recent.length - 3) : recent;
    final average = statistics?.averageCycleLength;
    final summary = average == null
        ? 'Catat siklus berikutnya untuk melihat pola pribadi.'
        : 'Rata-rata siklusmu ${average.toStringAsFixed(1)} hari. Pola saat ini ${statistics!.pattern.label.toLowerCase()}.';

    return CycleCareCard(
      semanticLabel: 'Ringkasan ${visible.length} siklus terbaru. $summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  visible.isEmpty
                      ? 'Ringkasan siklus'
                      : 'Ringkasan ${visible.length} siklus',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/statistics'),
                child: const Text('Lihat statistik'),
              ),
            ],
          ),
          const SizedBox(height: CycleCareSpacing.md),
          if (visible.isEmpty)
            Text(summary)
          else
            ExcludeSemantics(
              child: SizedBox(
                height: 116,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final record in visible)
                      Expanded(child: _CycleBar(record: record)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: CycleCareSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(CycleCareSpacing.sm),
            decoration: BoxDecoration(
              color: context.cycleCareColors.backgroundBlue,
              borderRadius: CycleCareRadius.mediumBorder,
              border: Border.all(color: context.cycleCareColors.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: CycleCareColors.fertileStrong,
                ),
                const SizedBox(width: CycleCareSpacing.sm),
                Expanded(
                  child: Text(
                    summary,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleBar extends StatelessWidget {
  const _CycleBar({required this.record});

  final PeriodRecord record;

  @override
  Widget build(BuildContext context) {
    final cycleLength = record.cycleLengthDays ?? 28;
    final periodDuration = record.periodDurationDays ?? 0;
    final barHeight = (44 + (cycleLength.clamp(20, 40) - 20) * 2.1).toDouble();
    final flowHeight = periodDuration == 0
        ? 4.0
        : (barHeight * periodDuration / cycleLength).clamp(8.0, 28.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 34,
          height: barHeight,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: context.cycleCareColors.surfaceMuted,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(CycleCareRadius.small),
            ),
            border: Border.all(color: context.cycleCareColors.divider),
          ),
          child: Container(
            width: double.infinity,
            height: flowHeight,
            decoration: const BoxDecoration(
              color: CycleCareColors.period,
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
        ),
        const SizedBox(height: CycleCareSpacing.xs),
        Text(
          DateFormat('MMM', 'id_ID').format(record.startDate),
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _FertilitySafetyNote extends StatelessWidget {
  const _FertilitySafetyNote();

  @override
  Widget build(BuildContext context) => Semantics(
        container: true,
        label:
            'Perkiraan masa subur tidak ditujukan sebagai metode kontrasepsi.',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 18,
              color: context.cycleCareColors.textSecondary,
            ),
            const SizedBox(width: CycleCareSpacing.xs),
            Expanded(
              child: Text(
                'Perkiraan masa subur tidak ditujukan sebagai metode kontrasepsi.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
}

CycleRingData _buildTimelineData({
  required List<PeriodRecord> records,
  required CyclePrediction? prediction,
  required CycleInsights? insights,
  required bool showFertile,
  required bool showOvulation,
}) {
  final latest = records.isEmpty ? null : records.first;
  final status = insights?.status;
  final cycleStart = latest?.startDate;
  final average = insights?.statistics.averageCycleLength;
  final cycleLength = prediction?.baselineCycleDays ??
      latest?.cycleLengthDays ??
      average?.round() ??
      28;
  final segments = <CycleRingSegment>[];

  double? fractionForDay(int? day, {bool end = false}) {
    if (day == null || cycleLength <= 0) return null;
    final value = end ? day / cycleLength : (day - 1) / cycleLength;
    return value.clamp(0.0, 1.0);
  }

  int? dayForDate(DateTime? date) {
    if (date == null || cycleStart == null) return null;
    return DateOnly.differenceInDays(date, cycleStart) + 1;
  }

  final periodDays =
      latest?.periodDurationDays ?? status?.currentMenstruationDay;
  final periodEnd = fractionForDay(periodDays, end: true);
  if (periodEnd != null) {
    segments.add(
      CycleRingSegment(
        start: 0,
        end: periodEnd,
        color: CycleCareColors.period,
      ),
    );
  }

  final fertility = insights?.fertility;
  if (showFertile && fertility != null) {
    final start = fractionForDay(dayForDate(fertility.fertileWindowStart));
    final end = fractionForDay(
      dayForDate(fertility.fertileWindowEnd),
      end: true,
    );
    if (start != null && end != null && end > start) {
      segments.add(
        CycleRingSegment(
          start: start,
          end: end,
          color: CycleCareColors.fertileStrong,
        ),
      );
    }
  }

  if (prediction?.windowStart != null && prediction?.windowEnd != null) {
    final start = fractionForDay(dayForDate(prediction!.windowStart));
    final end = fractionForDay(
      dayForDate(prediction.windowEnd),
      end: true,
    );
    if (start != null && end != null && end > start) {
      segments.add(
        CycleRingSegment(
          start: start,
          end: end,
          color: CycleCareColors.prediction,
        ),
      );
    }
  }

  final semantics = <String>[
    if (status?.currentCycleDay != null)
      'Hari ke-${status!.currentCycleDay} dari siklus.',
    if (periodEnd != null) 'Period tercatat ditampilkan pada awal siklus.',
    if (showFertile && fertility != null)
      'Masa subur diperkirakan ${DateOnly.display(fertility.fertileWindowStart)} sampai ${DateOnly.display(fertility.fertileWindowEnd)}.',
    if (showOvulation && fertility != null)
      'Ovulasi diperkirakan ${DateOnly.display(fertility.ovulationCenter)}.',
    if (prediction?.windowStart != null && prediction?.windowEnd != null)
      'Period berikutnya diperkirakan ${DateOnly.display(prediction!.windowStart!)} sampai ${DateOnly.display(prediction.windowEnd!)}.',
  ].join(' ');

  return CycleRingData(
    title: status?.currentCycleDay == null
        ? 'Data belum cukup'
        : 'Hari ke-${status!.currentCycleDay}',
    subtitle: 'Siklus saat ini',
    semanticLabel: semantics.isEmpty
        ? 'Data belum cukup untuk menampilkan garis waktu siklus.'
        : semantics,
    todayProgress: fractionForDay(status?.currentCycleDay),
    ovulationProgress: showOvulation
        ? fractionForDay(dayForDate(fertility?.ovulationCenter))
        : null,
    segments: segments,
  );
}

String _cycleStatusLabel(
  CycleStatus? status,
  FertilityEstimate? fertility,
) {
  if (status?.currentMenstruationDay != null) {
    return 'Hari ke-${status!.currentMenstruationDay} period';
  }
  if (status?.isLate == true) {
    return 'Perkiraan period telah lewat';
  }
  final today = DateOnly.normalize(DateTime.now());
  if (fertility != null) {
    final fertileStart = DateOnly.normalize(fertility.fertileWindowStart);
    final fertileEnd = DateOnly.normalize(fertility.fertileWindowEnd);
    if (!today.isBefore(fertileStart) && !today.isAfter(fertileEnd)) {
      return 'Dalam perkiraan masa subur';
    }
    if (today.isAfter(DateOnly.normalize(fertility.latestOvulation))) {
      return 'Fase setelah perkiraan ovulasi';
    }
  }
  if (status?.currentCycleDay != null) return 'Siklus sedang berjalan';
  return 'Catat period pertama untuk memulai';
}

String? _predictionRange(CyclePrediction? prediction) {
  if (prediction?.ready != true ||
      prediction?.windowStart == null ||
      prediction?.windowEnd == null) {
    return null;
  }
  return '${_compactDate(prediction!.windowStart!)}–${_compactDate(prediction.windowEnd!)}';
}

String _compactDate(DateTime date) =>
    DateFormat('d MMM', 'id_ID').format(DateOnly.normalize(date));
