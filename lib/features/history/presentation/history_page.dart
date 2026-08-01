import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/period_day_log.dart';
import '../../../domain/entities/period_record.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(activePeriodsProvider);
    final logs = ref.watch(flowLogsProvider).valueOrNull ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat period'),
        actions: [
          IconButton(
            tooltip: 'Statistik pribadi',
            onPressed: () => context.push('/statistics'),
            icon: const Icon(Icons.insights_outlined),
          ),
        ],
      ),
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
                itemBuilder: (context, index) {
                  final record = records.reversed.elementAt(index);
                  return _HistoryTile(
                    record: record,
                    flowLogs: logs
                        .where((log) => log.periodEntryId == record.id)
                        .toList(),
                  );
                },
              ),
      ),
    );
  }
}

class _HistoryTile extends ConsumerWidget {
  const _HistoryTile({required this.record, required this.flowLogs});

  final PeriodRecord record;
  final List<PeriodDayLogRecord> flowLogs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowSummary = <String, int>{};
    for (final log in flowLogs) {
      final flow = MenstrualFlowText.fromValue(log.flow);
      if (flow != null) {
        flowSummary[flow.label] = (flowSummary[flow.label] ?? 0) + 1;
      }
    }
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text(DateOnly.display(record.startDate)),
        subtitle: Text([
          record.endDate == null
              ? 'Masih berlangsung'
              : 'Selesai ${DateOnly.display(record.endDate!)}',
          if (record.periodDurationDays != null)
            'Durasi ${record.periodDurationDays} hari',
          if (record.cycleLengthDays != null)
            'Siklus ${record.cycleLengthDays} hari',
          if (flowSummary.isNotEmpty)
            flowSummary.entries
                .map((entry) => '${entry.key}: ${entry.value}')
                .join(', '),
          if (record.classification != null) record.classification!.label,
          if (record.notes?.isNotEmpty == true) record.notes!,
        ].join(' · ')),
        isThreeLine: true,
        onTap: () => context.push('/add-period', extra: record),
        trailing: PopupMenuButton<String>(
          tooltip: 'Aksi catatan',
          onSelected: (value) {
            if (value == 'summary') context.push('/summary/${record.id}');
            if (value == 'delete') _delete(context, ref);
          },
          itemBuilder: (context) => [
            if (record.endDate != null)
              const PopupMenuItem(
                  value: 'summary', child: Text('Lihat ringkasan')),
            const PopupMenuItem(value: 'delete', child: Text('Arsipkan')),
          ],
        ),
      ),
    );
  }

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
