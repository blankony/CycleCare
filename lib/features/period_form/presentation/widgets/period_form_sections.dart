import 'package:flutter/material.dart';

import '../../../../app/design/cycle_care_design.dart';
import '../../../../app/widgets.dart';
import '../../../../core/date/date_only.dart';
import '../../../../domain/entities/enums.dart';
import '../../../../domain/entities/period_day_log.dart';
import '../../../../l10n/app_localizations.dart';

class PeriodDateSection extends StatelessWidget {
  const PeriodDateSection({
    required this.startDate,
    required this.endDate,
    required this.onStartTap,
    required this.onEndTap,
    required this.onOngoingChanged,
    super.key,
  });

  final DateTime startDate;
  final DateTime? endDate;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;
  final ValueChanged<bool> onOngoingChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CycleCareCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.periodFormSectionDates,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: CycleCareSpacing.xxs),
            Text(
              l10n.periodFormDatesHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.cycleCareColors.textSecondary,
                  ),
            ),
            const SizedBox(height: CycleCareSpacing.lg),
            PeriodDateButton(
              label: l10n.periodFormStartDate,
              value: startDate,
              onTap: onStartTap,
            ),
            const SizedBox(height: CycleCareSpacing.sm),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              minTileHeight: 48,
              title: Text(l10n.periodFormOngoing),
              subtitle: Text(l10n.periodFormOngoingHint),
              value: endDate == null,
              onChanged: onOngoingChanged,
            ),
            if (endDate != null) ...[
              const SizedBox(height: CycleCareSpacing.sm),
              PeriodDateButton(
                label: l10n.periodFormEndDate,
                value: endDate!,
                onTap: onEndTap,
              ),
            ],
          ],
        ),
      );
  }
}

class PeriodDateButton extends StatelessWidget {
  const PeriodDateButton({
    required this.label,
    required this.value,
    required this.onTap,
    super.key,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
        button: true,
        label: '$label, ${DateOnly.display(value, l10n.localeName)}',
        child: Material(
          color: context.cycleCareColors.surfaceMuted,
          borderRadius: CycleCareRadius.mediumBorder,
          child: InkWell(
            onTap: onTap,
            borderRadius: CycleCareRadius.mediumBorder,
            child: Container(
              constraints: const BoxConstraints(minHeight: 64),
              padding: const EdgeInsets.symmetric(
                horizontal: CycleCareSpacing.md,
                vertical: CycleCareSpacing.sm,
              ),
              decoration: BoxDecoration(
                borderRadius: CycleCareRadius.mediumBorder,
                border: Border.all(color: context.cycleCareColors.divider),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: context.cycleCareColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: CycleCareSpacing.xxs),
                        Text(
                          DateOnly.display(value, l10n.localeName),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.calendar_today_outlined),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}

class PeriodFlowSection extends StatelessWidget {
  const PeriodFlowSection({
    required this.days,
    required this.existingLogs,
    required this.flowChanges,
    required this.onChanged,
    required this.isLoading,
    required this.isUnavailable,
    super.key,
  });

  final List<DateTime> days;
  final List<PeriodDayLogRecord> existingLogs;
  final Map<DateTime, MenstrualFlow?> flowChanges;
  final void Function(DateTime, MenstrualFlow?) onChanged;
  final bool isLoading;
  final bool isUnavailable;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final existingByDate = {
      for (final log in existingLogs)
        DateOnly.format(log.logDate): MenstrualFlowText.fromValue(log.flow),
    };

    return CycleCareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.periodFormFlowSection, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: CycleCareSpacing.xxs),
          Text(
            l10n.periodFormFlowHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.cycleCareColors.textSecondary,
                ),
          ),
          if (isLoading || isUnavailable) ...[
            const SizedBox(height: CycleCareSpacing.md),
            _FlowProviderNotice(isLoading: isLoading),
          ],
          const SizedBox(height: CycleCareSpacing.lg),
          for (var index = 0; index < days.length; index++) ...[
            PeriodFlowDayEditor(
              date: days[index],
              value: flowChanges.containsKey(DateOnly.normalize(days[index]))
                  ? flowChanges[DateOnly.normalize(days[index])]
                  : existingByDate[DateOnly.format(days[index])],
              onChanged: (value) => onChanged(days[index], value),
            ),
            if (index < days.length - 1) ...[
              const SizedBox(height: CycleCareSpacing.md),
              Divider(color: context.cycleCareColors.divider, height: 1),
              const SizedBox(height: CycleCareSpacing.md),
            ],
          ],
        ],
      ),
    );
  }
}

class PeriodFlowDayEditor extends StatelessWidget {
  const PeriodFlowDayEditor({
    required this.date,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final DateTime date;
  final MenstrualFlow? value;
  final ValueChanged<MenstrualFlow?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: 'Flow ${DateOnly.display(date, l10n.localeName)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateOnly.display(date, l10n.localeName),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (value != null)
                TextButton.icon(
                  onPressed: () => onChanged(null),
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: Text(l10n.periodFormFlowHapus),
                ),
            ],
          ),
          const SizedBox(height: CycleCareSpacing.xs),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final flow in MenstrualFlow.values) ...[
                  Semantics(
                    button: true,
                    selected: value == flow,
                    label: '${flow.label}, ${flow.indicator}',
                    child: ChoiceChip(
                      selected: value == flow,
                      onSelected: (_) => onChanged(flow),
                      avatar: Text(flow.indicator, style: const TextStyle(fontWeight: FontWeight.w800)),
                      label: Text(flow.label),
                      selectedColor: scheme.primaryContainer,
                      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: value == flow ? FontWeight.w700 : FontWeight.w500,
                          ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  if (flow != MenstrualFlow.values.last)
                    const SizedBox(width: CycleCareSpacing.xs),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PeriodValidationMessage extends StatelessWidget {
  const PeriodValidationMessage({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        label: message,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(CycleCareSpacing.md),
          decoration: BoxDecoration(
            color: CycleCareColors.error.withValues(alpha: 0.10),
            borderRadius: CycleCareRadius.mediumBorder,
            border: Border.all(
              color: CycleCareColors.error.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: CycleCareColors.error,
              ),
              const SizedBox(width: CycleCareSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFFFB4AB)
                            : CycleCareColors.error,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
}

class PeriodPrivacyNote extends StatelessWidget {
  const PeriodPrivacyNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
        label: l10n.periodFormPrivacyNote,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 17,
              color: context.cycleCareColors.textSecondary,
            ),
            const SizedBox(width: CycleCareSpacing.xs),
            Flexible(
              child: Text(
                l10n.periodFormPrivacyNote,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.cycleCareColors.textSecondary,
                    ),
              ),
            ),
          ],
        ),
      );
  }
}

class _FlowProviderNotice extends StatelessWidget {
  const _FlowProviderNotice({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(CycleCareSpacing.sm),
        decoration: BoxDecoration(
          color: context.cycleCareColors.surfaceMuted,
          borderRadius: BorderRadius.circular(CycleCareRadius.small),
          border: Border.all(color: context.cycleCareColors.divider),
        ),
        child: Row(
          children: [
            Icon(
              isLoading ? Icons.sync_rounded : Icons.info_outline_rounded,
              size: 19,
            ),
            const SizedBox(width: CycleCareSpacing.xs),
            Expanded(
              child: Text(
                isLoading
                    ? l10n.periodFormFlowLoading
                    : l10n.periodFormFlowUnavailable,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
  }
}
