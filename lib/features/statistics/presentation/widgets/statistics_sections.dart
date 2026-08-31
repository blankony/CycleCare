import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/design/cycle_care_design.dart';
import '../../../../app/widgets.dart';
import '../../../../domain/entities/cycle_insights.dart';
import '../../../../domain/entities/enums.dart';
import '../../../../l10n/app_localizations.dart';

class StatisticsInsufficientState extends StatelessWidget {
  const StatisticsInsufficientState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
        icon: Icons.data_usage_outlined,
        title: l10n.homeInsufficientDataTitle,
        message: l10n.homeInsufficientDataBody,
      );
  }
}

class StatisticsContent extends StatelessWidget {
  const StatisticsContent({required this.value, super.key});

  final CycleStatistics value;

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.fromLTRB(
          CycleCareSpacing.page,
          CycleCareSpacing.md,
          CycleCareSpacing.page,
          CycleCareSpacing.xxxl,
        ),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Based on ${value.cycleLengthSamples} cycles',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.cycleCareColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: CycleCareSpacing.md),
                  _HeroMetrics(value: value),
                  const SizedBox(height: CycleCareSpacing.md),
                  _CycleRangeCard(value: value),
                  const SizedBox(height: CycleCareSpacing.md),
                  _PatternCard(value: value),
                  const SizedBox(height: CycleCareSpacing.md),
                  _RecentCycleChart(values: value.recentCycleLengths),
                  const SizedBox(height: CycleCareSpacing.md),
                  _FlowDistribution(flowCounts: value.flowCounts),
                  const SizedBox(height: CycleCareSpacing.md),
                  _MethodologyCard(value: value),
                  const SizedBox(height: CycleCareSpacing.md),
                  const MedicalDisclaimer(),
                ],
              ),
            ),
          ),
        ],
      );
  }
}

class _HeroMetrics extends StatelessWidget {
  const _HeroMetrics({required this.value});

  final CycleStatistics value;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final metrics = [
            _MetricCard(
              icon: Icons.repeat_rounded,
              value: _decimal(value.averageCycleLength),
              label: 'Avg cycle length',
              accent: CycleCareColors.period,
            ),
            _MetricCard(
              icon: Icons.water_drop_outlined,
              value: _decimal(value.averagePeriodDuration),
              label: 'Avg period duration',
              accent: CycleCareColors.period,
            ),
          ];
          if (constraints.maxWidth < 360) {
            return Column(
              children: [
                metrics.first,
                const SizedBox(height: CycleCareSpacing.sm),
                metrics.last,
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: metrics.first),
              const SizedBox(width: CycleCareSpacing.sm),
              Expanded(child: metrics.last),
            ],
          );
        },
      );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) => CycleCareCard(
        child: Semantics(
          label: '$label, $value',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: accent),
              const SizedBox(height: CycleCareSpacing.xs),
              Text(
                value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: CycleCareSpacing.xxs),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.cycleCareColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
}

class _CycleRangeCard extends StatelessWidget {
  const _CycleRangeCard({required this.value});

  final CycleStatistics value;

  @override
  Widget build(BuildContext context) => CycleCareCard(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'Shortest cycle',
                  value: _days(value.shortestCycle),
                ),
              ),
              VerticalDivider(color: context.cycleCareColors.divider),
              Expanded(
                child: _CompactMetric(
                  label: 'Longest cycle',
                  value: _days(value.longestCycle),
                ),
              ),
            ],
          ),
        ),
      );
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Semantics(
        label: '$label, $value',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: CycleCareSpacing.xs),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.cycleCareColors.textSecondary,
                    ),
              ),
              const SizedBox(height: CycleCareSpacing.xxs),
              Text(
                value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
}

class _PatternCard extends StatelessWidget {
  const _PatternCard({required this.value});

  final CycleStatistics value;

