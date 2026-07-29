import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/period_record.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(activePeriodsProvider);
    return Scaffold(
      appBar: const CycleCareAppBar(title: 'Riwayat period'),
      body: periods.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Riwayat belum dapat dimuat: $error')),
        data: (records) => records.isEmpty
            ? const EmptyState(
                title: 'Riwayat masih kosong',
                message: 'Catatan period yang kamu simpan akan muncul di sini.')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: records.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _HistoryTile(record: records[index]),
              ),
      ),
    );
  }
}

class _HistoryTile extends ConsumerWidget {
  const _HistoryTile({required this.record});

  final PeriodRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          title: Text(DateOnly.display(record.startDate)),
          subtitle: Text([
            if (record.endDate != null)
              'Selesai ${DateOnly.display(record.endDate!)}',
            if (record.periodDurationDays != null)
              'Durasi ${record.periodDurationDays} hari',
            if (record.cycleLengthDays != null)
              'Siklus ${record.cycleLengthDays} hari',
            if (record.classification != null) record.classification!.label,
            if (record.notes?.isNotEmpty == true) record.notes!,
          ].join(' • ')),
          isThreeLine: true,
          onTap: () => context.push('/add-period', extra: record),
          trailing: IconButton(
            tooltip: 'Arsipkan catatan',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref),
          ),
        ),
      );

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arsipkan catatan?'),
        content: const Text(
            'Catatan tidak dihapus permanen dan dapat dipulihkan dari Pengaturan.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Arsipkan')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(periodActionsProvider.notifier).delete(record.id);
    }
  }
}
