import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/period_day_log.dart';
import '../../../domain/entities/period_record.dart';
import '../../../domain/entities/sync_state.dart';
import '../../../l10n/app_localizations.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final periods = ref.watch(activePeriodsProvider);
    final logs = ref.watch(flowLogsProvider);

    return Scaffold(
      appBar: CycleCareAppBar(title: l10n.historyTitle),
      body: CycleCareBackground(
        child: periods.when(
          loading: () => CycleCareLoadingState(
            message: l10n.historyPreparing,
            cardCount: 3,
          ),
          error: (_, __) => CycleCareErrorState(
            message: l10n.historyLoadFailed,
            onRetry: () => ref.invalidate(activePeriodsProvider),
          ),
          data: (records) {
            if (records.isEmpty) {
              return EmptyState(
                title: l10n.historyEmptyTitle,
                message: l10n.historyEmptyMessage,
                action: FilledButton.icon(
                  onPressed: () => context.push('/add-period'),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.actionRecordPeriod),
                ),
              );
            }
            return _HistoryContent(
              records: [...records]
                ..sort((a, b) => b.startDate.compareTo(a.startDate)),
              logs: logs.valueOrNull ?? const [],
              flowUnavailable: logs.hasError,
              flowLoading: logs.isLoading,
              syncSnapshot: ref.watch(syncSnapshotProvider),
              onRefresh: () async {
                await ref.read(syncControllerProvider).synchronizeNow();
                ref.invalidate(activePeriodsProvider);
                ref.invalidate(flowLogsProvider);
                await ref.read(activePeriodsProvider.future);
              },
              onRetrySync: () => ref.read(syncControllerProvider).retry(),
            );
          },
        ),
      ),
      floatingActionButton: periods.valueOrNull?.isNotEmpty == true
          ? FloatingActionButton.extended(
              tooltip: l10n.tooltipRecordPeriod,
              onPressed: () => context.push('/add-period'),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.actionRecordPeriod),
            )
          : null,
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({
    required this.records,
    required this.logs,
    required this.flowUnavailable,
    required this.flowLoading,
    required this.syncSnapshot,
    required this.onRefresh,
    required this.onRetrySync,
  });

  final List<PeriodRecord> records;
  final List<PeriodDayLogRecord> logs;
  final bool flowUnavailable;
  final bool flowLoading;
  final SyncGateSnapshot syncSnapshot;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetrySync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final showsSync = {
      SyncGateStatus.offlineReady,
      SyncGateStatus.failed,
    }.contains(syncSnapshot.status);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          CycleCareSpacing.page,
          CycleCareSpacing.md,
          CycleCareSpacing.page,
          112,
        ),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.historyNewestFirst,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.cycleCareColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: CycleCareSpacing.md),
                  const _StatisticsLink(),
                  if (showsSync) ...[
                    const SizedBox(height: CycleCareSpacing.md),
                    CycleCareSyncBanner(
                      snapshot: syncSnapshot,
                      onRetry: onRetrySync,
                    ),
                  ],
                  if (flowUnavailable || flowLoading) ...[
                    const SizedBox(height: CycleCareSpacing.md),
                    _FlowNotice(isLoading: flowLoading),
                  ],
                  const SizedBox(height: CycleCareSpacing.lg),
                  for (var index = 0; index < records.length; index++) ...[
                    _HistoryCard(
                      record: records[index],
                      flowLogs: logs
                          .where(
                            (log) => log.periodEntryId == records[index].id,
                          )
                          .toList(),
                    ),
                    if (index < records.length - 1)
                      const SizedBox(height: CycleCareSpacing.md),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsLink extends StatelessWidget {
  const _StatisticsLink();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CycleCareCard(
        onTap: () => context.push('/statistics'),
        semanticLabel: l10n.historyOpenStats,
        padding: const EdgeInsets.symmetric(
          horizontal: CycleCareSpacing.md,
          vertical: CycleCareSpacing.sm,
        ),
        color: context.cycleCareColors.surfaceMuted,
        child: Row(
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.insights_outlined),
            ),
            const SizedBox(width: CycleCareSpacing.xs),
            Expanded(child: Text(l10n.historyPersonalStats)),
            const SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      );
  }
}

class _HistoryCard extends ConsumerWidget {
  const _HistoryCard({required this.record, required this.flowLogs});

