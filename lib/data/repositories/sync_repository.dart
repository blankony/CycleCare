import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../local/database.dart';

class SyncResult {
  const SyncResult({required this.synced, required this.failed});

  final int synced;
  final int failed;
}

class SyncAuthenticationException implements Exception {
  const SyncAuthenticationException();
}

abstract interface class SyncRepository {
  Future<SyncResult> synchronize();
}

abstract interface class SyncRemoteDataSource {
  String? get currentUserId;
  Future<void> upsert(String table, Map<String, dynamic> payload);
  Future<List<Map<String, dynamic>>> selectOwned(String table, String userId);
  Future<Map<String, dynamic>?> selectOwnedSingle(String table, String userId);
}

class SupabaseSyncRemoteDataSource implements SyncRemoteDataSource {
  const SupabaseSyncRemoteDataSource(this.client);

  final SupabaseClient client;

  @override
  String? get currentUserId => client.auth.currentUser?.id;

  @override
  Future<void> upsert(String table, Map<String, dynamic> payload) async {
    await client.from(table).upsert(payload);
  }

  @override
  Future<List<Map<String, dynamic>>> selectOwned(
      String table, String userId) async {
    final rows = await client.from(table).select().eq('user_id', userId);
    return rows.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>?> selectOwnedSingle(
      String table, String userId) async {
    return client.from(table).select().eq('user_id', userId).maybeSingle();
  }
}

class SupabaseSyncRepository implements SyncRepository {
  SupabaseSyncRepository(AppDatabase database, SupabaseClient client)
      : this.withRemote(database, SupabaseSyncRemoteDataSource(client));

  SupabaseSyncRepository.withRemote(this.database, this.remote);

  final AppDatabase database;
  final SyncRemoteDataSource remote;

  @override
  Future<SyncResult> synchronize() async {
    final userId = remote.currentUserId;
    if (userId == null) throw const SyncAuthenticationException();

    final queue = await (database.select(database.syncQueue)
          ..where((table) => table.userId.equals(userId))
          ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
        .get();
    final latestByEntity = <String, SyncQueueData>{};
    for (final item in queue) {
      latestByEntity[item.entityType + item.entityId] = item;
    }

    var synced = 0;
    var failed = 0;
    for (final item in latestByEntity.values) {
      try {
        await _pushItem(item, userId);
        await (database.delete(database.syncQueue)
              ..where((table) => table.userId.equals(userId))
              ..where((table) => table.entityType.equals(item.entityType))
              ..where((table) => table.entityId.equals(item.entityId)))
            .go();
        await _markLocalSynced(item);
        synced++;
      } catch (error) {
        failed++;
        await (database.update(database.syncQueue)
              ..where((table) => table.id.equals(item.id)))
            .write(
          SyncQueueCompanion(
            attemptCount: Value(item.attemptCount + 1),
            lastError: Value(_shortError(error)),
            updatedAt: Value(DateTime.now().toUtc().toIso8601String()),
          ),
        );
      }
    }

    await _pullPeriods(userId);
    await _pullDayLogs(userId);
    await _pullSettings(userId);
    return SyncResult(synced: synced, failed: failed);
  }

  Future<void> _pushItem(SyncQueueData item, String userId) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    payload['user_id'] = userId;
    if (item.operation == 'delete') {
      payload['deleted_at'] ??= DateTime.now().toUtc().toIso8601String();
    }
    final table = switch (item.entityType) {
      'period_entry' => 'period_entries',
      'period_day_log' => 'period_day_logs',
      'user_cycle_settings' => 'user_cycle_settings',
      _ => throw StateError('Tipe sinkronisasi tidak dikenal.'),
    };
    await remote.upsert(table, payload);
  }

  Future<void> _pullPeriods(String userId) async {
    final rows = await remote.selectOwned('period_entries', userId);
    for (final row in rows) {
      if (await _hasPending(userId, 'period_entry', row['id'] as String)) {
        continue;
      }
      final remoteUpdated = DateTime.parse(row['updated_at'] as String);
      final local = await (database.select(database.periodEntries)
            ..where((table) => table.id.equals(row['id'] as String))
            ..where((table) => table.userId.equals(userId)))
          .getSingleOrNull();
      if (local != null &&
          !remoteUpdated.isAfter(DateTime.parse(local.updatedAt))) {
        continue;
      }
      await database.into(database.periodEntries).insertOnConflictUpdate(
            PeriodEntriesCompanion.insert(
              id: row['id'] as String,
              userId: Value(userId),
              startDate: row['start_date'] as String,
              endDate: Value(row['end_date'] as String?),
              cycleLengthDays: Value(row['cycle_length_days'] as int?),
              periodDurationDays: Value(row['period_duration_days'] as int?),
              predictedStartAtEntry:
                  Value(row['predicted_start_at_entry'] as String?),
              windowStartAtEntry:
                  Value(row['window_start_at_entry'] as String?),
              windowEndAtEntry: Value(row['window_end_at_entry'] as String?),
              varianceDays: Value(row['variance_days'] as int?),
              classification: Value(row['classification'] as String?),
              notes: Value(row['notes'] as String?),
              createdAt: row['created_at'] as String,
              updatedAt: row['updated_at'] as String,
              deletedAt: Value(row['deleted_at'] as String?),
              syncStatus: const Value('synced'),
              remoteUpdatedAt: Value(row['updated_at'] as String?),
              version: Value(row['version'] as int? ?? 1),
              predictionConfidenceAtEntry:
                  Value(row['prediction_confidence_at_entry'] as String?),
              predictionModelVersionAtEntry:
                  Value(row['prediction_model_version_at_entry'] as String?),
              predictionSampleSizeAtEntry:
                  Value(row['prediction_sample_size_at_entry'] as int?),
              predictionSnapshotAt:
                  Value(row['prediction_snapshot_at'] as String?),
            ),
          );
    }
  }

