import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../domain/entities/cycle_insights.dart';
import '../../../domain/entities/period_record.dart';
import '../../../domain/entities/sync_state.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateOnly.normalize(DateTime.now());
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final periods = ref.watch(activePeriodsProvider);
    final prediction = ref.watch(predictionProvider);
    final settings = ref.watch(userCycleSettingsProvider);

    return Scaffold(
      appBar: const CycleCareAppBar(title: 'Kalender'),
      body: CycleCareBackground(
        child: periods.when(
          loading: () => const CycleCareLoadingState(
            message: 'Menyiapkan kalender siklusmu…',
            cardCount: 2,
          ),
          error: (_, __) => CycleCareErrorState(
            message:
                'Kalender belum dapat dimuat. Data kesehatanmu tetap aman di perangkat.',
            onRetry: () => ref.invalidate(activePeriodsProvider),
          ),
          data: (records) => _CalendarContent(
            records: records,
            projections: ref.watch(projectionsProvider),
            showFertile: settings.valueOrNull?.showFertileWindow == true,
            showOvulation: settings.valueOrNull?.showOvulationEstimate == true,
            predictionUnavailable: prediction.hasError,
            preferencesUnavailable: settings.hasError,
            predictionLoading: prediction.isLoading,
            preferencesLoading: settings.isLoading,
            syncSnapshot: ref.watch(syncSnapshotProvider),
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onDaySelected: (selectedDay, focusedDay) => setState(() {
              _selectedDay = DateOnly.normalize(selectedDay);
              _focusedDay = DateOnly.normalize(focusedDay);
            }),
            onPageChanged: (focusedDay) => setState(
              () => _focusedDay = DateOnly.normalize(focusedDay),
            ),
            onRefresh: () async {
              await ref.read(syncControllerProvider).synchronizeNow();
              ref.invalidate(activePeriodsProvider);
              ref.invalidate(predictionProvider);
              ref.invalidate(userCycleSettingsProvider);
              await ref.read(activePeriodsProvider.future);
            },
            onRetrySync: () => ref.read(syncControllerProvider).retry(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Catat period',
        onPressed: () => context.push('/add-period'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Catat period'),
      ),
    );
  }
}

class _CalendarContent extends StatelessWidget {
  const _CalendarContent({
    required this.records,
    required this.projections,
    required this.showFertile,
    required this.showOvulation,
    required this.predictionUnavailable,
    required this.preferencesUnavailable,
    required this.predictionLoading,
    required this.preferencesLoading,
    required this.syncSnapshot,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onRefresh,
    required this.onRetrySync,
  });

  final List<PeriodRecord> records;
  final List<FutureCycleProjection> projections;
  final bool showFertile;
  final bool showOvulation;
  final bool predictionUnavailable;
  final bool preferencesUnavailable;
  final bool predictionLoading;
  final bool preferencesLoading;
  final SyncGateSnapshot syncSnapshot;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime, DateTime) onDaySelected;
  final ValueChanged<DateTime> onPageChanged;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetrySync;

  @override
  Widget build(BuildContext context) {
    final events = _buildEvents(
      records,
      projections,
      showOvulation: showOvulation,
      showFertile: showFertile,
    );
    final latest = records.isEmpty
        ? null
        : records
            .map((record) => record.startDate)
            .reduce((a, b) => a.isAfter(b) ? a : b);
    final selected = selectedDay ??
        (latest != null &&
                latest.year == focusedDay.year &&
                latest.month == focusedDay.month
            ? DateOnly.normalize(latest)
            : focusedDay);
    final selectedEvents = events[selected] ?? const <_CalendarEvent>[];
    final selectedRecords = records.where((record) {
      final end = record.endDate ?? record.startDate;
      return !selected.isBefore(DateOnly.normalize(record.startDate)) &&
          !selected.isAfter(DateOnly.normalize(end));
    }).toList();
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
                  if (showsSync) ...[
                    CycleCareSyncBanner(
                      snapshot: syncSnapshot,
                      onRetry: onRetrySync,
                    ),
                    const SizedBox(height: CycleCareSpacing.md),
                  ],
                  if (predictionUnavailable ||
                      preferencesUnavailable ||
                      predictionLoading ||
                      preferencesLoading) ...[
                    _CalendarNotice(
                      message: predictionUnavailable
                          ? 'Perkiraan belum dapat ditampilkan. Catatan period tetap tersedia.'
                          : preferencesUnavailable
                              ? 'Pilihan masa subur belum dapat dimuat. Estimasi disembunyikan sementara.'
                              : 'Perkiraan dan pilihan kalender sedang disiapkan.',
                    ),
                    const SizedBox(height: CycleCareSpacing.md),
                  ],
                  _CalendarCard(
                    events: events,
                    focusedDay: focusedDay,
                    selectedDay: selected,
                    onDaySelected: onDaySelected,
                    onPageChanged: onPageChanged,
                    showFertile: showFertile,
                    showOvulation: showOvulation,
                  ),
                  const SizedBox(height: CycleCareSpacing.md),
                  _QuickOngoingCalendarToggle(records: records),
                  const SizedBox(height: CycleCareSpacing.md),
                  _SelectedDateCard(
                    selectedDay: selected,
                    records: selectedRecords,
                    events: selectedEvents,
                    hasAnyRecords: records.isNotEmpty,
                  ),
                  const SizedBox(height: CycleCareSpacing.md),
                  const _PredictionSafetyNote(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.events,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.showFertile,
    required this.showOvulation,
  });

  final Map<DateTime, List<_CalendarEvent>> events;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final void Function(DateTime, DateTime) onDaySelected;
  final ValueChanged<DateTime> onPageChanged;
  final bool showFertile;
  final bool showOvulation;

  @override
  Widget build(BuildContext context) => ClipRect(
        child: CycleCareCard(
          padding: const EdgeInsets.fromLTRB(
            CycleCareSpacing.sm,
            CycleCareSpacing.sm,
            CycleCareSpacing.sm,
            CycleCareSpacing.lg,
          ),
          child: Column(
            children: [
              TableCalendar<int>(
                    locale: 'id_ID',
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    focusedDay: focusedDay,
                    currentDay: DateOnly.normalize(DateTime.now()),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    availableGestures: AvailableGestures.none,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Bulan',
                    },
                    selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                    eventLoader: (_) => const [0],
                    onDaySelected: onDaySelected,
                    onPageChanged: onPageChanged,
                    daysOfWeekHeight: 32,
                    rowHeight: 48,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      headerPadding: const EdgeInsets.only(
                        bottom: CycleCareSpacing.sm,
                      ),
                      leftChevronIcon: const Icon(Icons.chevron_left_rounded),
                      rightChevronIcon: const Icon(Icons.chevron_right_rounded),
                      leftChevronPadding:
                          const EdgeInsets.all(CycleCareSpacing.sm),
                      rightChevronPadding:
                          const EdgeInsets.all(CycleCareSpacing.sm),
                      titleTextFormatter: (date, locale) =>
                          DateFormat('MMMM yyyy', locale).format(date),
                       titleTextStyle: Theme.of(context).textTheme.titleLarge!,
                    ),
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: true,
                      markersMaxCount: 0,
                      cellMargin: EdgeInsets.zero,
                      cellPadding: EdgeInsets.zero,
                    ),
                    calendarBuilders: CalendarBuilders<int>(
                      dowBuilder: (context, day) => Center(
                        child: Text(
                          DateFormat.E('id_ID').format(day).substring(0, 1),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: context.cycleCareColors.textSecondary,
                              ),
                        ),
                      ),
                      defaultBuilder: (context, day, _) => _CalendarDay(
                        day: day,
                        events: events[DateOnly.normalize(day)] ?? const [],
                        isSelected: false,
                        isToday: isSameDay(day, DateTime.now()),
                      ),
                      todayBuilder: (context, day, _) => _CalendarDay(
                        day: day,
                        events: events[DateOnly.normalize(day)] ?? const [],
                        isSelected: isSameDay(day, selectedDay),
                        isToday: true,
                      ),
                      selectedBuilder: (context, day, _) => _CalendarDay(
                        day: day,
                        events: events[DateOnly.normalize(day)] ?? const [],
                        isSelected: true,
                        isToday: isSameDay(day, DateTime.now()),
                      ),
                      outsideBuilder: (context, day, _) => _CalendarDay(
                        day: day,
                        events: events[DateOnly.normalize(day)] ?? const [],
                        isSelected: isSameDay(day, selectedDay),
                        isToday: isSameDay(day, DateTime.now()),
                        isOutside: true,
                      ),
                      markerBuilder: (context, day, _) => Positioned.fill(
                        child: Semantics(
                          container: true,
                          button: true,
                          selected: isSameDay(day, selectedDay),
                          label: _daySemanticLabel(
                            day,
                            events[DateOnly.normalize(day)] ?? const [],
                            isToday: isSameDay(day, DateTime.now()),
                            isSelected: isSameDay(day, selectedDay),
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: CycleCareSpacing.md),
              Divider(color: context.cycleCareColors.divider, height: 1),
              const SizedBox(height: CycleCareSpacing.md),
              _Legend(
                showFertile: showFertile,
                showOvulation: showOvulation,
              ),
            ],
          ),
        ),
      );
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    required this.events,
    required this.isSelected,
    required this.isToday,
    this.isOutside = false,
  });

  final DateTime day;
  final List<_CalendarEvent> events;
  final bool isSelected;
  final bool isToday;
  final bool isOutside;

  @override
  Widget build(BuildContext context) {
    final types = events.map((event) => event.type).toSet();
    final recorded = types.contains(_CalendarEventType.recorded);
    final predicted = types.contains(_CalendarEventType.predicted);
    final fertile = types.contains(_CalendarEventType.fertile);
    final ovulation = types.contains(_CalendarEventType.ovulation);
    final colors = context.cycleCareColors;
    final dark = Theme.of(context).brightness == Brightness.dark;

    var background = Colors.transparent;
    var foreground = colors.textPrimary;
    if (fertile) {
      background = CycleCareColors.fertileSoft.withValues(
        alpha: dark ? 0.18 : 1,
      );
    }
    if (predicted) {
      background = CycleCareColors.predictionSoft.withValues(
        alpha: dark ? 0.20 : 1,
      );
    }
    if (recorded) {
      background = dark
          ? CycleCareColors.period.withValues(alpha: 0.70)
          : CycleCareColors.period;
      foreground = Colors.white;
    }

    final borderColor = isSelected
        ? CycleCareColors.classicBlue
        : isToday
            ? colors.textSecondary
            : predicted
                ? CycleCareColors.oceanBlue
                : fertile
                    ? CycleCareColors.skyBlue
                    : Colors.transparent;
    return Opacity(
      opacity: isOutside ? 0.38 : 1,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : 48.0;
            final diameter = (cellWidth - 6).clamp(28.0, 42.0);
            return Container(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: isSelected ? 2.5 : (isToday || predicted ? 1.5 : 1),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: CycleCareSpacing.xs),
                    child: Text(
                      '${day.day}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: foreground,
                            fontWeight: isSelected || recorded
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                    ),
                  ),
                  Positioned(
                    bottom: diameter * 0.12,
                    child: _DayMarkers(
                      recorded: recorded,
                      predicted: predicted,
                      fertile: fertile,
                      ovulation: ovulation,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DayMarkers extends StatelessWidget {
  const _DayMarkers({
    required this.recorded,
    required this.predicted,
    required this.fertile,
    required this.ovulation,
  });

  final bool recorded;
  final bool predicted;
  final bool fertile;
  final bool ovulation;

  @override
  Widget build(BuildContext context) {
    final onPeriod = recorded;
    final markers = <Widget>[
      if (recorded)
        Icon(
          Icons.water_drop_rounded,
          size: 8,
          color: onPeriod ? Colors.white : CycleCareColors.period,
        ),
      if (predicted)
        Icon(
          Icons.circle_outlined,
          size: 8,
          color: onPeriod ? Colors.white : CycleCareColors.periodStrong,
        ),
      if (fertile)
        Container(
          width: 7,
          height: 4,
          decoration: BoxDecoration(
            color: onPeriod ? Colors.white : CycleCareColors.fertileStrong,
            borderRadius: BorderRadius.circular(CycleCareRadius.pill),
          ),
        ),
      if (ovulation)
        Transform.rotate(
          angle: 0.78,
          child: Container(
            width: 6,
            height: 6,
            color: CycleCareColors.warning,
          ),
        ),
    ];
    if (markers.isEmpty) return const SizedBox(height: 8);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < markers.length; index++) ...[
          if (index > 0) const SizedBox(width: 2),
          markers[index],
        ],
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.showFertile, required this.showOvulation});

  final bool showFertile;
  final bool showOvulation;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: CycleCareSpacing.xs,
        runSpacing: CycleCareSpacing.xs,
        children: [
          const _LegendItem(
            label: 'Period tercatat',
            type: _CalendarEventType.recorded,
          ),
          const _LegendItem(
            label: 'Perkiraan period',
            type: _CalendarEventType.predicted,
          ),
          if (showFertile)
            const _LegendItem(
              label: 'Masa subur',
              type: _CalendarEventType.fertile,
            ),
          if (showOvulation)
            const _LegendItem(
              label: 'Ovulasi',
              type: _CalendarEventType.ovulation,
            ),
          const _TodayLegendItem(),
        ],
      );
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.type});

  final String label;
  final _CalendarEventType type;

  @override
  Widget build(BuildContext context) {
    final visual = switch (type) {
      _CalendarEventType.recorded => const Icon(
          Icons.water_drop_rounded,
          size: 14,
          color: CycleCareColors.period,
        ),
      _CalendarEventType.predicted => const Icon(
          Icons.circle_outlined,
          size: 14,
          color: CycleCareColors.periodStrong,
        ),
      _CalendarEventType.fertile => Container(
          width: 14,
          height: 8,
          decoration: BoxDecoration(
            color: CycleCareColors.fertile,
            borderRadius: BorderRadius.circular(CycleCareRadius.pill),
          ),
        ),
      _CalendarEventType.ovulation => Transform.rotate(
          angle: 0.78,
          child: Container(
            width: 9,
            height: 9,
            color: CycleCareColors.ovulation,
          ),
        ),
    };
    return _LegendPill(label: label, visual: visual);
  }
}

