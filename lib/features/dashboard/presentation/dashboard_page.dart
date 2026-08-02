import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/cycle_insights.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/period_record.dart';
import '../../../domain/entities/prediction.dart';
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
    ref.listen(periodActionsProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CycleCareBackground(
        child: SafeArea(
          bottom: false,
          child: periods.when(
            loading: () => const CycleCareLoadingState(),
            error: (_, __) => CycleCareErrorState(
              message:
                  'Data siklusmu tetap aman. Periksa koneksi lalu coba lagi.',
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
              syncLabel: 'Data tersimpan di perangkat',
              onRefresh: () async {
                ref.invalidate(activePeriodsProvider);
                ref.invalidate(cycleInsightsProvider);
                await ref.read(syncControllerProvider).synchronizeNow();
              },
            ),
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
    required this.syncLabel,
    required this.onRefresh,
  });

  final List<PeriodRecord> records;
  final CyclePrediction? prediction;
  final UserCycleSettingsRecord? settings;
  final CycleInsights? insights;
  final String syncLabel;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final ringData = _buildRingData(
      records: records,
      prediction: prediction,
      insights: insights,
      showFertile: settings?.showFertileWindow == true,
      showOvulation: settings?.showOvulationEstimate == true,
    );
    final ongoing = records.where((record) => record.endDate == null).firstOrNull;

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
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DashboardHeader(syncLabel: syncLabel),
                      const SizedBox(height: CycleCareSpacing.xl),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final ring = _RingCard(data: ringData);
                          final overview = _OverviewPanel(
                            records: records,
                            insights: insights,
                            ongoing: ongoing,
                          );
                          if (constraints.maxWidth >= 860) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 6, child: ring),
                                const SizedBox(width: CycleCareSpacing.xl),
                                Expanded(flex: 5, child: overview),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              ring,
                              const SizedBox(height: CycleCareSpacing.lg),
                              overview,
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: CycleCareSpacing.xxl),
                      const CycleCareSectionHeader(
                        title: 'Perkiraan siklus',
                        subtitle: 'Tanggal dapat berubah mengikuti catatan terbaru.',
                      ),
                      const SizedBox(height: CycleCareSpacing.md),
                      _PhaseCards(
                        prediction: prediction,
                        fertility: insights?.fertility,
                        showFertile: settings?.showFertileWindow == true,
                        showOvulation: settings?.showOvulationEstimate == true,
                      ),
                      const SizedBox(height: CycleCareSpacing.xxl),
                      _TodayCard(insights: insights, ringData: ringData),
                      if (insights?.status.isLate == true) ...[
                        const SizedBox(height: CycleCareSpacing.md),
                        _LateCard(days: insights!.status.lateDays),
                      ],
                      const SizedBox(height: CycleCareSpacing.xxl),
                      CycleCareSectionHeader(
                        title: 'Wawasan pribadi',
                        subtitle: 'Ringkasan dari riwayat yang kamu catat.',
                        action: TextButton(
                          onPressed: () => context.push('/statistics'),
                          child: const Text('Lihat semua'),
                        ),
                      ),
                      const SizedBox(height: CycleCareSpacing.md),
                      _InsightCards(
                        statistics: insights?.statistics,
                        records: records,
                      ),
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
  const _DashboardHeader({required this.syncLabel});

  final String syncLabel;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hari ini', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 2),
                Text(
                  'Pantau siklusmu',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.cloud_done_outlined, size: 16),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        syncLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Buka pengaturan',
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.tune_rounded),
          ),
          const SizedBox(width: CycleCareSpacing.xs),
          Semantics(
            label: 'Avatar CycleCare',
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [CycleCareColors.period, Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Text(
                'CC',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      );
}

class _RingCard extends StatelessWidget {
  const _RingCard({required this.data});

  final CycleRingData data;

  @override
  Widget build(BuildContext context) => CycleCareCard(
        padding: const EdgeInsets.all(CycleCareSpacing.xl),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) => SizedBox.square(
                dimension: math.min(constraints.maxWidth, 370),
                child: CycleRing(data: data),
              ),
            ),
            const SizedBox(height: CycleCareSpacing.lg),
            const _RingLegend(),
          ],
        ),
      );
}

class _RingLegend extends StatelessWidget {
  const _RingLegend();

  @override
  Widget build(BuildContext context) => const Wrap(
        alignment: WrapAlignment.center,
        spacing: CycleCareSpacing.md,
        runSpacing: CycleCareSpacing.xs,
        children: [
          _LegendItem(color: CycleCareColors.period, label: 'Period'),
          _LegendItem(color: CycleCareColors.fertileStrong, label: 'Masa subur'),
          _LegendItem(color: CycleCareColors.ovulation, label: 'Ovulasi'),
          _LegendItem(color: CycleCareColors.prediction, label: 'Perkiraan'),
        ],
      );
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      );
}

