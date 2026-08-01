import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/period_record.dart';

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
  String? _validationMessage;

  PeriodRecord? get _editingRecord =>
      widget.record is PeriodRecord ? widget.record as PeriodRecord : null;

  @override
  void initState() {
    super.initState();
    final record = _editingRecord;
    _startDate = record?.startDate ?? DateTime.now();
    _endDate = record?.endDate;
    _notesController = TextEditingController(text: record?.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title:
                Text(_editingRecord == null ? 'Tambah period' : 'Edit period')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _DateField(
                label: 'Tanggal mulai',
                value: _startDate,
                onTap: () => _pickStart(context)),
            const SizedBox(height: 16),
            _DateField(
                label: 'Tanggal selesai (opsional)',
                value: _endDate,
                onTap: () => _pickEnd(context)),
            if (_endDate != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () => setState(() => _endDate = null),
                    child: const Text('Hapus tanggal selesai')),
              ),
            if (_editingRecord != null) ...[
              const SizedBox(height: 8),
              _FlowEditor(
                period: _editingRecord!,
                onError: (message) =>
                    setState(() => _validationMessage = message),
              ),
            ] else
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                    'Simpan period terlebih dahulu untuk mencatat flow harian.'),
              ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLength: 500,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  hintText: 'Contoh: catatan singkat'),
            ),
            if (_validationMessage != null) ...[
              const SizedBox(height: 8),
              Text(_validationMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 20),
            FilledButton(onPressed: _save, child: const Text('Simpan catatan')),
          ],
        ),
      );

  Future<void> _pickStart(BuildContext context) async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: _startDate,
    );
    if (value != null) setState(() => _startDate = value);
  }

  Future<void> _pickEnd(BuildContext context) async {
    final value = await showDatePicker(
      context: context,
      firstDate: _startDate,
      lastDate: DateTime.now(),
      initialDate: _endDate ?? _startDate,
    );
    if (value != null) setState(() => _endDate = value);
  }

  Future<void> _save() async {
    setState(() => _validationMessage = null);
    try {
      final actions = ref.read(periodActionsProvider.notifier);
      final record = _editingRecord;
      if (record == null) {
        await actions.create(
            startDate: _startDate, notes: _notesController.text);
      } else {
        final outside =
            await ref.read(periodDayLogRepositoryProvider).getOutsideRange(
                  periodEntryId: record.id,
                  startDate: _startDate,
                  endDate: _endDate,
                );
        if (!mounted) return;
        if (outside.isNotEmpty) {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Flow di luar rentang period'),
              content: Text(
                '${outside.length} catatan flow berada di luar tanggal baru dan akan dihapus. Lanjutkan?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Hapus dan simpan'),
                ),
              ],
            ),
          );
          if (confirmed != true) return;
        }
        await actions.updateRecord(
          record: record.copyWith(
            startDate: _startDate,
            endDate: _endDate,
            clearEndDate: _endDate == null,
            notes: _notesController.text,
          ),
        );
        await actions.clearFlowsOutsideRange(
          periodEntryId: record.id,
          startDate: _startDate,
          endDate: _endDate,
        );
      }
      final state = ref.read(periodActionsProvider);
      if (state.hasError) {
        setState(() => _validationMessage = state.error.toString());
      } else if (mounted) {
        context.pop();
      }
    } catch (error) {
      setState(() => _validationMessage = error.toString());
    }
  }
}

class _FlowEditor extends ConsumerWidget {
  const _FlowEditor({required this.period, required this.onError});

  final PeriodRecord period;
  final ValueChanged<String> onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(flowLogsProvider).valueOrNull ?? const [];
    final byDate = {
      for (final log in logs.where((log) => log.periodEntryId == period.id))
        DateOnly.format(log.logDate): log,
    };
    final end = period.endDate ?? DateOnly.normalize(DateTime.now());
    final days = <DateTime>[];
    for (var date = period.startDate;
        !date.isAfter(end);
        date = date.add(const Duration(days: 1))) {
      days.add(date);
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flow harian', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            const Text(
                'Opsional. Pilih level flow untuk setiap tanggal period.'),
            const SizedBox(height: 10),
            ...days.map((day) {
              final key = DateOnly.format(day);
              final log = byDate[key];
              final current = MenstrualFlowText.fromValue(log?.flow);
              return Row(
                children: [
                  SizedBox(width: 92, child: Text(DateOnly.display(day))),
                  Expanded(
                    child: DropdownButtonFormField<MenstrualFlow?>(
                      initialValue: current,
                      decoration: const InputDecoration(
                        labelText: 'Flow',
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem<MenstrualFlow?>(
                          value: null,
                          child: Text('Tidak dicatat'),
                        ),
                        ...MenstrualFlow.values.map(
                          (flow) => DropdownMenuItem<MenstrualFlow?>(
                            value: flow,
                            child: Text('${flow.indicator} · ${flow.label}'),
                          ),
                        ),
                      ],
                      onChanged: (value) async {
                        try {
                          final actions =
                              ref.read(periodActionsProvider.notifier);
                          if (value == null) {
                            if (log != null) await actions.clearFlow(log.id);
                          } else {
                            await actions.saveFlow(
                              periodEntryId: period.id,
                              logDate: day,
                              flow: value.value,
                            );
                          }
                        } catch (error) {
                          onError(error.toString());
                        }
                      },
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField(
      {required this.label, required this.value, required this.onTap});

  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
              labelText: label, suffixIcon: const Icon(Icons.calendar_today)),
          child:
              Text(value == null ? 'Belum dipilih' : DateOnly.display(value!)),
        ),
      );
}
