import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_session_controller.dart';
import '../data/local/database.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/period_repository.dart';
import '../data/repositories/period_day_log_repository.dart';
import '../data/repositories/user_cycle_settings_repository.dart';
import '../domain/entities/cycle_insights.dart';
import '../domain/entities/enums.dart';
import '../domain/entities/period_day_log.dart';
import '../domain/entities/period_record.dart';
import '../domain/entities/prediction.dart';
import '../domain/entities/user_cycle_settings.dart';
import '../domain/services/backup_service.dart';
import '../domain/services/account_deletion_service.dart';
import '../domain/services/biometric_security_service.dart';
import '../domain/services/classification_service.dart';
import '../domain/services/clinical_reference_service.dart';
import '../domain/services/cycle_statistics_service.dart';
import '../domain/services/cycle_status_service.dart';
import '../domain/services/end_of_cycle_summary_service.dart';
import '../domain/services/fertility_estimate_service.dart';
import '../domain/services/future_cycle_projection_service.dart';
import '../domain/services/local_notification_service.dart';
import '../domain/services/notification_service.dart';
import '../domain/services/period_recalculation_service.dart';
import '../domain/services/prediction_service.dart';
import '../domain/services/security_service.dart';
import '../domain/services/sync_controller.dart';
import '../domain/services/sync_service.dart';
import '../features/period_form/application/period_actions.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('Database provider must be overridden during bootstrap.');
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  throw StateError('Supabase provider must be overridden after bootstrap.');
});

final notificationServiceProvider =
    Provider<NotificationService>((ref) => LocalNotificationService());
final securityServiceProvider =
    Provider<SecurityService>((ref) => BiometricSecurityService());
final syncServiceProvider = Provider<SyncService>((ref) => SyncService(
    createSyncRepository(
        database: ref.watch(databaseProvider),
        client: ref.watch(supabaseClientProvider))));
final backupServiceProvider = Provider<BackupService>((ref) => BackupService(
    ref.watch(databaseProvider),
    userId: ref.watch(authSessionProvider).user?.id));
final accountDeletionServiceProvider = Provider<AccountDeletionService>((ref) {
  return AccountDeletionService(
    ref.watch(supabaseClientProvider),
    ref.watch(databaseProvider),
    ref.watch(notificationServiceProvider),
    ref.watch(securityServiceProvider),
  );
});
final connectivityStateProvider = StreamProvider<List<ConnectivityResult>>(
    (ref) => Connectivity().onConnectivityChanged);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository(ref.watch(supabaseClientProvider));
});

final authenticationStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final authSessionProvider =
    ChangeNotifierProvider<AuthSessionController>((ref) {
  final controller = AuthSessionController(ref.watch(authRepositoryProvider));
  ref.onDispose(controller.dispose);
  return controller;
});

final periodRepositoryProvider = Provider<PeriodRepository>((ref) {
  return DriftPeriodRepository(
    ref.watch(databaseProvider),
    userId: ref.watch(authSessionProvider).user?.id,
  );
});

final periodDayLogRepositoryProvider = Provider<PeriodDayLogRepository>((ref) {
  final userId = ref.watch(authSessionProvider).user?.id;
  if (userId == null) throw StateError('Sesi akun diperlukan.');
  return DriftPeriodDayLogRepository(ref.watch(databaseProvider),
      userId: userId);
});

final userCycleSettingsRepositoryProvider =
    Provider<UserCycleSettingsRepository>((ref) {
  final userId = ref.watch(authSessionProvider).user?.id;
  if (userId == null) throw StateError('Sesi akun diperlukan.');
  return DriftUserCycleSettingsRepository(ref.watch(databaseProvider),
      userId: userId);
});

final predictionServiceProvider = Provider<PredictionService>((ref) {
  return const PredictionService();
});

final classificationServiceProvider = Provider<ClassificationService>((ref) {
  return const ClassificationService();
});

final cycleStatusServiceProvider = Provider<CycleStatusService>((ref) {
  return const CycleStatusService();
});

final fertilityEstimateServiceProvider =
    Provider<FertilityEstimateService>((ref) {
  return const FertilityEstimateService();
});

final futureCycleProjectionServiceProvider =
    Provider<FutureCycleProjectionService>((ref) {
  return const FutureCycleProjectionService();
});

final cycleStatisticsServiceProvider = Provider<CycleStatisticsService>((ref) {
  return const CycleStatisticsService();
});

final clinicalReferenceServiceProvider =
    Provider<ClinicalReferenceService>((ref) {
  return const ClinicalReferenceService();
});

final endOfCycleSummaryServiceProvider =
    Provider<EndOfCycleSummaryService>((ref) {
  return EndOfCycleSummaryService(
    ref.watch(cycleStatisticsServiceProvider),
    ref.watch(clinicalReferenceServiceProvider),
  );
});

