import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/cycle_insights.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/period_record.dart';
import '../../../domain/entities/prediction.dart';

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
        error: (error, _) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString()))),
      );
    });
    return Scaffold(
      appBar: const CycleCareAppBar(title: 'CycleCare'),
      body: periods.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Data belum dapat dimuat: $error')),
        data: (records) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(activePeriodsProvider);
            ref.invalidate(cycleInsightsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
            children: [
              _CurrentCycleCard(status: insights?.status, records: records),
              const SizedBox(height: 12),
              _PredictionCard(prediction: prediction),
              if (insights?.status.isLate == true) ...[
                const SizedBox(height: 12),
                _LateCard(days: insights!.status.lateDays),
              ],
              if (settings?.showOvulationEstimate == true &&
                  insights?.fertility != null) ...[
                const SizedBox(height: 12),
                _OvulationCard(estimate: insights!.fertility!),
              ],
              if (settings?.showFertileWindow == true &&
                  insights?.fertility != null) ...[
                const SizedBox(height: 12),
                _FertileWindowCard(estimate: insights!.fertility!),
              ],
              const SizedBox(height: 12),
              _PatternCard(statistics: insights?.statistics),
              const SizedBox(height: 12),
              _SummaryLink(records: records),
              const SizedBox(height: 12),
              _ActionsCard(records: records),
              const SizedBox(height: 18),
              const MedicalDisclaimer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentCycleCard extends StatelessWidget {
  const _CurrentCycleCard({required this.status, required this.records});

  final CycleStatus? status;
  final List<PeriodRecord> records;

  @override
  Widget build(BuildContext context) {
    final title = status?.currentCycleDay == null
        ? 'Belum ada data siklus'
        : 'Hari ke-${status!.currentCycleDay} dari siklus';
    final subtitle = status?.currentMenstruationDay == null
        ? 'Catat tanggal period untuk melihat hari siklus.'
        : 'Hari ke-${status!.currentMenstruationDay} menstruasi';
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.water_drop_outlined,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(subtitle),
                  if (records.isNotEmpty && records.last.endDate == null)
                    const Text('Period masih berlangsung'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.prediction});

  final CyclePrediction? prediction;

  @override
  Widget build(BuildContext context) {
    final ready = prediction?.predictedStart != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome_outlined),
                const SizedBox(width: 8),
                Text('Perkiraan menstruasi berikutnya',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              ready
                  ? '${DateOnly.display(prediction!.windowStart!)} – ${DateOnly.display(prediction!.windowEnd!)}'
                  : 'Data belum cukup untuk membuat perkiraan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (ready) ...[
              const SizedBox(height: 6),
              Text(
                  'Pusat perkiraan: ${DateOnly.display(prediction!.predictedStart!)}'),
              Text(
                  'Berdasarkan ${prediction!.basedOnCycles} siklus · Keyakinan ${prediction!.confidence!.label}'),
            ],
            const SizedBox(height: 8),
            const Text('Ini adalah perkiraan, bukan diagnosis medis.'),
          ],
        ),
      ),
    );
  }
}

class _LateCard extends StatelessWidget {
  const _LateCard({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text('Terlambat $days hari dari rentang perkiraan'),
          subtitle: const Text(
              'Perubahan siklus dapat terjadi karena banyak faktor. CycleCare tidak dapat menentukan penyebabnya.'),
        ),
      );
}

class _OvulationCard extends StatelessWidget {
  const _OvulationCard({required this.estimate});

  final FertilityEstimate estimate;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const Icon(Icons.blur_on_outlined),
          title: const Text('Perkiraan ovulasi'),
          subtitle: Text(
              'Sekitar ${DateOnly.display(estimate.ovulationCenter)} · Keyakinan ${estimate.confidence.label}'),
        ),
      );
}

class _FertileWindowCard extends StatelessWidget {
  const _FertileWindowCard({required this.estimate});

  final FertilityEstimate estimate;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const Icon(Icons.wb_sunny_outlined),
          title: const Text('Perkiraan masa subur'),
          subtitle: Text(
              '${DateOnly.display(estimate.fertileWindowStart)} – ${DateOnly.display(estimate.fertileWindowEnd)}\nPerkiraan masa subur tidak boleh digunakan sebagai metode kontrasepsi.'),
        ),
      );
}

class _PatternCard extends StatelessWidget {
  const _PatternCard({required this.statistics});

  final CycleStatistics? statistics;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const Icon(Icons.insights_outlined),
          title: Text(statistics?.pattern.label ?? 'Data belum cukup'),
          subtitle: Text(statistics == null
              ? 'Statistik pribadi sedang disiapkan.'
              : 'Rata-rata siklus: ${_number(statistics!.averageCycleLength)} hari'),
          trailing: TextButton(
            onPressed: () => context.push('/statistics'),
            child: const Text('Lihat statistik'),
          ),
        ),
      );
}

class _SummaryLink extends StatelessWidget {
  const _SummaryLink({required this.records});

  final List<PeriodRecord> records;

  @override
  Widget build(BuildContext context) {
    final completed =
        records.where((record) => record.endDate != null).toList();
    if (completed.isEmpty) return const SizedBox.shrink();
    final latest = completed.last;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.summarize_outlined),
        title: const Text('Ringkasan period terakhir'),
        subtitle: Text(DateOnly.display(latest.startDate)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/summary/${latest.id}'),
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({required this.records});

  final List<PeriodRecord> records;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push('/add-period'),
                  icon: const Icon(Icons.add),
                  label: const Text('Catat period'),
                ),
              ),
              if (records.any((record) => record.endDate == null)) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.push('/history'),
                    child: const Text('Kelola'),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}

String _number(double? value) =>
    value == null ? 'Belum ada' : value.toStringAsFixed(1);
