import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:cycle_care/app/providers.dart';
import 'package:cycle_care/app/theme.dart';
import 'package:cycle_care/domain/entities/cycle_insights.dart';
import 'package:cycle_care/domain/entities/enums.dart';
import 'package:cycle_care/domain/entities/period_record.dart';
import 'package:cycle_care/domain/entities/prediction.dart';
import 'package:cycle_care/domain/entities/sync_state.dart';
import 'package:cycle_care/domain/entities/user_cycle_settings.dart';
import 'package:cycle_care/features/calendar/presentation/calendar_page.dart';
import 'package:cycle_care/features/dashboard/presentation/dashboard_page.dart';
import 'package:cycle_care/features/statistics/presentation/statistics_page.dart';

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
    final emptySettings = UserCycleSettingsRecord(
      userId: 'user-1',
      showOvulationEstimate: false,
      showFertileWindow: false,
      reminderEnabled: false,
      initialSyncCompleted: true,
      updatedAt: DateTime(2026, 8, 1),
    );
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
          userCycleSettingsProvider.overrideWith((ref) async => emptySettings),
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
    final todayPeriod = period.copyWith(startDate: DateTime(2026, 8, 1));
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
              .overrideWith((ref) => Stream.value([todayPeriod])),
          projectionsProvider.overrideWithValue([projection]),
          userCycleSettingsProvider.overrideWith((ref) async => settings),
        ],
        child: const MaterialApp(home: CalendarPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Rentang perkiraan'), findsOneWidget);
    expect(find.textContaining('Tercatat: period'), findsOneWidget);
    expect(find.textContaining('Pusat perkiraan 1'), findsOneWidget);
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
    expect(find.text('Cukup konsisten'), findsOneWidget);
    expect(find.text('28.0 hari'), findsWidgets);
    expect(find.textContaining('Rentang siklus'), findsOneWidget);
  });
}

void _useTallViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1080, 4000);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}
