import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../core/errors/app_failure.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/period_day_log.dart';
import '../../../domain/entities/period_record.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/period_form_sections.dart';

class PeriodFormPage extends ConsumerStatefulWidget {
  const PeriodFormPage({this.record, super.key});

  final Object? record;

  @override
  ConsumerState<PeriodFormPage> createState() => _PeriodFormPageState();
}

class _PeriodFormPageState extends ConsumerState<PeriodFormPage> {
  late DateTime _startDate;
  DateTime? _endDate;
  late final TextEditingController _notesController;
  final Map<DateTime, MenstrualFlow?> _flowChanges = {};
  String? _validationMessage;

  PeriodRecord? get _editingRecord =>
      widget.record is PeriodRecord ? widget.record as PeriodRecord : null;

  @override
  void initState() {
    super.initState();
    final record = _editingRecord;
    _startDate = DateOnly.normalize(record?.startDate ?? DateTime.now());
    _endDate =
        record?.endDate == null ? null : DateOnly.normalize(record!.endDate!);
    _notesController = TextEditingController(text: record?.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final editing = _editingRecord != null;
    final actions = ref.watch(periodActionsProvider);
    final flowLogs = ref.watch(flowLogsProvider);
    final List<PeriodDayLogRecord> existingLogs = editing
        ? flowLogs.valueOrNull
                ?.where((log) => log.periodEntryId == _editingRecord!.id)
                .toList() ??
            const <PeriodDayLogRecord>[]
        : const <PeriodDayLogRecord>[];

    return Scaffold(
      appBar: CycleCareAppBar(
        title: editing ? l10n.periodFormUpdateTitle : l10n.periodFormCreateTitle,
      ),
      body: CycleCareBackground(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            editing
                                ? l10n.periodFormUpdateSubtitle
                                : l10n.periodFormCreateSubtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: context.cycleCareColors.textSecondary,
                                ),
                          ),
                        ),
                        if (editing) ...[
                          const SizedBox(width: CycleCareSpacing.sm),
                          CycleCareStatusChip(
                            label: l10n.periodFormDateRecordedChip,
                            icon: Icons.verified_outlined,
                            tone: CycleCareStatusTone.success,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: CycleCareSpacing.lg),
                    PeriodDateSection(
                      startDate: _startDate,
                      endDate: _endDate,
                      onStartTap: () => _pickStart(context),
                      onEndTap: () => _pickEnd(context),
                      onOngoingChanged: _toggleOngoing,
                    ),
                    const SizedBox(height: CycleCareSpacing.md),
                    PeriodFlowSection(
                      days: _activeDays(),
                      existingLogs: existingLogs,
                      flowChanges: _flowChanges,
                      onChanged: (date, value) => setState(
                        () => _flowChanges[DateOnly.normalize(date)] = value,
                      ),
                      isLoading: editing && flowLogs.isLoading,
                      isUnavailable: editing && flowLogs.hasError,
                    ),
                    const SizedBox(height: CycleCareSpacing.md),
                    CycleCareCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.periodFormNotesTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: CycleCareSpacing.xxs),
                          Text(
                            l10n.periodFormNotesHint,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: context.cycleCareColors.textSecondary,
                                ),
                          ),
                          const SizedBox(height: CycleCareSpacing.md),
                          TextField(
                            controller: _notesController,
                            maxLength: 500,
                            minLines: 3,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: l10n.periodFormNotesLabel,
                              hintText: l10n.periodFormNotesPlaceholder,
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_validationMessage != null) ...[
                      const SizedBox(height: CycleCareSpacing.md),
                      PeriodValidationMessage(message: _validationMessage!),
                    ],
                    const SizedBox(height: CycleCareSpacing.lg),
                    const PeriodPrivacyNote(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(CycleCareSpacing.page),
          decoration: BoxDecoration(
            color: context.cycleCareColors.surfaceTranslucent,
            border: Border(
              top: BorderSide(color: context.cycleCareColors.divider),
            ),
          ),
          child: FilledButton.icon(
            onPressed: actions.isLoading ? null : _save,
            icon: actions.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(
              actions.isLoading
                  ? l10n.periodFormSaving
                  : editing
                      ? l10n.commonSaveChanges
                      : l10n.commonSaveNote,
            ),
          ),
        ),
      ),
    );
  }

  List<DateTime> _activeDays() {
    final start = DateOnly.normalize(_startDate);
    final end = DateOnly.normalize(_endDate ?? DateTime.now());
    if (end.isBefore(start)) return [start];
    return [
      for (var date = start;
          !date.isAfter(end);
          date = date.add(const Duration(days: 1)))
        date,
    ];
  }

  Future<void> _pickStart(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateOnly.normalize(DateTime.now()),
      initialDate: _startDate,
      helpText: l10n.periodFormPickStartHelp,
    );
    if (value != null) {
      setState(() {
        _startDate = DateOnly.normalize(value);
        _validationMessage = null;
      });
    }
  }

  Future<void> _pickEnd(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final today = DateOnly.normalize(DateTime.now());
    final initial = _endDate == null || _endDate!.isBefore(DateTime(2000))
        ? _startDate
        : _endDate!;
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: today,
      initialDate: initial.isAfter(today) ? today : initial,
      helpText: l10n.periodFormPickEndHelp,
    );
    if (value != null) {
      setState(() {
        _endDate = DateOnly.normalize(value);
        _validationMessage = null;
      });
    }
  }

  void _toggleOngoing(bool ongoing) => setState(() {
        _validationMessage = null;
        _endDate = ongoing ? null : DateOnly.normalize(DateTime.now());
      });

  Future<void> _save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final validation = _validateDates();
    if (validation != null) {
      setState(() => _validationMessage = validation);
      return;
    }
    setState(() => _validationMessage = null);

    try {
      final record = _editingRecord;
      if (record != null) {
        final outside =
            await ref.read(periodDayLogRepositoryProvider).getOutsideRange(
                  periodEntryId: record.id,
                  startDate: _startDate,
                  endDate: _endDate,
                );
        if (!mounted) return;
        if (outside.isNotEmpty) {
          final l10n = AppLocalizations.of(context);
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.periodFormFlowOutOfRangeTitle),
              content: Text(
                l10n.periodFormFlowOutOfRangeMessage(outside.length),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.commonCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.periodFormFlowDeleteAndSave),
                ),
              ],
            ),
          );
          if (confirmed != true) return;
        }
      }

      await ref.read(periodActionsProvider.notifier).saveForm(
            record: record,
            startDate: _startDate,
            endDate: _endDate,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text,
            flowChanges: _flowChanges,
          );
      final state = ref.read(periodActionsProvider);
      if (state.hasError) {
        if (mounted) {
          setState(() => _validationMessage = _friendlyError(state.error));
        }
      } else if (mounted) {
        context.pop();
      }
    } catch (error) {
      if (mounted) {
        setState(() => _validationMessage = _friendlyError(error));
      }
    }
  }

  String? _validateDates() {
    final l10n = AppLocalizations.of(context);
    final today = DateOnly.normalize(DateTime.now());
    if (_startDate.isAfter(today)) {
      return l10n.periodFormValidationStartFuture;
    }
    if (_endDate != null && _endDate!.isBefore(_startDate)) {
      return l10n.periodFormValidationEndBeforeStart;
    }
    if (_endDate != null && _endDate!.isAfter(today)) {
      return l10n.periodFormValidationEndFuture;
    }
    return null;
  }

  String _friendlyError(Object? error) {
    final l10n = AppLocalizations.of(context);
    if (error is AppFailure) {
      if (error.message.contains('tumpang tindih') || error.message.toLowerCase().contains('overlap')) {
        return l10n.periodFormOverlap;
      }
      return error.message;
    }
    return l10n.periodFormSaveFailed;
  }
}