class _OverviewPanel extends StatelessWidget {
  const _OverviewPanel({
    required this.records,
    required this.insights,
    required this.ongoing,
  });

  final List<PeriodRecord> records;
  final CycleInsights? insights;
  final PeriodRecord? ongoing;

  @override
  Widget build(BuildContext context) {
    final status = insights?.status;
    final currentCycleDay = status?.currentCycleDay;
    return Column(
      children: [
        CycleCareCard(
          color: CycleCareColors.periodSoft.withValues(alpha: 0.88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.water_drop_rounded,
                      color: CycleCareColors.periodStrong),
                  const SizedBox(width: CycleCareSpacing.xs),
                  Expanded(
                    child: Text(
                      ongoing == null ? 'Status siklus' : 'Period berlangsung',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: CycleCareSpacing.md),
              Text(
                status?.currentMenstruationDay != null
                    ? 'Hari ke-${status!.currentMenstruationDay} period'
                    : currentCycleDay == null
                        ? 'Data belum cukup'
                        : 'Hari ke-$currentCycleDay dari siklus',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: CycleCareSpacing.xs),
              Text(
                records.isEmpty
                    ? 'Catat period pertama agar perkiraan menjadi lebih personal.'
                    : 'Informasi ini diperbarui dari catatan yang tersimpan di perangkat.',
              ),
            ],
          ),
        ),
        const SizedBox(height: CycleCareSpacing.md),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.push('/add-period', extra: ongoing),
            icon: Icon(ongoing == null ? Icons.add_rounded : Icons.edit_rounded),
            label: Text(ongoing == null ? 'Catat period' : 'Perbarui period'),
          ),
        ),
        const SizedBox(height: CycleCareSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/history'),
            icon: const Icon(Icons.history_rounded),
            label: const Text('Lihat riwayat siklus'),
          ),
        ),
      ],
    );
  }
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
      cards.add(_PhaseCard(
        icon: Icons.blur_circular_rounded,
        color: CycleCareColors.fertileSoft,
        iconColor: CycleCareColors.fertileStrong,
        date:
            '${DateOnly.display(fertility!.fertileWindowStart)} – ${DateOnly.display(fertility!.fertileWindowEnd)}',
        title: 'Masa subur',
        subtitle: 'Perkiraan · ${fertility!.confidence.label}',
      ));
    }
    if (showOvulation && fertility != null) {
      cards.add(_PhaseCard(
        icon: Icons.sunny_snowing,
        color: CycleCareColors.ovulationSoft,
        iconColor: CycleCareColors.warning,
        date: DateOnly.display(fertility!.ovulationCenter),
        title: 'Perkiraan ovulasi',
        subtitle: 'Rentang dapat berubah',
      ));
    }
    if (prediction?.predictedStart != null) {
      cards.add(_PhaseCard(
        icon: Icons.water_drop_outlined,
        color: CycleCareColors.predictionSoft,
        iconColor: CycleCareColors.periodStrong,
        date: DateOnly.display(prediction!.predictedStart!),
        title: 'Period berikutnya',
        subtitle: 'Keyakinan ${prediction!.confidence?.label ?? 'rendah'}',
      ));
    }
    if (cards.isEmpty) {
      return CycleCareCard(
        child: Row(
          children: [
            const Icon(Icons.auto_graph_rounded,
                color: CycleCareColors.periodStrong),
            const SizedBox(width: CycleCareSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data belum cukup',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
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
    final cardsLayout = LayoutBuilder(
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
          children: cards.map((card) => SizedBox(width: width, child: card)).toList(),
        );
      },
    );
    if (!showFertile || fertility == null) return cardsLayout;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cardsLayout,
        const SizedBox(height: CycleCareSpacing.sm),
        const Text(
          'Perkiraan masa subur tidak boleh digunakan sebagai metode kontrasepsi.',
        ),
      ],
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.date,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
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
                Icon(icon, color: iconColor),
                const Spacer(),
                const Icon(Icons.arrow_outward_rounded, size: 18),
              ],
            ),
            const SizedBox(height: CycleCareSpacing.lg),
            Text(date, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 3),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 2),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.insights, required this.ringData});

  final CycleInsights? insights;
  final CycleRingData ringData;

  @override
  Widget build(BuildContext context) {
    final status = insights?.status;
    final title = status?.currentCycleDay == null
        ? 'Hari ini'
        : 'Hari ini — Hari ke-${status!.currentCycleDay}';
    final subtitle = status?.currentMenstruationDay != null
        ? 'Period sedang berlangsung'
        : status?.isLate == true
            ? 'Perkiraan period telah lewat'
            : insights?.fertility != null
                ? 'Perkiraan fase siklus berdasarkan catatanmu'
                : 'Data belum cukup untuk membuat perkiraan lengkap';
    return CycleCareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 5),
          Text(subtitle),
          const SizedBox(height: CycleCareSpacing.lg),
          _CycleTimeline(data: ringData),
        ],
      ),
    );
  }
}

