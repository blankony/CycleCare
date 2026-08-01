import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../domain/entities/cycle_insights.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/services/clinical_reference_service.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(cycleStatisticsProvider);
    return Scaffold(
      appBar: const CycleCareAppBar(title: 'Statistik pribadi'),
      body: statistics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Statistik belum dapat dimuat: $error')),
        data: (value) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _MetricGrid(value: value),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.insights_outlined),
                title: Text(value.pattern.label),
                subtitle: Text(value.cycleVariability == null
                    ? 'Perlu setidaknya dua panjang siklus.'
                    : 'Variabilitas median: ${value.cycleVariability!.toStringAsFixed(1)} hari'),
              ),
            ),
            const SizedBox(height: 12),
            _ClassificationCard(value: value),
            const SizedBox(height: 12),
            _ReferenceCard(value: value),
            const SizedBox(height: 12),
            const Text(
              'Statistik menggunakan hingga 12 period terbaru yang valid. Pola ini bersifat deskriptif dan bukan diagnosis.',
            ),
            const SizedBox(height: 12),
            const MedicalDisclaimer(),
          ],
        ),
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.value});

  final CycleStatistics value;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      ('Period tercatat', '${value.recordedPeriods}'),
      ('Period selesai', '${value.completedPeriods}'),
      ('Hari siklus', '${value.currentCycleDay ?? '-'}'),
      ('Siklus terbaru', _days(value.latestCycleLength)),
      ('Rata-rata siklus', _decimal(value.averageCycleLength)),
      ('Median siklus', _decimal(value.medianCycleLength)),
      ('Siklus terpendek', _days(value.shortestCycle)),
      ('Siklus terpanjang', _days(value.longestCycle)),
      ('Rata-rata period', _decimal(value.averagePeriodDuration)),
      ('Period terpendek', _days(value.shortestPeriod)),
      ('Period terpanjang', _days(value.longestPeriod)),
      ('Flow paling sering', value.mostCommonFlow?.label ?? 'Belum ada'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(metrics[index].$1,
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 8),
              Text(metrics[index].$2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassificationCard extends StatelessWidget {
  const _ClassificationCard({required this.value});

  final CycleStatistics value;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Riwayat dibandingkan perkiraan',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              for (final classification in [
                PeriodClassification.early,
                PeriodClassification.onWindow,
                PeriodClassification.late,
              ])
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(_icon(classification)),
                  title: Text(classification.label),
                  trailing: Text(
                      '${value.classificationCounts[classification] ?? 0}'),
                ),
            ],
          ),
        ),
      );
}

class _ReferenceCard extends StatelessWidget {
  const _ReferenceCard({required this.value});

  final CycleStatistics value;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Referensi umum dewasa'),
          subtitle: Text(
              'Perbandingan terbaru: siklus ${_reference(value.latestCycleLength)}; durasi period ${_reference(value.latestCycleLength == null ? null : value.longestPeriod)}.\nRentang siklus ${AdultCycleReference.minimumCycleDays}–${AdultCycleReference.maximumCycleDays} hari, durasi period maksimal ${AdultCycleReference.maximumBleedingDays} hari.'),
        ),
      );
}

IconData _icon(PeriodClassification value) => switch (value) {
      PeriodClassification.early => Icons.arrow_upward,
      PeriodClassification.onWindow => Icons.horizontal_rule,
      PeriodClassification.late => Icons.arrow_downward,
      PeriodClassification.insufficientData => Icons.help_outline,
    };

String _days(int? value) => value == null ? 'Belum ada' : '$value hari';
String _decimal(double? value) =>
    value == null ? 'Belum ada' : '${value.toStringAsFixed(1)} hari';
String _reference(int? value) => value == null ? 'belum cukup' : '$value hari';
