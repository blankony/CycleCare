import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  PeriodEntries,
  Predictions,
  PeriodDayLogs,
  UserCycleSettings,
  AppSettings,
  SyncQueue,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  factory AppDatabase.memory() => AppDatabase(NativeDatabase.memory());

  static Future<AppDatabase> open() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'cycle_care.sqlite'));
    return AppDatabase(NativeDatabase(file));
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await customStatement(
              'CREATE INDEX IF NOT EXISTS period_start_date_idx ON period_entries(start_date)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS period_updated_at_idx ON period_entries(updated_at)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS period_deleted_at_idx ON period_entries(deleted_at)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS period_sync_status_idx ON period_entries(sync_status)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS period_user_updated_idx ON period_entries(user_id, updated_at)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS period_day_logs_period_idx ON period_day_logs(period_entry_id)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS period_day_logs_date_idx ON period_day_logs(log_date)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS period_day_logs_sync_idx ON period_day_logs(user_id, updated_at)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS user_cycle_settings_sync_idx ON user_cycle_settings(user_id, updated_at)');
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(periodEntries, periodEntries.userId);
            await m.addColumn(periodEntries, periodEntries.version);
            await m.addColumn(
                periodEntries, periodEntries.predictionConfidenceAtEntry);
            await m.addColumn(
                periodEntries, periodEntries.predictionModelVersionAtEntry);
            await m.addColumn(
                periodEntries, periodEntries.predictionSampleSizeAtEntry);
            await m.addColumn(
                periodEntries, periodEntries.predictionSnapshotAt);
            await m.addColumn(predictions, predictions.userId);
            await m.addColumn(syncQueue, syncQueue.userId);
            await m.addColumn(syncQueue, syncQueue.version);
            await m.createTable(periodDayLogs);
            await m.createTable(userCycleSettings);
            await customStatement(
                'CREATE INDEX IF NOT EXISTS period_user_updated_idx ON period_entries(user_id, updated_at)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS period_day_logs_period_idx ON period_day_logs(period_entry_id)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS period_day_logs_date_idx ON period_day_logs(log_date)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS period_day_logs_sync_idx ON period_day_logs(user_id, updated_at)');
            await customStatement(
                'CREATE INDEX IF NOT EXISTS user_cycle_settings_sync_idx ON user_cycle_settings(user_id, updated_at)');
          }
        },
      );

  Future<void> deleteAllLocalData() async {
    await transaction(() async {
      await delete(periodEntries).go();
      await delete(predictions).go();
      await delete(periodDayLogs).go();
      await delete(userCycleSettings).go();
      await delete(appSettings).go();
      await delete(syncQueue).go();
    });
  }

  Future<bool> hasUnassignedLocalData() async {
    final period = await (select(periodEntries)
          ..where((table) => table.userId.isNull()))
        .getSingleOrNull();
    if (period != null) return true;
    final dayLog = await (select(periodDayLogs)
          ..where((table) => table.userId.isNull()))
        .getSingleOrNull();
    if (dayLog != null) return true;
    final prediction = await (select(predictions)
          ..where((table) => table.userId.isNull()))
        .getSingleOrNull();
    return prediction != null;
  }

  Future<void> claimUnassignedLocalData(String userId) async {
    await transaction(() async {
      await (update(periodEntries)..where((table) => table.userId.isNull()))
          .write(PeriodEntriesCompanion(
        userId: Value(userId),
        syncStatus: const Value('pending'),
      ));
      await (update(periodDayLogs)..where((table) => table.userId.isNull()))
          .write(PeriodDayLogsCompanion(
        userId: Value(userId),
        syncStatus: const Value('pending'),
      ));
      await (update(predictions)..where((table) => table.userId.isNull()))
          .write(PredictionsCompanion(userId: Value(userId)));
      await (update(syncQueue)..where((table) => table.userId.isNull()))
          .write(SyncQueueCompanion(userId: Value(userId)));
    });
  }

  Future<void> discardUnassignedLocalData() async {
    await transaction(() async {
      final unassignedPeriodIds = await (selectOnly(periodEntries)
            ..addColumns([periodEntries.id])
            ..where(periodEntries.userId.isNull()))
          .map((row) => row.read(periodEntries.id)!)
          .get();
      if (unassignedPeriodIds.isNotEmpty) {
        await (delete(periodDayLogs)
              ..where((table) => table.periodEntryId.isIn(unassignedPeriodIds)))
            .go();
      }
      await (delete(periodEntries)..where((table) => table.userId.isNull()))
          .go();
      await (delete(periodDayLogs)..where((table) => table.userId.isNull()))
          .go();
      await (delete(predictions)..where((table) => table.userId.isNull())).go();
      await (delete(syncQueue)..where((table) => table.userId.isNull())).go();
    });
  }

  Future<void> deleteUserLocalData(String userId) async {
    await transaction(() async {
      await (delete(periodDayLogs)
            ..where((table) => table.userId.equals(userId)))
          .go();
      await (delete(periodEntries)
            ..where((table) => table.userId.equals(userId)))
          .go();
      await (delete(predictions)..where((table) => table.userId.equals(userId)))
          .go();
      await (delete(userCycleSettings)
            ..where((table) => table.userId.equals(userId)))
          .go();
      await (delete(syncQueue)..where((table) => table.userId.equals(userId)))
          .go();
    });
  }

  Future<bool> hasCompletedInitialSync(String userId) async {
    final rows = await customSelect(
      'SELECT initial_sync_completed FROM user_cycle_settings WHERE user_id = ?',
      variables: [Variable.withString(userId)],
    ).get();
    return rows.isNotEmpty && rows.first.read<bool>('initial_sync_completed');
  }

  Future<String?> lastSuccessfulSyncAt(String userId) async {
    final rows = await customSelect(
      'SELECT last_successful_sync_at FROM user_cycle_settings WHERE user_id = ?',
      variables: [Variable.withString(userId)],
    ).get();
    return rows.isEmpty
        ? null
        : rows.first.readNullable<String>('last_successful_sync_at');
  }

  Future<void> markInitialSyncCompleted(String userId, String timestamp) async {
    await customStatement(
      '''INSERT INTO user_cycle_settings
          (user_id, initial_sync_completed, last_successful_sync_at, updated_at,
           sync_status, version)
        VALUES (?, 1, ?, ?, 'synced', 1)
        ON CONFLICT(user_id) DO UPDATE SET
          initial_sync_completed = 1,
          last_successful_sync_at = excluded.last_successful_sync_at,
          updated_at = excluded.updated_at,
          sync_status = 'synced',
          version = user_cycle_settings.version + 1''',
      [userId, timestamp, timestamp],
    );
  }

  Future<void> updateLastSuccessfulSync(String userId, String timestamp) async {
    await customStatement(
      '''INSERT INTO user_cycle_settings
          (user_id, last_successful_sync_at, updated_at, sync_status, version)
        VALUES (?, ?, ?, 'synced', 1)
        ON CONFLICT(user_id) DO UPDATE SET
          last_successful_sync_at = excluded.last_successful_sync_at,
          updated_at = excluded.updated_at,
          sync_status = 'synced',
          version = user_cycle_settings.version + 1''',
      [userId, timestamp, timestamp],
    );
  }

  Future<int> pendingSyncCount(String userId) async =>
      (select(syncQueue)..where((table) => table.userId.equals(userId)))
          .get()
          .then((rows) => rows.length);

  Future<void> putPrediction({
    required String predictedStart,
    required String windowStart,
    required String windowEnd,
    required int baselineCycleDays,
    required int variabilityDays,
    required String confidence,
    required int basedOnCycles,
    required String modelVersion,
  }) async {
    await transaction(() async {
      await delete(predictions).go();
      await into(predictions).insert(
        PredictionsCompanion.insert(
          id: const Uuid().v4(),
          generatedAt: DateTime.now().toUtc().toIso8601String(),
          predictedStart: predictedStart,
          windowStart: windowStart,
          windowEnd: windowEnd,
          baselineCycleDays: baselineCycleDays,
          variabilityDays: variabilityDays,
          confidence: confidence,
          basedOnCycles: basedOnCycles,
          modelVersion: modelVersion,
        ),
      );
    });
  }
}

LazyDatabase openDatabase() => LazyDatabase(() async {
      final directory = await getApplicationSupportDirectory();
      final file = File(p.join(directory.path, 'cycle_care.sqlite'));
      return NativeDatabase(file);
    });