  Future<void> _pullDayLogs(String userId) async {
    final rows = await remote.selectOwned('period_day_logs', userId);
    for (final row in rows) {
      final id = row['id'] as String;
      if (await _hasPending(userId, 'period_day_log', id)) continue;
      final remoteUpdated = DateTime.parse(row['updated_at'] as String);
      final local = await (database.select(database.periodDayLogs)
            ..where((table) => table.id.equals(id))
            ..where((table) => table.userId.equals(userId)))
          .getSingleOrNull();
      if (local != null &&
          !remoteUpdated.isAfter(DateTime.parse(local.updatedAt))) {
        continue;
      }
      await database.into(database.periodDayLogs).insertOnConflictUpdate(
            PeriodDayLogsCompanion.insert(
              id: id,
              userId: Value(userId),
              periodEntryId: row['period_entry_id'] as String,
              logDate: row['log_date'] as String,
              flow: row['flow'] as String,
              createdAt: row['created_at'] as String,
              updatedAt: row['updated_at'] as String,
              deletedAt: Value(row['deleted_at'] as String?),
              syncStatus: const Value('synced'),
              remoteUpdatedAt: Value(row['updated_at'] as String?),
              version: Value(row['version'] as int? ?? 1),
            ),
          );
    }
  }

  Future<void> _pullSettings(String userId) async {
    final row = await remote.selectOwnedSingle('user_cycle_settings', userId);
    if (row == null ||
        await _hasPending(userId, 'user_cycle_settings', userId)) {
      return;
    }
    final remoteUpdated = DateTime.parse(row['updated_at'] as String);
    final local = await (database.select(database.userCycleSettings)
          ..where((table) => table.userId.equals(userId)))
        .getSingleOrNull();
    if (local != null &&
        !remoteUpdated.isAfter(DateTime.parse(local.updatedAt))) {
      return;
    }
    await database.into(database.userCycleSettings).insertOnConflictUpdate(
          UserCycleSettingsCompanion.insert(
            userId: userId,
            showOvulationEstimate:
                Value(row['show_ovulation_estimate'] as bool? ?? false),
            showFertileWindow:
                Value(row['show_fertile_window'] as bool? ?? false),
            reminderEnabled: Value(row['reminder_enabled'] as bool? ?? false),
            lastSummaryPeriodId:
                Value(row['last_summary_period_id'] as String?),
            lastSuccessfulSyncAt:
                Value(row['last_successful_sync_at'] as String?),
            initialSyncCompleted:
                Value(row['initial_sync_completed'] as bool? ?? false),
            updatedAt: row['updated_at'] as String,
            remoteUpdatedAt: Value(row['updated_at'] as String?),
            syncStatus: const Value('synced'),
            version: Value(row['version'] as int? ?? 1),
          ),
        );
  }

  Future<bool> _hasPending(
      String userId, String entityType, String entityId) async {
    final item = await (database.select(database.syncQueue)
          ..where((table) => table.userId.equals(userId))
          ..where((table) => table.entityType.equals(entityType))
          ..where((table) => table.entityId.equals(entityId)))
        .getSingleOrNull();
    return item != null;
  }

  Future<void> _markLocalSynced(SyncQueueData item) async {
    switch (item.entityType) {
      case 'period_entry':
        await (database.update(database.periodEntries)
              ..where((table) => table.id.equals(item.entityId)))
            .write(const PeriodEntriesCompanion(
          syncStatus: Value('synced'),
        ));
      case 'period_day_log':
        await (database.update(database.periodDayLogs)
              ..where((table) => table.id.equals(item.entityId)))
            .write(const PeriodDayLogsCompanion(
          syncStatus: Value('synced'),
        ));
      case 'user_cycle_settings':
        await (database.update(database.userCycleSettings)
              ..where((table) => table.userId.equals(item.entityId)))
            .write(const UserCycleSettingsCompanion(
          syncStatus: Value('synced'),
        ));
    }
  }

  String _shortError(Object error) {
    final message = error.toString();
    return message.length > 500 ? message.substring(0, 500) : message;
  }
}