class _TodayLegendItem extends StatelessWidget {
  const _TodayLegendItem();

  @override
  Widget build(BuildContext context) => _LegendPill(
        label: 'Hari ini',
        visual: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: context.cycleCareColors.textSecondary),
          ),
        ),
      );
}

class _LegendPill extends StatelessWidget {
  const _LegendPill({required this.label, required this.visual});

  final String label;
  final Widget visual;

  @override
  Widget build(BuildContext context) => Semantics(
        label: label,
        child: Container(
          constraints: const BoxConstraints(minHeight: 32),
          padding: const EdgeInsets.symmetric(
            horizontal: CycleCareSpacing.sm,
            vertical: CycleCareSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: context.cycleCareColors.surfaceMuted,
            borderRadius: BorderRadius.circular(CycleCareRadius.pill),
            border: Border.all(color: context.cycleCareColors.divider),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              visual,
              const SizedBox(width: CycleCareSpacing.xxs),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      );
}

class _SelectedDateCard extends StatelessWidget {
  const _SelectedDateCard({
    required this.selectedDay,
    required this.records,
    required this.events,
    required this.hasAnyRecords,
  });

  final DateTime selectedDay;
  final List<PeriodRecord> records;
  final List<_CalendarEvent> events;
  final bool hasAnyRecords;

  @override
  Widget build(BuildContext context) {
    final eventTypes = events.map((event) => event.type).toSet();
    final hasEstimate = eventTypes.any(
      (type) => type != _CalendarEventType.recorded,
    );

    return CycleCareCard(
      semanticLabel: 'Detail ${DateOnly.display(selectedDay)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('d MMMM', 'id_ID').format(selectedDay),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: CycleCareSpacing.xxs),
                    Text(
                      DateFormat('EEEE, yyyy', 'id_ID').format(selectedDay),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.cycleCareColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              if (records.isNotEmpty)
                const CycleCareStatusChip(
                  label: 'Tercatat',
                  icon: Icons.verified_outlined,
                  tone: CycleCareStatusTone.success,
                )
              else if (hasEstimate)
                const CycleCareStatusChip(
                  label: 'Perkiraan',
                  icon: Icons.auto_awesome_outlined,
                  tone: CycleCareStatusTone.info,
                ),
            ],
          ),
          const SizedBox(height: CycleCareSpacing.md),
          if (records.isEmpty && events.isEmpty)
            _SelectedDateEmpty(hasAnyRecords: hasAnyRecords)
          else ...[
            for (final record in records) ...[
              _DetailRow(
                icon: Icons.water_drop_outlined,
                title: 'Period tercatat',
                message: _recordRange(record),
                color: CycleCareColors.period,
              ),
              const SizedBox(height: CycleCareSpacing.sm),
            ],
            for (final event in events.where(
              (event) => event.type != _CalendarEventType.recorded,
            )) ...[
              _DetailRow(
                icon: event.type.icon,
                title: event.type.detailTitle,
                message: event.description,
                color: event.type.color,
              ),
              const SizedBox(height: CycleCareSpacing.sm),
            ],
          ],
        ],
      ),
    );
  }

  String _recordRange(PeriodRecord record) {
    if (record.endDate == null) {
      return 'Dimulai ${DateOnly.display(record.startDate)} dan masih berlangsung.';
    }
    return '${DateOnly.display(record.startDate)} sampai ${DateOnly.display(record.endDate!)}.';
  }
}

