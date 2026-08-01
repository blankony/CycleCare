import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/period_record.dart';
import '../../../domain/entities/cycle_insights.dart';

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
    final projections = ref.watch(projectionsProvider);
    final settings = ref.watch(userCycleSettingsProvider).valueOrNull;
    final markers = _buildMarkers(
      records,
      projections,
      showOvulation: settings?.showOvulationEstimate == true,
      showFertile: settings?.showFertileWindow == true,
    );
    final selected = _selectedDay ?? _focusedDay;
    final selectedEvents =
        markers[DateTime(selected.year, selected.month, selected.day)] ??
            const [];
    final selectedRecords = records.where((record) {
      final inStart = isSameDay(record.startDate, selected);
      final inRange = record.endDate != null &&
          !selected.isBefore(record.startDate) &&
          !selected.isAfter(record.endDate!);
      return inStart || inRange;
    }).toList();
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
          const _Legend(),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detail ${DateOnly.display(selected)}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (selectedRecords.isEmpty && selectedEvents.isEmpty)
                    const Text(
                        'Tidak ada catatan atau perkiraan pada tanggal ini.')
                  else ...[
                    ...selectedRecords.map((record) => Text(
                        '● Tercatat: period ${DateOnly.display(record.startDate)}')),
                    ...selectedEvents.map((event) => Text('◌ $event')),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
              'Perkiraan jauh ke depan memiliki tingkat kepastian lebih rendah.'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-period'),
        label: const Text('Catat'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Map<DateTime, List<String>> _buildMarkers(
    List<PeriodRecord> records,
    List<FutureCycleProjection> projections, {
    required bool showOvulation,
    required bool showFertile,
  }) {
    final markers = <DateTime, List<String>>{};
    void add(DateTime date, String value) {
      final key = DateTime(date.year, date.month, date.day);
      markers.putIfAbsent(key, () => []).add(value);
    }

    for (final record in records) {
      final end = record.endDate ?? record.startDate;
      for (var date = record.startDate;
          !date.isAfter(end);
          date = date.add(const Duration(days: 1))) {
        add(date, 'Period tercatat');
      }
    }
    for (final projection in projections) {
      var date = projection.windowStart;
      while (!date.isAfter(projection.windowEnd)) {
        add(date, 'Rentang perkiraan ${projection.sequence}');
        date = date.add(const Duration(days: 1));
      }
      add(projection.predictedStart, 'Pusat perkiraan ${projection.sequence}');
      if (showOvulation) {
        add(projection.predictedStart.subtract(const Duration(days: 14)),
            'Perkiraan ovulasi ${projection.sequence}');
      }
      if (showFertile) {
        final fertileStart =
            projection.windowStart.subtract(const Duration(days: 14 + 5));
        final fertileEnd =
            projection.windowEnd.subtract(const Duration(days: 13));
        for (date = fertileStart;
            !date.isAfter(fertileEnd);
            date = date.add(const Duration(days: 1))) {
          add(date, 'Perkiraan masa subur ${projection.sequence}');
        }
      }
    }
    final today = DateTime.now();
    add(today, 'Hari ini');
    return markers;
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            children: const [
              Chip(
                  avatar: Icon(Icons.circle, size: 12),
                  label: Text('Tercatat')),
              Chip(
                  avatar: Icon(Icons.crop_square, size: 14),
                  label: Text('Rentang perkiraan')),
              Chip(
                  avatar: Icon(Icons.star_border, size: 14),
                  label: Text('Pusat perkiraan')),
              Chip(
                  avatar: Icon(Icons.blur_on, size: 14),
                  label: Text('Ovulasi / masa subur')),
              Chip(
                  avatar: Icon(Icons.today, size: 14), label: Text('Hari ini')),
            ],
          ),
        ),
      );
}
