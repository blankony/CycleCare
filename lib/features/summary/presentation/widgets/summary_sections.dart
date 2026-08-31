import 'package:flutter/material.dart';

import '../../../../app/design/cycle_care_design.dart';
import '../../../../app/widgets.dart';
import '../../../../core/date/date_only.dart';
import '../../../../domain/entities/cycle_insights.dart';
import '../../../../domain/entities/enums.dart';
import '../../../../domain/entities/period_record.dart';
import '../../../../l10n/app_localizations.dart';

class CycleSummaryContent extends StatelessWidget {
  const CycleSummaryContent({
    required this.value,
    required this.isArchiving,
    required this.onEdit,
    required this.onArchive,
    super.key,
  });

  final EndOfCycleSummary value;
  final bool isArchiving;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  _RecordedHeader(period: value.period),
                  const SizedBox(height: CycleCareSpacing.md),
                  _CycleInsightCard(value: value),
                  const SizedBox(height: CycleCareSpacing.md),
                  _FlowBreakdown(flowCounts: value.flowCounts),
                  const SizedBox(height: CycleCareSpacing.md),
                  _NotesCard(notes: value.period.notes),
                  const SizedBox(height: CycleCareSpacing.md),
                  _ComparisonCard(value: value),
                  if (value.reference.shouldSuggestConsultation) ...[
                    const SizedBox(height: CycleCareSpacing.md),
                    const _HealthContextCard(),
                  ],
                  const SizedBox(height: CycleCareSpacing.xl),
                  FilledButton.icon(
                    onPressed: isArchiving ? null : onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l10n.commonEdit),
                  ),
                  const SizedBox(height: CycleCareSpacing.sm),
                  Divider(color: context.cycleCareColors.divider),
                  const SizedBox(height: CycleCareSpacing.xs),
                  TextButton.icon(
                    onPressed: isArchiving ? null : onArchive,
                    icon: isArchiving
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.archive_outlined),
                    label: Text(
                      isArchiving ? 'Archiving...' : l10n.commonArchive,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}

class _RecordedHeader extends StatelessWidget {
  const _RecordedHeader({required this.period});

