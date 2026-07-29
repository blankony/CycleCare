import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/period_record.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final records =
        ref.watch(activePeriodsProvider).valueOrNull ?? const <PeriodRecord>[];
    final prediction = ref.watch(predictionProvider).valueOrNull;
    final markers = _buildMarkers(records, prediction);
    final selected = _selectedDay ?? _focusedDay;
    final selectedRecords = records
        .where((record) =>
            isSameDay(record.startDate, selected) ||
            (record.endDate != null &&
                !selected.isBefore(record.startDate) &&
                !selected.isAfter(record.endDate!)))
        .toList();
    return Scaffold(
      appBar: const CycleCareAppBar(title: 'Kalender'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        children: [
          Card(
            child: TableCalendar<String>(
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) =>
                  markers[DateTime(day.year, day.month, day.day)] ?? const [],
              onDaySelected: (selectedDay, focusedDay) => setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              }),
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle),
                todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Legend(),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: selectedRecords.isEmpty
                  ? Text(
                      'Tidak ada catatan pada ${DateOnly.display(selected)}.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text('Detail ${DateOnly.display(selected)}',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          ...selectedRecords.map((record) => Text(
                              'Period ${DateOnly.display(record.startDate)}')),
                        ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/add-period'),
          label: const Text('Catat'),
          icon: const Icon(Icons.add)),
    );
  }

  Map<DateTime, List<String>> _buildMarkers(
      List<PeriodRecord> records, dynamic prediction) {
    final markers = <DateTime, List<String>>{};
    void add(DateTime date, String value) {
      final key = DateTime(date.year, date.month, date.day);
      markers.putIfAbsent(key, () => []).add(value);
    }

    for (final record in records) {
      var date = record.startDate;
      final end = record.endDate ?? record.startDate;
      while (!date.isAfter(end)) {
        add(date, 'period');
        date = date.add(const Duration(days: 1));
      }
    }
    if (prediction?.predictedStart != null) {
      add(prediction.predictedStart, 'prediksi');
      var date = prediction.windowStart;
      while (!date.isAfter(prediction.windowEnd)) {
        add(date, 'rentang');
        date = date.add(const Duration(days: 1));
      }
    }
    return markers;
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: 16, runSpacing: 8, children: const [
        Chip(
            avatar: Icon(Icons.circle, size: 12),
            label: Text('Period tercatat')),
        Chip(avatar: Icon(Icons.star, size: 14), label: Text('Perkiraan')),
      ]);
}
