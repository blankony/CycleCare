import 'package:flutter/material.dart';

import '../../../../app/design/cycle_care_design.dart';
import '../../../../app/widgets.dart';
import '../../../../core/date/date_only.dart';
import '../../../../domain/entities/cycle_insights.dart';
import '../../../../domain/entities/enums.dart';
import '../../../../domain/entities/period_record.dart';

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
                    label: const Text('Edit data'),
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
                      isArchiving ? 'Mengarsipkan...' : 'Arsipkan catatan',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

class _RecordedHeader extends StatelessWidget {
  const _RecordedHeader({required this.period});

  final PeriodRecord period;

  @override
  Widget build(BuildContext context) {
    final duration = period.periodDurationDays;
    return Semantics(
      container: true,
      label: [
        'Data tercatat',
        _dateRange(period),
        if (duration != null) 'Durasi $duration hari',
      ].join('. '),
      child: CycleCareCard(
        child: Column(
          children: [
            const CycleCareStatusChip(
              label: 'Tercatat',
              icon: Icons.verified_outlined,
              tone: CycleCareStatusTone.success,
            ),
            const SizedBox(height: CycleCareSpacing.md),
            Text(
              duration == null ? 'Period selesai' : '$duration hari',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: CycleCareSpacing.xxs),
            Text(
              _dateRange(period),
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
                      ? 'Panjang siklus belum tersedia'
                      : 'Siklus $cycleLength hari',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: CycleCareSpacing.xxs),
                Text(
                  'Wawasan ini dihitung dari jarak ke awal period sebelumnya.',
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
          Text('Aliran darah', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: CycleCareSpacing.xxs),
          Text(
            flowCounts.isEmpty
                ? 'Belum ada aliran harian yang dicatat.'
                : 'Jumlah hari tercatat untuk setiap tingkat aliran.',
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
    final fraction = maximum == 0 ? 0.0 : days / maximum;
    return Semantics(
      label: '${flow.label}, $days hari',
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
              '$days hari',
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
                Text('Catatan', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: CycleCareSpacing.xxs),
                Text(
                  hasNotes
                      ? notes!.trim()
                      : 'Tidak ada catatan untuk period ini.',
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
                  'Perbandingan pribadi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const CycleCareStatusChip(
                label: 'Wawasan',
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
                'Jika perubahan ini berulang, mengkhawatirkan, atau mengganggu aktivitas, pertimbangkan berbicara dengan tenaga kesehatan.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
}

String _dateRange(PeriodRecord period) {
  final end = period.endDate;
  if (end == null) return 'Mulai ${DateOnly.display(period.startDate)}';
  if (period.startDate.year == end.year &&
      period.startDate.month == end.month) {
    return '${period.startDate.day}\u2013${DateOnly.display(end)}';
  }
  return '${DateOnly.display(period.startDate)}\u2013${DateOnly.display(end)}';
}

String _comparisonText({
  required int? cycleLength,
  required double? average,
  required double? difference,
}) {
  if (cycleLength == null || average == null || difference == null) {
    return 'Belum cukup riwayat sebelumnya untuk membuat perbandingan yang bermakna.';
  }

  final absoluteDifference = difference.abs();
  final relation = absoluteDifference < 0.5
      ? 'hampir sama dengan'
      : difference > 0
          ? '${absoluteDifference.toStringAsFixed(1)} hari lebih panjang dari'
          : '${absoluteDifference.toStringAsFixed(1)} hari lebih pendek dari';
  return 'Siklus ini $relation rata-rata sebelumnya '
      '(${average.toStringAsFixed(1)} hari).';
}
