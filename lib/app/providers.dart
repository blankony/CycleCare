import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_session_controller.dart';
import '../data/local/database.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/period_repository.dart';
import '../domain/entities/enums.dart';
import '../domain/entities/period_record.dart';
import '../domain/entities/prediction.dart';
import '../domain/services/backup_service.dart';
import '../domain/services/account_deletion_service.dart';
import '../domain/services/biometric_security_service.dart';
import '../domain/services/classification_service.dart';
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
final backupServiceProvider = Provider<BackupService>(
    (ref) => BackupService(ref.watch(databaseProvider)));
final accountDeletionServiceProvider = Provider<AccountDeletionService>((ref) {
  return AccountDeletionService(
    ref.watch(supabaseClientProvider),
    ref.watch(databaseProvider),
    ref.watch(notificationServiceProvider),
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

final predictionServiceProvider = Provider<PredictionService>((ref) {
  return const PredictionService();
});

final classificationServiceProvider = Provider<ClassificationService>((ref) {
  return const ClassificationService();
});

final recalculationServiceProvider = Provider<PeriodRecalculationService>((ref) {
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
    ..where((table) => userId == null
        ? const Constant(true)
        : table.userId.equals(userId));
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

final settingsProvider = StreamProvider<Map<String, String?>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.appSettings).watch().map(
        (rows) => {for (final row in rows) row.key: row.value},
      );
});

final periodActionsProvider =
    AsyncNotifierProvider<PeriodActionsController, void>(
        PeriodActionsController.new);