  @override
  Widget build(BuildContext context) => CycleCareCard(
        color: context.cycleCareColors.surfaceMuted,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: CycleCareColors.success.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: CycleCareColors.success,
              ),
            ),
            const SizedBox(width: CycleCareSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.pattern.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: CycleCareSpacing.xxs),
                  Text(
                    _patternDescription(value),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.cycleCareColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _RecentCycleChart extends StatelessWidget {
  const _RecentCycleChart({required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) return const SizedBox.shrink();
    final maximum = values.reduce(math.max);
    final scaleMaximum = math.max(30, ((maximum + 9) ~/ 10) * 10);
    final summary = values.indexed
        .map((entry) => 'Cycle ${entry.$1 + 1}, ${entry.$2} days')
        .join('. ');

    return CycleCareCard(
      child: Semantics(
        container: true,
        label:
            'Cycle length history. Scale 0 to $scaleMaximum days. $summary.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cycle length history',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: CycleCareSpacing.xxs),
            Text(
              'Three most recent valid cycle lengths. Scale starts at 0.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.cycleCareColors.textSecondary,
                  ),
            ),
            const SizedBox(height: CycleCareSpacing.lg),
            ExcludeSemantics(
              child: SizedBox(
                height: 190,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final entry in values.indexed) ...[
                      Expanded(
                        child: _CycleBar(
                          index: entry.$1,
                          value: entry.$2,
                          scaleMaximum: scaleMaximum,
                          highlighted: entry.$1 == values.length - 1,
                        ),
                      ),
                      if (entry.$1 != values.length - 1)
                        const SizedBox(width: CycleCareSpacing.sm),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CycleBar extends StatelessWidget {
  const _CycleBar({
    required this.index,
    required this.value,
    required this.scaleMaximum,
    required this.highlighted,
  });

  final int index;
  final int value;
  final int scaleMaximum;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final barHeight = 120 * value / scaleMaximum;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('$value', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: CycleCareSpacing.xxs),
        Container(
          width: 44,
          height: barHeight,
          decoration: BoxDecoration(
            color: highlighted
                ? CycleCareColors.periodSoft
                : CycleCareColors.fertileSoft,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(CycleCareRadius.small),
            ),
            border: Border.all(
              color: highlighted
                  ? CycleCareColors.period
                  : CycleCareColors.fertileStrong,
            ),
          ),
        ),
        const SizedBox(height: CycleCareSpacing.xs),
        Text(
          highlighted ? 'Latest' : 'Cycle ${index + 1}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _FlowDistribution extends StatelessWidget {
  const _FlowDistribution({required this.flowCounts});

  final Map<MenstrualFlow, int> flowCounts;

  static const _flows = [
    MenstrualFlow.spotting,
    MenstrualFlow.light,
    MenstrualFlow.medium,
    MenstrualFlow.heavy,
  ];

  @override
  Widget build(BuildContext context) {
    final total = flowCounts.values.fold<int>(0, (sum, count) => sum + count);
    return CycleCareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flow intensity',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: CycleCareSpacing.xxs),
          Text(
            total < 3
                ? 'Log daily flow for a few days to see distribution.'
                : 'Based on $total flow records.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.cycleCareColors.textSecondary,
                ),
          ),
          if (total >= 3) ...[
            const SizedBox(height: CycleCareSpacing.md),
            for (final flow in _flows) ...[
              _FlowPercentageRow(
                flow: flow,
                count: flowCounts[flow] ?? 0,
                total: total,
              ),
              if (flow != _flows.last)
                const SizedBox(height: CycleCareSpacing.sm),
            ],
          ],
        ],
      ),
    );
  }
}

class _FlowPercentageRow extends StatelessWidget {
  const _FlowPercentageRow({
    required this.flow,
    required this.count,
    required this.total,
  });

  final MenstrualFlow flow;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fraction = count / total;
    final percentage = (fraction * 100).round();
    return Semantics(
      label: '${flow.label}, $percentage%, $count of $total',
      child: Row(
        children: [
          SizedBox(
            width: 68,
            child: Text(
              flow.label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: CycleCareSpacing.xs),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(CycleCareRadius.pill),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8,
                backgroundColor: context.cycleCareColors.surfaceMuted,
                color: CycleCareColors.period,
              ),
            ),
          ),
          const SizedBox(width: CycleCareSpacing.xs),
          SizedBox(
            width: 42,
            child: Text(
              '$percentage%',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodologyCard extends StatelessWidget {
  const _MethodologyCard({required this.value});

  final CycleStatistics value;

  @override
  Widget build(BuildContext context) => CycleCareCard(
        color: context.cycleCareColors.surfaceMuted,
        padding: const EdgeInsets.all(CycleCareSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox.square(
              dimension: 48,
              child: Icon(Icons.info_outline_rounded),
            ),
            const SizedBox(width: CycleCareSpacing.sm),
            Expanded(
              child: Text(
                'Statistics use up to 12 most recent valid periods. '
                'Currently ${value.cycleLengthSamples} cycle lengths '
                'and ${value.periodDurationSamples} period durations.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
}

String _days(int? value) => value == null ? '—' : '$value days';

String _decimal(double? value) =>
    value == null ? '—' : '${value.toStringAsFixed(1)} days';

String _patternDescription(CycleStatistics value) {
  final variability = value.cycleVariability;
  return switch (value.pattern) {
    CyclePattern.consistent => variability == null
        ? 'Cycle length shows small variation.'
        : 'Median variability ${variability.toStringAsFixed(1)} days, recent pattern relatively stable.',
    CyclePattern.variable => variability == null
        ? 'Cycle length shows some variation.'
        : 'Median variability ${variability.toStringAsFixed(1)} days. Changes between cycles may occur.',
    CyclePattern.highlyVariable => variability == null
        ? 'Cycle length shows larger variation.'
        : 'Median variability ${variability.toStringAsFixed(1)} days. Use as overview, not certainty.',
    CyclePattern.insufficientData =>
      'Not enough cycle lengths to describe variation.',
  };
}
