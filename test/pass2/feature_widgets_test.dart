import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:cycle_care/app/providers.dart';
import 'package:cycle_care/app/theme.dart';
import 'package:cycle_care/domain/entities/cycle_insights.dart';
import 'package:cycle_care/domain/entities/enums.dart';
import 'package:cycle_care/domain/entities/period_day_log.dart';
import 'package:cycle_care/domain/entities/period_record.dart';
import 'package:cycle_care/domain/entities/prediction.dart';
import 'package:cycle_care/domain/entities/sync_state.dart';
import 'package:cycle_care/domain/entities/user_cycle_settings.dart';
import 'package:cycle_care/features/calendar/presentation/calendar_page.dart';
import 'package:cycle_care/features/dashboard/presentation/dashboard_page.dart';
import 'package:cycle_care/features/history/presentation/history_page.dart';
import 'package:cycle_care/features/period_form/presentation/period_form_page.dart';
import 'package:cycle_care/features/statistics/presentation/statistics_page.dart';
import 'package:cycle_care/features/summary/presentation/summary_page.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  final period = PeriodRecord(
    id: 'period-1',
    startDate: DateTime(2026, 7, 1),
    endDate: DateTime(2026, 7, 5),
    cycleLengthDays: 28,
    periodDurationDays: 5,
    createdAt: DateTime(2026, 7, 1),
    updatedAt: DateTime(2026, 7, 5),
    syncStatus: SyncStatus.synced,
  );
  final summaryPeriod = PeriodRecord(
    id: 'summary-period',
    startDate: DateTime(2026, 8, 1),
    endDate: DateTime(2026, 8, 3),
    cycleLengthDays: 29,
    periodDurationDays: 3,
    notes: 'Sedikit kram di hari pertama.',
    createdAt: DateTime(2026, 8, 1),
    updatedAt: DateTime(2026, 8, 3),
    syncStatus: SyncStatus.synced,
  );
  final summary = EndOfCycleSummary(
    period: summaryPeriod,
    flowCounts: const {
      MenstrualFlow.spotting: 1,
      MenstrualFlow.light: 1,
      MenstrualFlow.medium: 1,
    },
    previousAverageCycleLength: 28,
    differenceFromAverage: 1,
    reference: const AdultReferenceResult(
      cycleLength: ReferenceComparison.withinRange,
      bleedingDuration: ReferenceComparison.withinRange,
    ),
    pattern: CyclePattern.consistent,
  );
  final prediction = CyclePrediction(
    ready: true,
    predictedStart: DateTime(2026, 7, 29),
    windowStart: DateTime(2026, 7, 27),
    windowEnd: DateTime(2026, 7, 31),
    baselineCycleDays: 28,
    variabilityDays: 2,
    confidence: PredictionConfidence.high,
    basedOnCycles: 5,
    intervals: const [28, 28, 28, 28],
    excludedIntervals: const [],
    modelVersion: 'test',
  );
  final settings = UserCycleSettingsRecord(
    userId: 'user-1',
    showOvulationEstimate: true,
    showFertileWindow: true,
    reminderEnabled: false,
    initialSyncCompleted: true,
    updatedAt: DateTime(2026, 8, 1),
  );
  final hiddenSettings = UserCycleSettingsRecord(
    userId: 'user-1',
    showOvulationEstimate: false,
    showFertileWindow: false,
    reminderEnabled: false,
    initialSyncCompleted: true,
    updatedAt: DateTime(2026, 8, 1),
  );
  const statistics = CycleStatistics(
    recordedPeriods: 3,
    completedPeriods: 3,
    currentCycleDay: 32,
    latestCycleLength: 28,
    averageCycleLength: 28,
    medianCycleLength: 28,
    shortestCycle: 27,
    longestCycle: 29,
    cycleRange: 2,
    cycleVariability: 1,
    pattern: CyclePattern.consistent,
    averagePeriodDuration: 5,
    medianPeriodDuration: 5,
    shortestPeriod: 4,
    longestPeriod: 6,
    classificationCounts: {PeriodClassification.onWindow: 2},
    cycleLengthSamples: 3,
    periodDurationSamples: 3,
    recentCycleLengths: [27, 29, 28],
    flowCounts: {
      MenstrualFlow.spotting: 1,
      MenstrualFlow.light: 3,
      MenstrualFlow.medium: 4,
      MenstrualFlow.heavy: 2,
    },
  );

  testWidgets('dashboard shows late and fertility context', (tester) async {
    _useTallViewport(tester);
    final fertility = FertilityEstimate(
      ovulationCenter: DateTime(2026, 7, 15),
      earliestOvulation: DateTime(2026, 7, 13),
      latestOvulation: DateTime(2026, 7, 17),
      fertileWindowStart: DateTime(2026, 7, 8),
      fertileWindowEnd: DateTime(2026, 7, 18),
      confidence: PredictionConfidence.high,
    );
    final insights = CycleInsights(
      status: const CycleStatus(currentCycleDay: 32, lateDays: 1),
      statistics: statistics,
      prediction: prediction,
      fertility: fertility,
      projections: const [],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activePeriodsProvider.overrideWith((ref) => Stream.value([period])),
          predictionProvider.overrideWith((ref) => Stream.value(prediction)),
          userCycleSettingsProvider.overrideWith((ref) async => settings),
          cycleInsightsProvider.overrideWith((ref) async => insights),
          syncSnapshotProvider.overrideWithValue(
            const SyncGateSnapshot(
              status: SyncGateStatus.ready,
              pendingCount: 0,
            ),
          ),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.light(),
          home: const DashboardPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
        find.text('Terlambat 1 hari dari rentang perkiraan'), findsOneWidget);
    expect(find.textContaining('tidak ditujukan sebagai metode kontrasepsi'),
        findsOneWidget);
    expect(find.text('Masa subur'), findsWidgets);
    expect(find.text('Perkiraan ovulasi'), findsOneWidget);
    expect(find.text('Period berikutnya'), findsOneWidget);
  });

  testWidgets('dashboard keeps local data usable while offline',
      (tester) async {
    _useTallViewport(tester);
    final insights = CycleInsights(
      status: const CycleStatus(currentCycleDay: 32),
      statistics: statistics,
      prediction: prediction,
      projections: const [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activePeriodsProvider.overrideWith((ref) => Stream.value([period])),
          predictionProvider.overrideWith((ref) => Stream.value(prediction)),
          userCycleSettingsProvider.overrideWith((ref) async => settings),
          cycleInsightsProvider.overrideWith((ref) async => insights),
          syncSnapshotProvider.overrideWithValue(
            const SyncGateSnapshot(
              status: SyncGateStatus.offlineReady,
              pendingCount: 2,
            ),
          ),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.light(),
          home: const DashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Tersimpan di perangkat'), findsOneWidget);
    expect(find.textContaining('2 perubahan menunggu koneksi'), findsOneWidget);
    expect(find.text('Catat period'), findsOneWidget);
  });

  testWidgets('dashboard empty state keeps the primary recording action',
      (tester) async {
    _useTallViewport(tester);
    const emptyInsights = CycleInsights(
      status: CycleStatus(),
      statistics: CycleStatistics.empty(),
      projections: [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activePeriodsProvider.overrideWith((ref) => Stream.value([])),
          predictionProvider.overrideWith((ref) => Stream.value(null)),
          userCycleSettingsProvider.overrideWith((ref) async => hiddenSettings),
          cycleInsightsProvider.overrideWith((ref) async => emptyInsights),
          syncSnapshotProvider.overrideWithValue(
            const SyncGateSnapshot(
              status: SyncGateStatus.ready,
              pendingCount: 0,
            ),
          ),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.light(),
          home: const DashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Mulai catatanmu'), findsOneWidget);
    expect(find.text('Belum ada perkiraan period'), findsOneWidget);
    expect(find.text('Catat period'), findsOneWidget);
    expect(find.text('Masa subur'), findsNothing);
  });

  testWidgets('calendar explains recorded and projected markers',
      (tester) async {
    _useTallViewport(tester);
    final augustPeriod = period.copyWith(
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 8, 3),
      periodDurationDays: 3,
    );
    final projection = FutureCycleProjection(
      sequence: 1,
      predictedStart: DateTime(2026, 8, 1),
      windowStart: DateTime(2026, 7, 30),
      windowEnd: DateTime(2026, 8, 3),
      certainty: ProjectionCertainty.active,
      confidence: PredictionConfidence.high,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activePeriodsProvider
              .overrideWith((ref) => Stream.value([augustPeriod])),
          predictionProvider.overrideWith((ref) => Stream.value(prediction)),
          projectionsProvider.overrideWithValue([projection]),
          userCycleSettingsProvider.overrideWith((ref) async => settings),
          syncSnapshotProvider.overrideWithValue(
            const SyncGateSnapshot(
              status: SyncGateStatus.ready,
              pendingCount: 0,
            ),
          ),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.light(),
          home: const CalendarPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Period tercatat'), findsWidgets);
    expect(find.text('Perkiraan period'), findsWidgets);
    expect(
      find.textContaining('rentang perkiraan period siklus ke-1'),
      findsOneWidget,
    );
    expect(find.textContaining('bukan panduan kontrasepsi'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        '1 Agustus, period tercatat, perkiraan period, dipilih.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('history sorts records and keeps offline data usable',
      (tester) async {
    _useTallViewport(tester);
    final augustPeriod = PeriodRecord(
      id: 'period-august',
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 8, 3),
      cycleLengthDays: 29,
      periodDurationDays: 3,
      createdAt: DateTime(2026, 8, 1),
      updatedAt: DateTime(2026, 8, 3),
      syncStatus: SyncStatus.synced,
    );
    final flowLogs = [
      PeriodDayLogRecord(
        id: 'flow-1',
        periodEntryId: augustPeriod.id,
        logDate: DateTime(2026, 8, 1),
        flow: MenstrualFlow.light.value,
        createdAt: DateTime(2026, 8, 1),
        updatedAt: DateTime(2026, 8, 1),
      ),
      PeriodDayLogRecord(
        id: 'flow-2',
        periodEntryId: augustPeriod.id,
        logDate: DateTime(2026, 8, 2),
        flow: MenstrualFlow.medium.value,
        createdAt: DateTime(2026, 8, 2),
        updatedAt: DateTime(2026, 8, 2),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activePeriodsProvider.overrideWith(
            (ref) => Stream.value([period, augustPeriod]),
          ),
          flowLogsProvider.overrideWith((ref) => Stream.value(flowLogs)),
          syncSnapshotProvider.overrideWithValue(
            const SyncGateSnapshot(
              status: SyncGateStatus.offlineReady,
              pendingCount: 2,
            ),
          ),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.light(),
          home: const HistoryPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final august = find.text('1–3 Agustus 2026');
    final july = find.text('1–5 Juli 2026');
    expect(august, findsOneWidget);
    expect(july, findsOneWidget);
    expect(tester.getTopLeft(august).dy, lessThan(tester.getTopLeft(july).dy));
    expect(find.text('Ringan 1 hari · Sedang 1 hari'), findsOneWidget);
    expect(find.text('Tersimpan di perangkat'), findsOneWidget);
    expect(find.text('Lihat ringkasan'), findsNWidgets(2));
  });

  testWidgets('history empty state follows the approved copy', (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activePeriodsProvider.overrideWith((ref) => Stream.value([])),
          flowLogsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.light(),
          home: const HistoryPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada riwayat period.'), findsOneWidget);
    expect(
      find.text('Catat period pertamamu untuk mulai melihat pola siklus.'),
      findsOneWidget,
    );
    expect(find.text('Catat period'), findsWidgets);
  });

  testWidgets('phase two screens render on narrow dark layouts',
      (tester) async {
    _useViewport(tester, const Size(320, 1600));
    const readySync = SyncGateSnapshot(
      status: SyncGateStatus.ready,
      pendingCount: 0,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activePeriodsProvider.overrideWith((ref) => Stream.value([period])),
          predictionProvider.overrideWith((ref) => Stream.value(null)),
          projectionsProvider.overrideWithValue(const []),
          userCycleSettingsProvider.overrideWith((ref) async => hiddenSettings),
          syncSnapshotProvider.overrideWithValue(readySync),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.dark(),
          home: const CalendarPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Kalender'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(CalendarPage))).brightness,
      Brightness.dark,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activePeriodsProvider.overrideWith((ref) => Stream.value([period])),
          flowLogsProvider.overrideWith((ref) => Stream.value([])),
          syncSnapshotProvider.overrideWithValue(readySync),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.dark(),
          home: const HistoryPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Riwayat period'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(HistoryPage))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('calendar error state does not expose backend details',
      (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activePeriodsProvider.overrideWith(
            (ref) => Stream.error(Exception('private database detail')),
          ),
          predictionProvider.overrideWith((ref) => Stream.value(null)),
          userCycleSettingsProvider.overrideWith((ref) async => hiddenSettings),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.light(),
          home: const CalendarPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Kalender belum dapat dimuat. Data kesehatanmu tetap aman di perangkat.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('private database detail'), findsNothing);
  });

  testWidgets('period edit form shows dates and independent flow controls',
      (tester) async {
    _useTallViewport(tester);
    final formRecord = PeriodRecord(
      id: 'period-form',
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 8, 3),
      periodDurationDays: 3,
      cycleLengthDays: 29,
      createdAt: DateTime(2026, 8, 1),
      updatedAt: DateTime(2026, 8, 3),
      syncStatus: SyncStatus.synced,
    );
    final formLogs = [
      PeriodDayLogRecord(
        id: 'form-flow-1',
        periodEntryId: formRecord.id,
        logDate: DateTime(2026, 8, 1),
        flow: MenstrualFlow.light.value,
        createdAt: DateTime(2026, 8, 1),
        updatedAt: DateTime(2026, 8, 1),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          flowLogsProvider.overrideWith((ref) => Stream.value(formLogs)),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.light(),
          home: PeriodFormPage(record: formRecord),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Perbarui period'), findsOneWidget);
    expect(find.text('1 Agustus 2026'), findsWidgets);
    expect(find.text('3 Agustus 2026'), findsWidgets);
    expect(find.text('Flow harian'), findsOneWidget);
    expect(find.text('Bercak'), findsNWidgets(3));
    expect(find.text('Ringan'), findsNWidgets(3));
    expect(find.text('Simpan perubahan'), findsOneWidget);
    expect(find.textContaining('data pribadi akunmu'), findsOneWidget);
  });

  testWidgets('new period form supports an ongoing record and flow draft',
      (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          flowLogsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.light(),
          home: const PeriodFormPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Catat period'), findsOneWidget);
    expect(find.text('Masih berlangsung'), findsOneWidget);
    expect(find.text('4 Agustus 2026'), findsWidgets);
    expect(find.text('Simpan catatan'), findsOneWidget);
  });

  testWidgets('summary separates recorded facts from calculated insight',
      (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          endOfCycleSummaryProvider('summary-period')
              .overrideWith((ref) async => summary),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.light(),
          home: const SummaryPage(periodId: 'summary-period'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tercatat'), findsOneWidget);
    expect(find.text('3 hari'), findsOneWidget);
    expect(find.text('1\u20133 Agustus 2026'), findsOneWidget);
    expect(find.text('Aliran darah'), findsOneWidget);
    expect(find.text('Sedikit kram di hari pertama.'), findsOneWidget);
    expect(find.text('Wawasan'), findsOneWidget);
    expect(find.text('Edit data'), findsOneWidget);
    expect(find.text('Arsipkan catatan'), findsOneWidget);
  });

  testWidgets('summary uses safe loading, not-found, and error states',
      (tester) async {
    final completer = Completer<EndOfCycleSummary?>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          endOfCycleSummaryProvider('missing-period')
              .overrideWith((ref) => completer.future),
        ],
        child: const MaterialApp(
          home: SummaryPage(periodId: 'missing-period'),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Menyiapkan ringkasan siklusmu...'), findsOneWidget);

    completer.complete(null);
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan tidak ditemukan'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          endOfCycleSummaryProvider('error-period').overrideWith(
            (ref) async => throw Exception('private database detail'),
          ),
        ],
        child: const MaterialApp(
          home: SummaryPage(periodId: 'error-period'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Ringkasan belum dapat dimuat. Data kesehatanmu tetap aman di perangkat.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('private database detail'), findsNothing);
  });

  testWidgets('phase three screens render on narrow dark layouts',
      (tester) async {
    _useViewport(tester, const Size(320, 1800));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          endOfCycleSummaryProvider('summary-period')
              .overrideWith((ref) async => summary),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.dark(),
          home: const SummaryPage(periodId: 'summary-period'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan siklus'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(SummaryPage))).brightness,
      Brightness.dark,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cycleStatisticsProvider.overrideWith((ref) async => statistics),
        ],
        child: MaterialApp(
          theme: CycleCareTheme.dark(),
          home: const StatisticsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Statistik pribadi'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(StatisticsPage))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('statistics displays calculated values and methodology',
      (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cycleStatisticsProvider.overrideWith((ref) async => statistics),
        ],
        child: const MaterialApp(home: StatisticsPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Berdasarkan 3 siklus terakhir'), findsOneWidget);
    expect(find.text('Cukup konsisten'), findsOneWidget);
    expect(find.text('28.0 hari'), findsWidgets);
    expect(find.text('Riwayat panjang siklus'), findsOneWidget);
    expect(find.text('Intensitas aliran'), findsOneWidget);
    expect(find.textContaining('hingga 12 period terbaru'), findsOneWidget);
  });

  testWidgets('statistics explains when cycle samples are insufficient',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cycleStatisticsProvider.overrideWith(
            (ref) async => const CycleStatistics.empty(),
          ),
        ],
        child: const MaterialApp(home: StatisticsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Data belum cukup'), findsOneWidget);
    expect(find.textContaining('setidaknya dua siklus'), findsOneWidget);
  });

  testWidgets('statistics error does not expose backend details',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cycleStatisticsProvider.overrideWith(
            (ref) async => throw Exception('private analytics detail'),
          ),
        ],
        child: const MaterialApp(home: StatisticsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Statistik belum dapat dimuat. Data kesehatanmu tetap aman di perangkat.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('private analytics detail'), findsNothing);
  });
}

void _useTallViewport(WidgetTester tester) {
  _useViewport(tester, const Size(1080, 4000));
}

void _useViewport(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}
