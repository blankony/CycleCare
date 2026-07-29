import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/date/date_only.dart';
import '../../data/local/database.dart';

class SyncResult {
  const SyncResult(
      {required this.synced, required this.failed, required this.skipped});

  final int synced;
  final int failed;
  final bool skipped;
}

abstract interface class SyncRepository {
  Future<SyncResult> synchronize();
}

class LocalSyncRepository implements SyncRepository {
  const LocalSyncRepository();

  @override
  Future<SyncResult> synchronize() async =>
      const SyncResult(synced: 0, failed: 0, skipped: true);
}

class SupabaseSyncRepository implements SyncRepository {
  SupabaseSyncRepository(this.database, this.client);

  final AppDatabase database;
  final SupabaseClient client;

  @override
  Future<SyncResult> synchronize() async {
    final user = client.auth.currentUser;
    if (user == null) {
      return const SyncResult(synced: 0, failed: 0, skipped: true);
    }
    final queue = await (database.select(database.syncQueue)
          ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
        .get();
    var synced = 0;
    var failed = 0;
    for (final item in queue) {
      try {
        final payload = jsonDecode(item.payload) as Map<String, dynamic>;
        payload['user_id'] = user.id;
        if (item.operation == 'delete') {
          payload['deleted_at'] ??= DateTime.now().toUtc().toIso8601String();
        }
        await client.from('period_entries').upsert(payload);
        await (database.delete(database.syncQueue)
              ..where((table) => table.id.equals(item.id)))
            .go();
        await (database.update(database.periodEntries)
              ..where((table) => table.id.equals(item.entityId)))
            .write(
          const PeriodEntriesCompanion(syncStatus: Value('synced')),
        );
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
    await _pullRemote(user.id);
    return SyncResult(synced: synced, failed: failed, skipped: false);
  }

  String _shortError(Object error) {
    final message = error.toString();
    return message.length > 500 ? message.substring(0, 500) : message;
  }

  Future<void> _pullRemote(String userId) async {
    final rows =
        await client.from('period_entries').select().eq('user_id', userId);
    for (final row in rows) {
      final remote = row;
      final id = remote['id'] as String;
      final local = await (database.select(database.periodEntries)
            ..where((table) => table.id.equals(id)))
          .getSingleOrNull();
      final remoteUpdated = DateTime.parse(remote['updated_at'] as String);
      if (local != null &&
          DateTime.parse(local.updatedAt).isAfter(remoteUpdated)) {
        continue;
      }
      await database.into(database.periodEntries).insertOnConflictUpdate(
            PeriodEntriesCompanion.insert(
              id: id,
              startDate: DateOnly.format(
                  DateTime.parse(remote['start_date'] as String)),
              endDate: Value(remote['end_date'] as String?),
              cycleLengthDays: Value(remote['cycle_length_days'] as int?),
              periodDurationDays: Value(remote['period_duration_days'] as int?),
              predictedStartAtEntry:
                  Value(remote['predicted_start_at_entry'] as String?),
              windowStartAtEntry:
                  Value(remote['window_start_at_entry'] as String?),
              windowEndAtEntry: Value(remote['window_end_at_entry'] as String?),
              varianceDays: Value(remote['variance_days'] as int?),
              classification: Value(remote['classification'] as String?),
              notes: Value(remote['notes'] as String?),
              createdAt: remote['created_at'] as String,
              updatedAt: remote['updated_at'] as String,
              deletedAt: Value(remote['deleted_at'] as String?),
              syncStatus: const Value('synced'),
              remoteUpdatedAt: Value(remote['updated_at'] as String?),
            ),
          );
    }
  }
}