class _SelectedDateEmpty extends StatelessWidget {
  const _SelectedDateEmpty({required this.hasAnyRecords});

  final bool hasAnyRecords;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(CycleCareSpacing.md),
        decoration: BoxDecoration(
          color: context.cycleCareColors.surfaceMuted,
          borderRadius: CycleCareRadius.mediumBorder,
          border: Border.all(color: context.cycleCareColors.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.event_note_outlined,
              color: context.cycleCareColors.textSecondary,
            ),
            const SizedBox(width: CycleCareSpacing.sm),
            Expanded(
              child: Text(
                hasAnyRecords
                    ? 'Tidak ada catatan atau perkiraan pada tanggal ini.'
                    : 'Belum ada catatan period. Catat period pertamamu untuk mulai melihat pola siklus.',
              ),
            ),
          ],
        ),
      );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.18
                    : 0.12,
              ),
              borderRadius: BorderRadius.circular(CycleCareRadius.small),
            ),
            child: Icon(icon, size: 19, color: color),
          ),
          const SizedBox(width: CycleCareSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: CycleCareSpacing.xxs),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      );
}

class _QuickOngoingCalendarToggle extends ConsumerWidget {
  const _QuickOngoingCalendarToggle({required this.records});

  final List<PeriodRecord> records;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoing = records.where((r) => r.endDate == null).firstOrNull;
    final busy = ref.watch(periodActionsProvider).isLoading;
    if (ongoing != null) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: busy
              ? null
              : () async {
                  try {
                    await ref.read(periodActionsProvider.notifier).finish(ongoing.id, DateTime.now());
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Period diselesaikan hari ini.')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
          icon: const Icon(Icons.stop_circle_outlined, size: 18),
          label: const Text('Selesaikan period hari ini'),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: busy
            ? null
            : () async {
                try {
                  await ref.read(periodActionsProvider.notifier).create(startDate: DateTime.now());
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Period dimulai hari ini.')));
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
        icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
        label: const Text('Mulai period hari ini'),
      ),
    );
  }
}

class _CalendarNotice extends StatelessWidget {
  const _CalendarNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => CycleCareCard(
        padding: const EdgeInsets.all(CycleCareSpacing.md),
        color: context.cycleCareColors.surfaceMuted,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded, size: 20),
            const SizedBox(width: CycleCareSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
}

class _PredictionSafetyNote extends StatelessWidget {
  const _PredictionSafetyNote();