class _CycleTimeline extends StatelessWidget {
  const _CycleTimeline({required this.data});

  final CycleRingData data;

  @override
  Widget build(BuildContext context) => Semantics(
        label: data.semanticLabel,
        child: ExcludeSemantics(
          child: SizedBox(
            height: 24,
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: CycleCareColors.divider,
                      borderRadius: BorderRadius.circular(CycleCareRadius.pill),
                    ),
                  ),
                  for (final segment in data.segments)
                    Positioned(
                      left: constraints.maxWidth * segment.start.clamp(0, 1),
                      width: constraints.maxWidth *
                          (segment.end - segment.start).clamp(0, 1),
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: segment.color,
                          borderRadius:
                              BorderRadius.circular(CycleCareRadius.pill),
                        ),
                      ),
                    ),
                  if (data.todayProgress != null)
                    Positioned(
                      left: (constraints.maxWidth - 18) *
                          data.todayProgress!.clamp(0, 1),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: CycleCareColors.textPrimary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _LateCard extends StatelessWidget {
  const _LateCard({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) => CycleCareCard(
        color: CycleCareColors.ovulationSoft.withValues(alpha: 0.76),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded,
                color: CycleCareColors.warning),
            const SizedBox(width: CycleCareSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terlambat $days hari dari rentang perkiraan',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Perubahan siklus dapat terjadi karena banyak faktor. CycleCare tidak dapat menentukan penyebabnya.',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _InsightCards extends StatelessWidget {
  const _InsightCards({required this.statistics, required this.records});

  final CycleStatistics? statistics;
  final List<PeriodRecord> records;

  @override
  Widget build(BuildContext context) {
    final completed = records.where((record) => record.endDate != null).toList();
    final latest = completed.isEmpty ? null : completed.last;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 680;
        final cards = [
          CycleCareCard(
            onTap: () => context.push('/statistics'),
            semanticLabel: 'Buka statistik pribadi',
            child: Row(
              children: [
                const _InsightIcon(
                  icon: Icons.insights_rounded,
                  color: CycleCareColors.fertileSoft,
                ),
                const SizedBox(width: CycleCareSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statistics?.pattern.label ?? 'Data belum cukup',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statistics?.averageCycleLength == null
                            ? 'Statistik pribadi sedang disiapkan.'
                            : 'Rata-rata siklus ${_number(statistics!.averageCycleLength)} hari',
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
          CycleCareCard(
            onTap: latest == null
                ? null
                : () => context.push('/summary/${latest.id}'),
            semanticLabel: latest == null ? null : 'Buka ringkasan period terakhir',
            child: Row(
              children: [
                const _InsightIcon(
                  icon: Icons.summarize_outlined,
                  color: CycleCareColors.predictionSoft,
                ),
                const SizedBox(width: CycleCareSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Period terakhir',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        latest == null
                            ? 'Belum ada period selesai.'
                            : '${DateOnly.display(latest.startDate)} · ${latest.periodDurationDays ?? '-'} hari',
                      ),
                    ],
                  ),
                ),
                if (latest != null) const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ];
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards.first),
              const SizedBox(width: CycleCareSpacing.md),
              Expanded(child: cards.last),
            ],
          );
        }
        return Column(
          children: [
            cards.first,
            const SizedBox(height: CycleCareSpacing.md),
            cards.last,
          ],
        );
      },
    );
  }
}

class _InsightIcon extends StatelessWidget {
  const _InsightIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: CycleCareColors.textPrimary),
      );
}

