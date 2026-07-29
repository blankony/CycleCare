import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local/database.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/period_repository.dart';
import '../domain/entities/enums.dart';
import '../domain/entities/period_record.dart';
import '../domain/entities/prediction.dart';
import '../domain/services/backup_service.dart';
import '../domain/services/biometric_security_service.dart';
import '../domain/services/classification_service.dart';
import '../domain/services/local_notification_service.dart';
import '../domain/services/notification_service.dart';
import '../domain/services/period_recalculation_service.dart';
import '../domain/services/prediction_service.dart';
import '../domain/services/security_service.dart';
import '../domain/services/sync_service.dart';
import '../features/period_form/application/period_actions.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('Database provider must be overridden during bootstrap.');
});

final supabaseClientProvider = Provider<SupabaseClient?>((ref) => null);

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
final connectivityStateProvider = StreamProvider<List<ConnectivityResult>>(
    (ref) => Connectivity().onConnectivityChanged);

final authenticationStateProvider = StreamProvider<AuthState?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository == null
      ? Stream.value(null)
      : repository.authStateChanges.map((state) => state);
});

final authRepositoryProvider = Provider<AuthRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : SupabaseAuthRepository(client);
});

final periodRepositoryProvider = Provider<PeriodRepository>((ref) {
  return DriftPeriodRepository(ref.watch(databaseProvider));
});

final predictionServiceProvider = Provider<PredictionService>((ref) {
  return const PredictionService();
});

final classificationServiceProvider = Provider<ClassificationService>((ref) {
  return const ClassificationService();
});

final recalculationServiceProvider =
    Provider<PeriodRecalculationService>((ref) {
  return PeriodRecalculationService(
    ref.watch(databaseProvider),
    ref.watch(predictionServiceProvider),
    ref.watch(classificationServiceProvider),
  );
});

final activePeriodsProvider = StreamProvider<List<PeriodRecord>>((ref) {
  return ref.watch(periodRepositoryProvider).watchActivePeriods();
});

final deletedPeriodsProvider = FutureProvider<List<PeriodRecord>>((ref) {
  return ref.watch(periodRepositoryProvider).getDeletedPeriods();
});

final predictionProvider = StreamProvider<CyclePrediction?>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.predictions).watch().map((rows) {
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

goRouterProvider(Ref ref) => GoRouter(
      initialLocation: '/dashboard',
      routes: const [],
    );