  @override
  Widget build(BuildContext context) => Semantics(
        label:
            'Informasi perkiraan. Perkiraan dapat berubah seiring catatan baru. Estimasi masa subur bukan panduan kontrasepsi.',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: CycleCareSpacing.md),
          child: Text(
            'Perkiraan dapat berubah seiring catatan baru. Estimasi masa subur bukan panduan kontrasepsi.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.cycleCareColors.textSecondary,
                ),
          ),
        ),
      );
}

Map<DateTime, List<_CalendarEvent>> _buildEvents(
  List<PeriodRecord> records,
  List<FutureCycleProjection> projections, {
  required bool showOvulation,
  required bool showFertile,
}) {
  final events = <DateTime, List<_CalendarEvent>>{};
  void add(DateTime date, _CalendarEvent event) {
    final key = DateOnly.normalize(date);
    final existing = events.putIfAbsent(key, () => []);
    if (!existing.contains(event)) existing.add(event);
  }

  for (final record in records) {
    final end = record.endDate ?? record.startDate;
    for (var date = DateOnly.normalize(record.startDate);
        !date.isAfter(DateOnly.normalize(end));
        date = date.add(const Duration(days: 1))) {
      add(
        date,
        const _CalendarEvent(
          type: _CalendarEventType.recorded,
          description: 'Tanggal ini termasuk dalam period yang kamu catat.',
        ),
      );
    }
  }

  for (final projection in projections) {
    for (var date = DateOnly.normalize(projection.windowStart);
        !date.isAfter(DateOnly.normalize(projection.windowEnd));
        date = date.add(const Duration(days: 1))) {
      add(
        date,
        _CalendarEvent(
          type: _CalendarEventType.predicted,
          description:
              'Tanggal ini termasuk rentang perkiraan period siklus ke-${projection.sequence}.',
        ),
      );
    }
    if (showOvulation) {
      add(
        projection.predictedStart.subtract(const Duration(days: 14)),
        _CalendarEvent(
          type: _CalendarEventType.ovulation,
          description:
              'Perkiraan ovulasi siklus ke-${projection.sequence}. Tanggal ini dapat berubah.',
        ),
      );
    }
    if (showFertile) {
      final fertileStart =
          projection.windowStart.subtract(const Duration(days: 19));
      final fertileEnd =
          projection.windowEnd.subtract(const Duration(days: 13));
      for (var date = DateOnly.normalize(fertileStart);
          !date.isAfter(DateOnly.normalize(fertileEnd));
          date = date.add(const Duration(days: 1))) {
        add(
          date,
          _CalendarEvent(
            type: _CalendarEventType.fertile,
            description:
                'Tanggal ini termasuk estimasi masa subur siklus ke-${projection.sequence}.',
          ),
        );
      }
    }
  }
  return events;
}

