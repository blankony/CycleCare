import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/cycle_insights.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({required this.periodId, super.key});

  final String periodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(endOfCycleSummaryProvider(periodId));
    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan period')),
      body: summary.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Ringkasan belum dapat dimuat: $error')),
        data: (value) => value == null
            ? const EmptyState(
                title: 'Ringkasan tidak ditemukan',
                message: 'Catatan period mungkin sudah dihapus.')
            : ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  _SummaryCard(value: value),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.health_and_safety_outlined),
                      title: Text(value.reference.cycleLength.label),
                      subtitle: Text(
                          'Siklus: ${value.reference.cycleLength.label}\nDurasi period: ${value.reference.bleedingDuration.label}'),
                    ),
                  ),
                  if (value.reference.shouldSuggestConsultation) ...[
                    const SizedBox(height: 12),
                    const Text(
                        'Pertimbangkan berkonsultasi dengan tenaga kesehatan jika perubahan ini mengkhawatirkan, berulang, atau mengganggu aktivitas.'),
                  ],
                  const SizedBox(height: 18),
                  const MedicalDisclaimer(),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Selesai'),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.value});

  final EndOfCycleSummary value;

  @override
  Widget build(BuildContext context) {
    final period = value.period;
    final flowText = value.flowCounts.isEmpty
        ? 'Belum ada flow yang dicatat'
        : value.flowCounts.entries
            .map((entry) => '${entry.key.label}: ${entry.value} hari')
            .join(' · ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Period ${DateOnly.display(period.startDate)}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(period.endDate == null
                ? 'Masih berlangsung'
                : 'Selesai ${DateOnly.display(period.endDate!)}'),
            if (period.periodDurationDays != null)
              Text('Durasi: ${period.periodDurationDays} hari'),
            if (period.cycleLengthDays != null)
              Text('Panjang siklus: ${period.cycleLengthDays} hari'),
            if (value.previousAverageCycleLength != null)
              Text(
                  'Rata-rata sebelumnya: ${value.previousAverageCycleLength!.toStringAsFixed(1)} hari'),
            if (value.differenceFromAverage != null)
              Text(
                  'Perbedaan dari rata-rata: ${value.differenceFromAverage!.toStringAsFixed(1)} hari'),
            const SizedBox(height: 10),
            Text('Flow: $flowText'),
            Text('Pola pribadi: ${value.pattern.label}'),
            if (period.classification != null)
              Text('Dibandingkan perkiraan: ${period.classification!.label}'),
            if (period.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text('Catatan: ${period.notes}'),
            ],
          ],
        ),
      ),
    );
  }
}