  final PeriodRecord period;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final duration = period.periodDurationDays;
    return Semantics(
      container: true,
      label: [
        l10n.historyRecordedChip,
        _dateRange(context, period),
        if (duration != null) l10n.historyDaysChip(duration),
      ].join('. '),
      child: CycleCareCard(
        child: Column(
          children: [
            CycleCareStatusChip(
              label: l10n.historyRecordedChip,
              icon: Icons.verified_outlined,
              tone: CycleCareStatusTone.success,
            ),
            const SizedBox(height: CycleCareSpacing.md),
            Text(
              duration == null ? l10n.historyRecordedChip : l10n.historyDaysChip(duration),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: CycleCareSpacing.xxs),
            Text(
              _dateRange(context, period),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.cycleCareColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CycleInsightCard extends StatelessWidget {
  const _CycleInsightCard({required this.value});

  final EndOfCycleSummary value;

  @override
  Widget build(BuildContext context) {
    final cycleLength = value.period.cycleLengthDays;
    return CycleCareCard(
      color: context.cycleCareColors.surfaceMuted,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox.square(
            dimension: 48,
            child: Icon(
              Icons.repeat_rounded,
              color: CycleCareColors.fertileStrong,
            ),
          ),
          const SizedBox(width: CycleCareSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cycleLength == null
                      ? 'Cycle length not available'
                      : 'Cycle $cycleLength days',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: CycleCareSpacing.xxs),
                Text(
                  'Calculated from previous period start distance.',
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
}

class _FlowBreakdown extends StatelessWidget {
  const _FlowBreakdown({required this.flowCounts});

  final Map<MenstrualFlow, int> flowCounts;

  static const _flows = [
    MenstrualFlow.heavy,
    MenstrualFlow.medium,
    MenstrualFlow.light,
    MenstrualFlow.spotting,
  ];

  @override
  Widget build(BuildContext context) {
    final maximum = flowCounts.values.fold<int>(0, (a, b) => a > b ? a : b);
    return CycleCareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Blood flow', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: CycleCareSpacing.xxs),
          Text(
            flowCounts.isEmpty
                ? 'No daily flow recorded.'
                : 'Days recorded per flow level.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.cycleCareColors.textSecondary,
                ),
          ),
          const SizedBox(height: CycleCareSpacing.md),
          for (final flow in _flows) ...[
            _FlowRow(
              flow: flow,
              days: flowCounts[flow] ?? 0,
              maximum: maximum,
            ),
            if (flow != _flows.last)
              const SizedBox(height: CycleCareSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _FlowRow extends StatelessWidget {
  const _FlowRow({
    required this.flow,
    required this.days,
    required this.maximum,
  });

  final MenstrualFlow flow;
  final int days;
  final int maximum;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fraction = maximum == 0 ? 0.0 : days / maximum;
    return Semantics(
      label: '${flow.label}, ${l10n.historyDaysChip(days)}',
      child: Row(
        children: [
          SizedBox(
            width: 76,
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
                minHeight: 8,
                value: fraction,
                backgroundColor: context.cycleCareColors.surfaceMuted,
                color: days == 0
                    ? context.cycleCareColors.divider
                    : CycleCareColors.period,
              ),
            ),
          ),
          const SizedBox(width: CycleCareSpacing.xs),
          SizedBox(
            width: 48,
            child: Text(
              l10n.historyDaysChip(days),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.notes});

  final String? notes;

  @override
  Widget build(BuildContext context) {
    final hasNotes = notes?.trim().isNotEmpty == true;
    return CycleCareCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox.square(
            dimension: 48,
            child: Icon(Icons.notes_rounded),
          ),
          const SizedBox(width: CycleCareSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notes', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: CycleCareSpacing.xxs),
                Text(
                  hasNotes
                      ? notes!.trim()
                      : 'No notes for this period.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: hasNotes
                            ? null
                            : context.cycleCareColors.textSecondary,
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

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.value});

  final EndOfCycleSummary value;

  @override
  Widget build(BuildContext context) {
    return CycleCareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Personal comparison',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const CycleCareStatusChip(
                label: 'Insight',
                icon: Icons.insights_outlined,
                tone: CycleCareStatusTone.info,
              ),
            ],
          ),
          const SizedBox(height: CycleCareSpacing.sm),
          Text(
            _comparisonText(
              cycleLength: value.period.cycleLengthDays,
              average: value.previousAverageCycleLength,
              difference: value.differenceFromAverage,
            ),
          ),
          const SizedBox(height: CycleCareSpacing.md),
          const MedicalDisclaimer(),
        ],
      ),
    );
  }
}

class _HealthContextCard extends StatelessWidget {
  const _HealthContextCard();

  @override
  Widget build(BuildContext context) => CycleCareCard(
        color: context.cycleCareColors.surfaceMuted,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox.square(
              dimension: 48,
              child: Icon(
                Icons.health_and_safety_outlined,
                color: CycleCareColors.warning,
              ),
            ),
            const SizedBox(width: CycleCareSpacing.sm),
            Expanded(
              child: Text(
                'If this change repeats or is concerning, consider talking to a healthcare professional.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
}

String _dateRange(BuildContext context, PeriodRecord period) {
  final l10n = AppLocalizations.of(context);
  final end = period.endDate;
  if (end == null) return l10n.calendarStartOngoing(DateOnly.display(period.startDate, l10n.localeName));
  if (period.startDate.year == end.year &&
      period.startDate.month == end.month) {
    return '${period.startDate.day}\u2013${DateOnly.display(end, l10n.localeName)}';
  }
  return '${DateOnly.display(period.startDate, l10n.localeName)}\u2013${DateOnly.display(end, l10n.localeName)}';
}

String _comparisonText({
  required int? cycleLength,
  required double? average,
  required double? difference,
}) {
  if (cycleLength == null || average == null || difference == null) {
    return 'Not enough previous history for a meaningful comparison.';
  }

  final absoluteDifference = difference.abs();
  final relation = absoluteDifference < 0.5
      ? 'almost the same as'
      : difference > 0
          ? '${absoluteDifference.toStringAsFixed(1)} days longer than'
          : '${absoluteDifference.toStringAsFixed(1)} days shorter than';
  return 'This cycle is $relation previous average '
      '(${average.toStringAsFixed(1)} days).';
}