enum _CalendarEventType { recorded, predicted, fertile, ovulation }

extension on _CalendarEventType {
  String get semanticLabel => switch (this) {
        _CalendarEventType.recorded => 'period tercatat',
        _CalendarEventType.predicted => 'perkiraan period',
        _CalendarEventType.fertile => 'perkiraan masa subur',
        _CalendarEventType.ovulation => 'perkiraan ovulasi',
      };

  String get detailTitle => switch (this) {
        _CalendarEventType.recorded => 'Period tercatat',
        _CalendarEventType.predicted => 'Perkiraan period',
        _CalendarEventType.fertile => 'Masa subur (perkiraan)',
        _CalendarEventType.ovulation => 'Ovulasi (perkiraan)',
      };

  IconData get icon => switch (this) {
        _CalendarEventType.recorded => Icons.water_drop_outlined,
        _CalendarEventType.predicted => Icons.event_repeat_rounded,
        _CalendarEventType.fertile => Icons.blur_on_rounded,
        _CalendarEventType.ovulation => Icons.brightness_5_outlined,
      };

  Color get color => switch (this) {
        _CalendarEventType.recorded => CycleCareColors.period,
        _CalendarEventType.predicted => CycleCareColors.periodStrong,
        _CalendarEventType.fertile => CycleCareColors.fertileStrong,
        _CalendarEventType.ovulation => CycleCareColors.warning,
      };
}

String _daySemanticLabel(
  DateTime day,
  List<_CalendarEvent> events, {
  required bool isToday,
  required bool isSelected,
}) {
  final parts = <String>[
    DateFormat('d MMMM', 'id_ID').format(day),
    ...events.map((event) => event.type).toSet().map(
          (type) => type.semanticLabel,
        ),
    if (isToday) 'hari ini',
    if (isSelected) 'dipilih',
  ];
  return '${parts.join(', ')}.';
}

@immutable
class _CalendarEvent {
  const _CalendarEvent({required this.type, required this.description});

  final _CalendarEventType type;
  final String description;

  @override
  bool operator ==(Object other) =>
      other is _CalendarEvent &&
      other.type == type &&
      other.description == description;

  @override
  int get hashCode => Object.hash(type, description);
}