  final PeriodRecord record;
  final List<PeriodDayLogRecord> flowLogs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final completed = record.endDate != null;
    return CycleCareCard(
      semanticLabel: _semanticLabel(context, record),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _dateRange(context, record),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              PopupMenuButton<String>(
                tooltip: '${l10n.historyPersonalStats} ${DateOnly.display(record.startDate, l10n.localeName)}',
                onSelected: (value) {
                  if (value == 'archive') _archive(context, ref);
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'archive',
                    child: Row(
                      children: [
                        const Icon(Icons.archive_outlined),
                        const SizedBox(width: CycleCareSpacing.sm),
                        Text(l10n.commonArchive),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: CycleCareSpacing.sm),
          Wrap(
            spacing: CycleCareSpacing.xs,
            runSpacing: CycleCareSpacing.xs,
            children: [
              CycleCareStatusChip(
                label: completed ? l10n.historyRecordedChip : l10n.historyOngoingChip,
                icon: completed
                    ? Icons.verified_outlined
                    : Icons.timelapse_rounded,
                tone: completed
                    ? CycleCareStatusTone.success
                    : CycleCareStatusTone.info,
              ),
              if (record.periodDurationDays != null)
                CycleCareStatusChip(
                  label: l10n.historyDaysChip(record.periodDurationDays!),
                  icon: Icons.calendar_view_day_outlined,
                ),
              if (record.cycleLengthDays != null)
                CycleCareStatusChip(
                  label: l10n.historyCycleChip(record.cycleLengthDays!),
                  icon: Icons.repeat_rounded,
                ),
            ],
          ),
          const SizedBox(height: CycleCareSpacing.md),
          _FlowSummary(flowLogs: flowLogs),
          const SizedBox(height: CycleCareSpacing.md),
          Divider(color: context.cycleCareColors.divider, height: 1),
          const SizedBox(height: CycleCareSpacing.xs),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: CycleCareSpacing.xs,
            runSpacing: CycleCareSpacing.xs,
            children: [
              TextButton.icon(
                onPressed: () => context.push('/add-period', extra: record),
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.commonEdit),
              ),
              if (completed)
                FilledButton.tonalIcon(
                  onPressed: () => context.push('/summary/${record.id}'),
                  icon: const Icon(Icons.article_outlined),
                  label: Text(l10n.historyViewSummary),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _archive(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.historyArchiveTitle),
        content: Text(l10n.historyArchiveMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.historyArchiveAction),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(periodActionsProvider.notifier).delete(record.id);
    }
  }
}

class _FlowSummary extends StatelessWidget {
  const _FlowSummary({required this.flowLogs});

  final List<PeriodDayLogRecord> flowLogs;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final counts = <MenstrualFlow, int>{};
    for (final log in flowLogs) {
      final flow = MenstrualFlowText.fromValue(log.flow);
      if (flow != null) counts[flow] = (counts[flow] ?? 0) + 1;
    }
    final summary = MenstrualFlow.values
        .where(counts.containsKey)
        .map((flow) => '${flow.label} ${counts[flow]}')
        .join(' · ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CycleCareSpacing.sm),
      decoration: BoxDecoration(
        color: context.cycleCareColors.surfaceMuted,
        borderRadius: BorderRadius.circular(CycleCareRadius.small),
        border: Border.all(color: context.cycleCareColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.water_drop_outlined,
            size: 19,
            color: CycleCareColors.period,
          ),
          const SizedBox(width: CycleCareSpacing.xs),
          Expanded(
            child: Text(
              summary.isEmpty ? l10n.historyFlowNone : summary,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowNotice extends StatelessWidget {
  const _FlowNotice({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CycleCareCard(
        padding: const EdgeInsets.all(CycleCareSpacing.md),
        color: context.cycleCareColors.surfaceMuted,
        child: Row(
          children: [
            Icon(
              isLoading ? Icons.sync_rounded : Icons.info_outline_rounded,
              size: 20,
            ),
            const SizedBox(width: CycleCareSpacing.sm),
            Expanded(
              child: Text(
                isLoading
                    ? l10n.historyFlowLoading
                    : l10n.historyFlowUnavailable,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
  }
}

String _dateRange(BuildContext context, PeriodRecord record) {
  final l10n = AppLocalizations.of(context);
  final end = record.endDate;
  if (end == null) return l10n.calendarStartOngoing(DateOnly.display(record.startDate, l10n.localeName));
  if (record.startDate.year == end.year &&
      record.startDate.month == end.month) {
    return '${record.startDate.day}–${DateOnly.display(end, l10n.localeName)}';
  }
  return '${DateOnly.display(record.startDate, l10n.localeName)}–${DateOnly.display(end, l10n.localeName)}';
}

String _semanticLabel(BuildContext context, PeriodRecord record) {
  final l10n = AppLocalizations.of(context);
  final parts = <String>[
    _dateRange(context, record),
    record.endDate == null ? l10n.historyOngoingChip : l10n.historyRecordedChip,
    if (record.periodDurationDays != null)
      l10n.historyDaysChip(record.periodDurationDays!),
    if (record.cycleLengthDays != null) l10n.historyCycleChip(record.cycleLengthDays!),
  ];
  return '${parts.join(', ')}.';
}
