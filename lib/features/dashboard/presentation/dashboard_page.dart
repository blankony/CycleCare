import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/period_record.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(activePeriodsProvider);
    final prediction = ref.watch(predictionProvider);
    ref.listen(periodActionsProvider, (_, next) {
      next.whenOrNull(
          error: (error, _) => ScaffoldMessenger.of(context)
            ..showSnackBar(SnackBar(content: Text(error.toString()))));
    });
    return Scaffold(
      appBar: const CycleCareAppBar(title: 'CycleCare'),
      body: periods.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Data belum dapat dimuat: $error')),
        data: (records) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(activePeriodsProvider),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              _GreetingCard(latest: records.isEmpty ? null : records.last),
              const SizedBox(height: 12),
              if (records.isEmpty)
                const EmptyState(
                  title: 'Belum ada catatan',
                  message:
                      'Catat period pertama untuk mulai melihat ringkasan siklusmu.',
                )
              else
                _SummaryGrid(
                    records: records, prediction: prediction.valueOrNull),
              const SizedBox(height: 16),
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

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.latest});

  final PeriodRecord? latest;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.favorite,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  latest == null
                      ? 'Selamat datang di CycleCare'
                      : 'Ruang pribadi untuk mencatat siklusmu',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      );
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.records, required this.prediction});

  final List<PeriodRecord> records;
  final dynamic prediction;

  @override
  Widget build(BuildContext context) {
    final latest = records.last;
    final cycleDay =
        DateOnly.differenceInDays(DateTime.now(), latest.startDate) + 1;
    final values = [
      ('Hari siklus', '$cycleDay'),
      ('Mulai terakhir', DateOnly.display(latest.startDate)),
      (
        'Durasi period',
        latest.periodDurationDays == null
            ? 'Belum selesai'
            : '${latest.periodDurationDays} hari'
      ),
      (
        'Panjang siklus',
        latest.cycleLengthDays == null
            ? 'Belum ada'
            : '${latest.cycleLengthDays} hari'
      ),
      (
        'Prediksi berikutnya',
        prediction?.predictedStart == null
            ? 'Belum cukup data'
            : DateOnly.display(prediction.predictedStart)
      ),
      ('Keyakinan', prediction?.confidence?.label ?? 'Belum cukup data'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.55),
      itemCount: values.length,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(values[index].$1,
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 7),
            Text(values[index].$2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall),
          ]),
        ),
      ),
    );
  }
}

class _ActionsCard extends ConsumerWidget {
  const _ActionsCard({required this.records});

  final List<PeriodRecord> records;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unfinished =
        records.where((record) => record.endDate == null).lastOrNull;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          FilledButton.icon(
            onPressed: () => _confirmStart(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Period mulai hari ini'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push('/add-period'),
            icon: const Icon(Icons.event),
            label: const Text('Pilih tanggal lain'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: unfinished == null
                ? null
                : () => _confirmFinish(context, ref, unfinished),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Period selesai hari ini'),
          ),
        ]),
      ),
    );
  }

  Future<void> _confirmStart(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Catat period?'),
        content: const Text('Simpan hari ini sebagai tanggal mulai period?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Simpan')),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref
          .read(periodActionsProvider.notifier)
          .create(startDate: DateTime.now());
    }
  }

  Future<void> _confirmFinish(
      BuildContext context, WidgetRef ref, PeriodRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Akhiri period?'),
        content: Text(
            'Simpan ${DateOnly.display(DateTime.now())} sebagai tanggal selesai?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Selesai')),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref
          .read(periodActionsProvider.notifier)
          .finish(record.id, DateTime.now());
    }
  }
}
