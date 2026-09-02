import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../core/errors/app_failure.dart';
import '../../../domain/entities/cycle_insights.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/period_record.dart';
import '../../../domain/entities/prediction.dart';
import '../../../domain/entities/sync_state.dart';
import '../../../domain/entities/user_cycle_settings.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/cycle_ring.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final periods = ref.watch(activePeriodsProvider);
    final prediction = ref.watch(predictionProvider).valueOrNull;
    final settings = ref.watch(userCycleSettingsProvider).valueOrNull;
    final insights = ref.watch(cycleInsightsProvider).valueOrNull;
    final syncSnapshot = ref.watch(syncSnapshotProvider);
    ref.watch(homeWidgetSyncProvider);

    ref.listen(periodActionsProvider, (_, next) {
      next.whenOrNull(
        error: (error, __) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is AppFailure
                  ? error.message
                  : error.toString().isNotEmpty
                      ? error.toString()
                      : l10n.periodFormSaveFailed,
            ),
          ),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CycleCareAppBar(
        title: l10n.appTitle,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: l10n.tooltipOpenAccount,
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: CycleCareBackground(
        child: periods.when(
          loading: () => CycleCareLoadingState(message: l10n.loadingPreparingCycle),
          error: (_, __) => CycleCareErrorState(
            message: l10n.errorDataSafeRetry,
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
              await ref.read(syncControllerProvider).synchronizeNow();
              ref.invalidate(activePeriodsProvider);
              ref.invalidate(predictionProvider);
              ref.invalidate(cycleInsightsProvider);
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
    final l10n = AppLocalizations.of(context);
    final showFertile = settings?.showFertileWindow == true;
    final showOvulation = settings?.showOvulationEstimate == true;
    final ongoing =
        records.where((record) => record.endDate == null).firstOrNull;
    final timelineData = _buildTimelineData(
      context: context,
      records: records,
      prediction: prediction,
      insights: insights,
      showFertile: showFertile,
      showOvulation: showOvulation,
    );
    final showsSyncBanner = {
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
                      CycleCareSectionHeader(
                        title: l10n.homeSectionCycleForecast,
                        subtitle: l10n.homeSectionForecastSubtitle,
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
    final l10n = AppLocalizations.of(context);
    final status = _syncChip(l10n, syncSnapshot.status);
    return CycleCareStatusChip(
      label: status.label,
      icon: status.icon,
      tone: status.tone,
    );
  }

  _HeaderStatus _syncChip(AppLocalizations l10n, SyncGateStatus status) =>
      switch (status) {
        SyncGateStatus.ready => _HeaderStatus(
            label: l10n.statusSynced,
            icon: Icons.cloud_done_outlined,
            tone: CycleCareStatusTone.success,
          ),
        SyncGateStatus.synchronizing => _HeaderStatus(
            label: l10n.statusSyncing,
            icon: Icons.sync_rounded,
            tone: CycleCareStatusTone.info,
          ),
        SyncGateStatus.offlineReady => _HeaderStatus(
            label: l10n.statusOffline,
            icon: Icons.cloud_off_outlined,
            tone: CycleCareStatusTone.warning,
          ),
        SyncGateStatus.failed => _HeaderStatus(
            label: l10n.statusSyncNeeded,
            icon: Icons.sync_problem_rounded,
            tone: CycleCareStatusTone.error,
          ),
        _ => _HeaderStatus(
            label: l10n.statusSavedOnDevice,
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
    final l10n = AppLocalizations.of(context);
    final status = insights?.status;
    final currentCycleDay = status?.currentCycleDay;
    final predictionRange = _predictionRange(context, prediction);
    final empty = records.isEmpty;
    final colors = context.cycleCareColors;

    return CycleCareCard(
      color: Theme.of(context).brightness == Brightness.dark
          ? CycleCareColors.darkSurface
          : CycleCareColors.surface,
      semanticLabel: _heroSemanticLabel(context,
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
                      l10n.homeToday,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: CycleCareSpacing.xxs),
                    Text(
                      empty
                          ? l10n.homeStartYourLog
                          : currentCycleDay == null
                              ? l10n.homeDataGrowing
                              : l10n.homeDayOfCycle(currentCycleDay),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                            color: CycleCareColors.deepNavy,
                          ),
                    ),
                    const SizedBox(height: CycleCareSpacing.xs),
                    Text(
                      _cycleStatusLabel(context, status, insights?.fertility),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              if (!empty)
                CycleCareStatusChip(
                  label: status?.isLate == true
                      ? l10n.homeChipLate
                      : ongoing == null
                          ? l10n.homeChipActiveCycle
                          : l10n.homeChipPeriodOngoing,
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
                color: CycleCareColors.iceBlue.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.18
                      : 1,
                ),
                borderRadius: BorderRadius.circular(CycleCareRadius.small),
                border: Border.all(color: colors.divider),
              ),
              child: Text(
                l10n.homeLateByDays(status!.lateDays),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CycleCareColors.warning,
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
                            ? l10n.homeNoPeriodEstimate
                            : l10n.homeNextPeriodEstimate,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: CycleCareSpacing.xxs),
                      Text(
                        predictionRange ?? l10n.homeLogAFewCycles,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (prediction?.ready == true) ...[
                        const SizedBox(height: CycleCareSpacing.xxs),
                        Text(
                          l10n.homeBasedOnCycles(prediction!.basedOnCycles, prediction!.confidence?.label.toLowerCase() ?? 'low'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: CycleCareSpacing.md),
          _QuickOngoingToggle(ongoing: ongoing),
          const SizedBox(height: CycleCareSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.push('/add-period', extra: ongoing),
              icon: Icon(
                  ongoing == null ? Icons.add_rounded : Icons.edit_rounded),
              label: Text(ongoing == null ? l10n.actionRecordPeriod : l10n.actionUpdatePeriod),
            ),
          ),
        ],
      ),
    );
  }

  String _heroSemanticLabel(BuildContext context, {
    required CycleStatus? status,
    required CyclePrediction? prediction,
    required bool empty,
  }) {
    final l10n = AppLocalizations.of(context);
    if (empty) {
      return l10n.semanticsCycleHeroEmpty;
    }
    return [
      if (status?.currentCycleDay != null)
        l10n.homeDayOfCycle(status!.currentCycleDay!),
      if (status?.currentMenstruationDay != null)
        l10n.homeCycleStatusPeriodDay(status!.currentMenstruationDay!),
      if (status?.isLate == true)
        l10n.homeLateByDays(status!.lateDays),
      if (prediction?.windowStart != null && prediction?.windowEnd != null)
        '${l10n.homeNextPeriodEstimate} ${DateOnly.display(prediction!.windowStart!, l10n.localeName)} - ${DateOnly.display(prediction.windowEnd!, l10n.localeName)}.',
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CycleCareCard(
        padding: const EdgeInsets.all(CycleCareSpacing.lg),
        semanticLabel: data.semanticLabel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.homeTimelineCurrentCycle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: CycleCareSpacing.md),
            ExcludeSemantics(child: _CycleTimeline(data: data)),
            const SizedBox(height: CycleCareSpacing.sm),
            Wrap(
              spacing: CycleCareSpacing.md,
              runSpacing: CycleCareSpacing.xs,
              children: [
                _TimelineLegend(
                  color: CycleCareColors.period,
                  label: l10n.homeTimelinePeriodRecorded,
                  icon: Icons.water_drop_rounded,
                ),
                if (showFertile)
                  _TimelineLegend(
                    color: CycleCareColors.fertileStrong,
                    label: l10n.homeTimelineFertile,
                    icon: Icons.blur_circular_rounded,
                  ),
                if (showOvulation)
                  _TimelineLegend(
                    color: CycleCareColors.ovulation,
                    label: l10n.homeTimelineOvulation,
                    icon: Icons.sunny_snowing,
                  ),
                if (showPrediction)
                  _TimelineLegend(
                    color: CycleCareColors.prediction,
                    label: l10n.homeTimelinePredictedPeriod,
                    icon: Icons.calendar_month_outlined,
                  ),
              ],
            ),
          ],
        ),
      );
  }
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
    final l10n = AppLocalizations.of(context);
    final cards = <Widget>[];
    if (showFertile && fertility != null) {
      cards.add(
        _PhaseCard(
          icon: Icons.blur_circular_rounded,
          color: Theme.of(context).colorScheme.secondaryContainer,
          iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
          eyebrow: l10n.homeForthcoming,
          date:
              '${_compactDate(context, fertility!.fertileWindowStart)}–${_compactDate(context, fertility!.fertileWindowEnd)}',
          title: l10n.homePhaseFertile,
          subtitle: l10n.homeConfidence(fertility!.confidence.label.toLowerCase()),
        ),
      );
    }
    if (showOvulation && fertility != null) {
      cards.add(
        _PhaseCard(
          icon: Icons.sunny_snowing,
          color: Theme.of(context).colorScheme.tertiaryContainer,
          iconColor: Theme.of(context).colorScheme.onTertiaryContainer,
          eyebrow: l10n.homeForthcoming,
          date: _compactDate(context, fertility!.ovulationCenter),
          title: l10n.homePhaseOvulationEstimate,
          subtitle: l10n.homeRangeMayChange,
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
          color: CycleCareColors.iceBlue,
          iconColor: CycleCareColors.deepNavy,
          eyebrow: l10n.homeForthcoming,
          date: _predictionRange(context, prediction)!,
          title: l10n.homePhaseNextPeriod,
          subtitle: days >= 0
              ? l10n.homeInAboutDays(days)
              : l10n.homePredictionRangePast,
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
                    l10n.homeInsufficientDataTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: CycleCareSpacing.xxs),
                  Text(l10n.homeInsufficientDataBody),
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
    final l10n = AppLocalizations.of(context);
    final recent = [...records]
      ..sort((first, second) => first.startDate.compareTo(second.startDate));
    final visible =
        recent.length > 3 ? recent.sublist(recent.length - 3) : recent;
    final average = statistics?.averageCycleLength;
    final summary = average == null
        ? l10n.homePromptLogNext
        : l10n.homeAverageCycle(average.toStringAsFixed(1), statistics!.pattern.label.toLowerCase());

    return CycleCareCard(
      semanticLabel: '${visible.isEmpty ? l10n.homeRecentSummaryGeneric : l10n.homeRecentSummaryTitle(visible.length)}. $summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  visible.isEmpty
                      ? l10n.homeRecentSummaryGeneric
                      : l10n.homeRecentSummaryTitle(visible.length),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/statistics'),
                child: Text(l10n.homeViewStatistics),
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
          _monthLabel(context, record.startDate),
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  String _monthLabel(BuildContext context, DateTime date) {
    final locale = AppLocalizations.of(context).localeName;
    final id = locale.startsWith('id') ? 'id_ID' : 'en';
    return DateFormat('MMM', id).format(record.startDate);
  }
}

class _QuickOngoingToggle extends ConsumerWidget {
  const _QuickOngoingToggle({required this.ongoing});

  final PeriodRecord? ongoing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final busy = ref.watch(periodActionsProvider).isLoading;
    if (ongoing != null) {
      return OutlinedButton.icon(
        onPressed: busy
            ? null
            : () async {
                try {
                  await ref.read(periodActionsProvider.notifier).finish(ongoing!.id, DateTime.now());
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.snackbarPeriodFinishedToday)),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
        icon: const Icon(Icons.stop_circle_outlined, size: 18),
        label: Text(l10n.calendarFinishPeriodToday),
      );
    }
    return OutlinedButton.icon(
      onPressed: busy
          ? null
          : () async {
              try {
                await ref.read(periodActionsProvider.notifier).create(startDate: DateTime.now());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.snackbarPeriodStartedToday)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
      icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
      label: Text(l10n.actionStartPeriodToday),
    );
  }
}

class _FertilitySafetyNote extends StatelessWidget {
  const _FertilitySafetyNote();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
        container: true,
        label: l10n.homeFertilitySafety,
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
                l10n.homeFertilitySafety,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
  }
}

CycleRingData _buildTimelineData({
  required BuildContext context,
  required List<PeriodRecord> records,
  required CyclePrediction? prediction,
  required CycleInsights? insights,
  required bool showFertile,
  required bool showOvulation,
}) {
  final l10n = AppLocalizations.of(context);
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

  String localeName = l10n.localeName;
  final semantics = <String>[
    if (status?.currentCycleDay != null)
      l10n.homeDayOfCycle(status!.currentCycleDay!),
    if (periodEnd != null) l10n.homeTimelinePeriodRecorded,
    if (showFertile && fertility != null)
      '${l10n.homeTimelineFertile} ${DateOnly.display(fertility.fertileWindowStart, localeName)} - ${DateOnly.display(fertility.fertileWindowEnd, localeName)}.',
    if (showOvulation && fertility != null)
      '${l10n.homeTimelineOvulation} ${DateOnly.display(fertility.ovulationCenter, localeName)}.',
    if (prediction?.windowStart != null && prediction?.windowEnd != null)
      '${l10n.homeTimelinePredictedPeriod} ${DateOnly.display(prediction!.windowStart!, localeName)} - ${DateOnly.display(prediction.windowEnd!, localeName)}.',
  ].join(' ');

  return CycleRingData(
    title: status?.currentCycleDay == null
        ? l10n.homeInsufficientDataTitle
        : l10n.homeDayOfCycle(status!.currentCycleDay!),
    subtitle: l10n.homeTimelineCurrentCycle,
    semanticLabel: semantics.isEmpty
        ? l10n.homeInsufficientDataBody
        : semantics,
    todayProgress: fractionForDay(status?.currentCycleDay),
    ovulationProgress: showOvulation
        ? fractionForDay(dayForDate(fertility?.ovulationCenter))
        : null,
    segments: segments,
  );
}

String _cycleStatusLabel(
  BuildContext context,
  CycleStatus? status,
  FertilityEstimate? fertility,
) {
  final l10n = AppLocalizations.of(context);
  if (status?.currentMenstruationDay != null) {
    return l10n.homeCycleStatusPeriodDay(status!.currentMenstruationDay!);
  }
  if (status?.isLate == true) {
    return l10n.homeCycleStatusLate;
  }
  final today = DateOnly.normalize(DateTime.now());
  if (fertility != null) {
    final fertileStart = DateOnly.normalize(fertility.fertileWindowStart);
    final fertileEnd = DateOnly.normalize(fertility.fertileWindowEnd);
    if (!today.isBefore(fertileStart) && !today.isAfter(fertileEnd)) {
      return l10n.homeCycleStatusFertile;
    }
    if (today.isAfter(DateOnly.normalize(fertility.latestOvulation))) {
      return l10n.homeCycleStatusAfterOvulation;
    }
  }
  if (status?.currentCycleDay != null) return l10n.homeCycleStatusOngoing;
  return l10n.homeCycleStatusEmpty;
}

String? _predictionRange(BuildContext context, CyclePrediction? prediction) {
  if (prediction?.ready != true ||
      prediction?.windowStart == null ||
      prediction?.windowEnd == null) {
    return null;
  }
  return '${_compactDate(context, prediction!.windowStart!)}–${_compactDate(context, prediction.windowEnd!)}';
}

String _compactDate(BuildContext context, DateTime date) {
  final locale = AppLocalizations.of(context).localeName;
  final id = locale.startsWith('id') ? 'id_ID' : 'en';
  return DateFormat('d MMM', id).format(DateOnly.normalize(date));
}
