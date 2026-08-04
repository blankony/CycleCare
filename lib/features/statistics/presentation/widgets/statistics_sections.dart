import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/design/cycle_care_design.dart';
import '../../../../app/widgets.dart';
import '../../../../domain/entities/cycle_insights.dart';
import '../../../../domain/entities/enums.dart';

class StatisticsInsufficientState extends StatelessWidget {
  const StatisticsInsufficientState({super.key});

  @override
  Widget build(BuildContext context) => const EmptyState(
        icon: Icons.data_usage_outlined,
        title: 'Data belum cukup',
        message:
            'Diperlukan setidaknya dua siklus yang telah selesai untuk menampilkan statistik yang bermakna.',
      );
}

class StatisticsContent extends StatelessWidget {
  const StatisticsContent({required this.value, super.key});

  final CycleStatistics value;

  @override
  Widget build(BuildContext context) => ListView(
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
                    'Berdasarkan ${value.cycleLengthSamples} siklus terakhir',
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
              label: 'Rata-rata panjang siklus',
              accent: CycleCareColors.period,
            ),
            _MetricCard(
              icon: Icons.water_drop_outlined,
              value: _decimal(value.averagePeriodDuration),
              label: 'Rata-rata durasi period',
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
                  label: 'Siklus terpendek',
                  value: _days(value.shortestCycle),
                ),
              ),
              VerticalDivider(color: context.cycleCareColors.divider),
              Expanded(
                child: _CompactMetric(
                  label: 'Siklus terpanjang',
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
        .map((entry) => 'Siklus ${entry.$1 + 1}, ${entry.$2} hari')
        .join('. ');

    return CycleCareCard(
      child: Semantics(
        container: true,
        label:
            'Riwayat panjang siklus. Skala dimulai dari nol hingga $scaleMaximum hari. $summary.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Riwayat panjang siklus',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: CycleCareSpacing.xxs),
            Text(
              'Tiga panjang siklus valid paling baru. Skala dimulai dari 0 hari.',
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
          highlighted ? 'Terbaru' : 'Siklus ${index + 1}',
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
            'Intensitas aliran',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: CycleCareSpacing.xxs),
          Text(
            total < 3
                ? 'Catat aliran harian pada beberapa hari untuk melihat distribusi.'
                : 'Berdasarkan $total catatan aliran harian.',
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
      label: '${flow.label}, $percentage persen, $count dari $total catatan',
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
                'Statistik dihitung dari hingga 12 period terbaru yang valid. '
                'Saat ini tersedia ${value.cycleLengthSamples} panjang siklus '
                'dan ${value.periodDurationSamples} durasi period.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
}

String _days(int? value) => value == null ? 'Belum ada' : '$value hari';

String _decimal(double? value) =>
    value == null ? 'Belum ada' : '${value.toStringAsFixed(1)} hari';

String _patternDescription(CycleStatistics value) {
  final variability = value.cycleVariability;
  return switch (value.pattern) {
    CyclePattern.consistent => variability == null
        ? 'Panjang siklus memiliki variasi yang kecil.'
        : 'Variasi median ${variability.toStringAsFixed(1)} hari, sehingga pola terbaru relatif stabil.',
    CyclePattern.variable => variability == null
        ? 'Panjang siklus menunjukkan beberapa variasi.'
        : 'Variasi median ${variability.toStringAsFixed(1)} hari. Perubahan antar-siklus masih dapat terjadi.',
    CyclePattern.highlyVariable => variability == null
        ? 'Panjang siklus menunjukkan variasi yang lebih besar.'
        : 'Variasi median ${variability.toStringAsFixed(1)} hari. Gunakan pola ini sebagai gambaran, bukan kepastian.',
    CyclePattern.insufficientData =>
      'Belum cukup panjang siklus untuk menjelaskan variasi.',
  };
}