final recalculationServiceProvider =
    Provider<PeriodRecalculationService>((ref) {
  return PeriodRecalculationService(
    ref.watch(databaseProvider),
    ref.watch(predictionServiceProvider),
    ref.watch(classificationServiceProvider),
    userId: ref.watch(authSessionProvider).user?.id,
  );
});

final syncControllerProvider = ChangeNotifierProvider<SyncController>((ref) {
  final controller = SyncController(
    database: ref.watch(databaseProvider),
    authSession: ref.watch(authSessionProvider),
    syncService: ref.watch(syncServiceProvider),
    recalculationService: ref.watch(recalculationServiceProvider),
  );
  ref.onDispose(controller.dispose);
  return controller;
});

final activePeriodsProvider = StreamProvider<List<PeriodRecord>>((ref) {
  return ref.watch(periodRepositoryProvider).watchActivePeriods();
});

final deletedPeriodsProvider = FutureProvider<List<PeriodRecord>>((ref) {
  return ref.watch(periodRepositoryProvider).getDeletedPeriods();
});

final predictionProvider = StreamProvider<CyclePrediction?>((ref) {
  final database = ref.watch(databaseProvider);
  final userId = ref.watch(authSessionProvider).user?.id;
  final query = database.select(database.predictions)
    ..where((table) =>
        userId == null ? const Constant(true) : table.userId.equals(userId));
  return query.watch().map((rows) {
    if (rows.isEmpty) return null;
    final row = rows.last;
    return CyclePrediction(
      ready: true,
      predictedStart: DateTime.parse(row.predictedStart),
      windowStart: DateTime.parse(row.windowStart),
      windowEnd: DateTime.parse(row.windowEnd),
      baselineCycleDays: row.baselineCycleDays,
      variabilityDays: row.variabilityDays,
      confidence: PredictionConfidenceText.fromValue(row.confidence),
      basedOnCycles: row.basedOnCycles,
      intervals: const [],
      excludedIntervals: const [],
      modelVersion: row.modelVersion,
    );
  });
});

final flowLogsProvider = StreamProvider<List<PeriodDayLogRecord>>((ref) {
  return ref.watch(periodDayLogRepositoryProvider).watchAll();
});

final userCycleSettingsProvider =
    FutureProvider<UserCycleSettingsRecord>((ref) {
  return ref.watch(userCycleSettingsRepositoryProvider).get();
});

final cycleStatisticsProvider = FutureProvider<CycleStatistics>((ref) async {
  final periods = await ref.watch(activePeriodsProvider.future);
  final flowLogs = await ref.watch(flowLogsProvider.future);
  return ref.watch(cycleStatisticsServiceProvider).calculate(
        periods: periods,
        flowLogs: flowLogs,
        today: DateTime.now(),
      );
});

final fertilityEstimateProvider = Provider<FertilityEstimate?>((ref) {
  return ref
      .watch(fertilityEstimateServiceProvider)
      .calculate(ref.watch(predictionProvider).valueOrNull);
});

final projectionsProvider = Provider<List<FutureCycleProjection>>((ref) {
  return ref
      .watch(futureCycleProjectionServiceProvider)
      .project(ref.watch(predictionProvider).valueOrNull);
});

final cycleInsightsProvider = FutureProvider<CycleInsights>((ref) async {
  final periods = await ref.watch(activePeriodsProvider.future);
  final prediction = await ref.watch(predictionProvider.future);
  final statistics = await ref.watch(cycleStatisticsProvider.future);
  return CycleInsights(
    status: ref.watch(cycleStatusServiceProvider).calculate(
          periods: periods,
          today: DateTime.now(),
          prediction: prediction,
        ),
    statistics: statistics,
    prediction: prediction,
    fertility:
        ref.watch(fertilityEstimateServiceProvider).calculate(prediction),
    projections:
        ref.watch(futureCycleProjectionServiceProvider).project(prediction),
  );
});

final endOfCycleSummaryProvider = FutureProvider.family
    .autoDispose<EndOfCycleSummary?, String>((ref, periodId) async {
  final periods = await ref.watch(activePeriodsProvider.future);
  final period = periods.where((item) => item.id == periodId).firstOrNull;
  if (period == null) return null;
  final logs = await ref.watch(flowLogsProvider.future);
  return ref.watch(endOfCycleSummaryServiceProvider).build(
        period: period,
        periods: periods,
        flowLogs: logs,
        today: DateTime.now(),
      );
});

final settingsProvider = StreamProvider<Map<String, String?>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.appSettings).watch().map(
        (rows) => {for (final row in rows) row.key: row.value},
      );
});

final periodActionsProvider =
    AsyncNotifierProvider<PeriodActionsController, void>(
        PeriodActionsController.new);