CycleRingData _buildRingData({
  required List<PeriodRecord> records,
  required CyclePrediction? prediction,
  required CycleInsights? insights,
  required bool showFertile,
  required bool showOvulation,
}) {
  final status = insights?.status;
  final statistics = insights?.statistics;
  final latest = records.isEmpty ? null : records.last;
  final cycleLength = prediction?.baselineCycleDays ??
      statistics?.latestCycleLength ??
      statistics?.averageCycleLength?.round();
  final cycleStart = latest?.startDate;
  final segments = <CycleRingSegment>[];

  double? fractionForDay(int? day, {bool end = false}) {
    if (day == null || cycleLength == null || cycleLength <= 0) return null;
    final value = end ? day / cycleLength : (day - 1) / cycleLength;
    return value.clamp(0.0, 1.0);
  }

  int? dayForDate(DateTime? date) {
    if (date == null || cycleStart == null) return null;
    return DateUtils.dateOnly(date)
            .difference(DateUtils.dateOnly(cycleStart))
            .inDays +
        1;
  }

  final periodDays = latest?.periodDurationDays ?? status?.currentMenstruationDay;
  final periodEnd = fractionForDay(periodDays, end: true);
  if (periodEnd != null) {
    segments.add(CycleRingSegment(
      start: 0,
      end: periodEnd,
      color: CycleCareColors.period,
    ));
  }

  final fertility = insights?.fertility;
  if (showFertile && fertility != null) {
    final start = fractionForDay(dayForDate(fertility.fertileWindowStart));
    final end = fractionForDay(
      dayForDate(fertility.fertileWindowEnd),
      end: true,
    );
    if (start != null && end != null) {
      segments.add(CycleRingSegment(
        start: start,
        end: end,
        color: CycleCareColors.fertileStrong,
      ));
    }
  }

  if (prediction?.windowStart != null && prediction?.windowEnd != null) {
    final start = fractionForDay(dayForDate(prediction!.windowStart));
    final end = fractionForDay(dayForDate(prediction.windowEnd), end: true);
    if (start != null && end != null) {
      segments.add(CycleRingSegment(
        start: start,
        end: end,
        color: CycleCareColors.prediction,
      ));
    }
  }

  final todayProgress = fractionForDay(status?.currentCycleDay);
  final ovulationProgress = showOvulation
      ? fractionForDay(dayForDate(fertility?.ovulationCenter))
      : null;

  final ongoing = latest?.endDate == null && latest != null;
  final late = status?.isLate == true;
  final now = DateUtils.dateOnly(DateTime.now());
  final predictedStart = prediction?.predictedStart == null
      ? null
      : DateUtils.dateOnly(prediction!.predictedStart!);
  final daysUntilPrediction = predictedStart?.difference(now).inDays;

  final title = ongoing
      ? 'Hari ke-${status?.currentMenstruationDay ?? 1}'
      : late
          ? 'Terlambat ${status!.lateDays} hari'
          : daysUntilPrediction != null && daysUntilPrediction >= 0
              ? '$daysUntilPrediction hari lagi'
              : status?.currentCycleDay != null
                  ? 'Hari ke-${status!.currentCycleDay}'
                  : 'Data belum cukup';
  final subtitle = ongoing
      ? 'Period berlangsung'
      : late
          ? 'Siklus dapat berubah'
          : daysUntilPrediction != null && daysUntilPrediction >= 0
              ? 'Perkiraan period berikutnya'
              : status?.currentCycleDay != null
                  ? 'dari siklusmu'
                  : 'Catat siklus berikutnya';

  final semantics = <String>[
    if (status?.currentCycleDay != null)
      'Hari ke-${status!.currentCycleDay} dari siklus.',
    if (status?.currentMenstruationDay != null)
      'Hari ke-${status!.currentMenstruationDay} period.',
    if (late) 'Perkiraan period telah lewat ${status!.lateDays} hari.',
    if (prediction?.predictedStart != null)
      'Perkiraan period berikutnya ${DateOnly.display(prediction!.predictedStart!)}.',
    if (showFertile && fertility != null)
      'Masa subur diperkirakan ${DateOnly.display(fertility.fertileWindowStart)} sampai ${DateOnly.display(fertility.fertileWindowEnd)}.',
    if (showOvulation && fertility != null)
      'Ovulasi diperkirakan ${DateOnly.display(fertility.ovulationCenter)}.',
    if (status?.currentCycleDay == null)
      'Data belum cukup untuk menampilkan siklus lengkap.',
  ].join(' ');

  return CycleRingData(
    title: title,
    subtitle: subtitle,
    semanticLabel: semantics,
    todayProgress: todayProgress,
    ovulationProgress: ovulationProgress,
    segments: segments,
    centerIcon: ongoing
        ? Icons.water_drop_rounded
        : late
            ? Icons.schedule_rounded
            : Icons.favorite_rounded,
  );
}

String _number(double? value) =>
    value == null ? 'Belum ada' : value.toStringAsFixed(1);
