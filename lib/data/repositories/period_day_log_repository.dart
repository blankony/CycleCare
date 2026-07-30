import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../../core/date/date_only.dart';
import '../../core/errors/app_failure.dart';

class PeriodDayLogRecord {
  const PeriodDayLogRecord({
    required this.id,
    required this.periodEntryId,
    required this.logDate,
    required this.flow,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String periodEntryId;
  final DateTime logDate;
  final String flow;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}

abstract interface class PeriodDayLogRepository {
  Future<List<PeriodDayLogRecord>> getForPeriod(String periodEntryId);
  Future<void> save({
    required String periodEntryId,
    required DateTime logDate,
    required String flow,
  });
  Future<void> softDelete(String id);
}

class DriftPeriodDayLogRepository implements PeriodDayLogRepository {
  DriftPeriodDayLogRepository(this.database, {required this.userId});

  final AppDatabase database;
  final String userId;

  @override
  Future<List<PeriodDayLogRecord>> getForPeriod(String periodEntryId) async {
    final rows = await (database.select(database.periodDayLogs)
          ..where((table) => table.userId.equals(userId))
          ..where((table) => table.periodEntryId.equals(periodEntryId))
          ..where((table) => table.deletedAt.isNull())
          ..orderBy([(table) => OrderingTerm.asc(table.logDate)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<void> save({
    required String periodEntryId,
    required DateTime logDate,
    required String flow,
  }) async {
    const allowed = {'SPOTTING', 'LIGHT', 'MEDIUM', 'HEAVY'};
    if (!allowed.contains(flow)) {
      throw const ValidationFailure('Jenis flow tidak dikenal.');
    }
    final normalized = DateOnly.format(logDate);
    final now = DateTime.now().toUtc().toIso8601String();
    final existing = await (database.select(database.periodDayLogs)
          ..where((table) => table.userId.equals(userId))
          ..where((table) => table.periodEntryId.equals(periodEntryId))
          ..where((table) => table.logDate.equals(normalized)))
        .getSingleOrNull();
    await database.transaction(() async {
      final id = existing?.id ?? const Uuid().v4();
      await (database.delete(database.syncQueue)
            ..where((table) => table.userId.equals(userId))
            ..where((table) => table.entityType.equals('period_day_log'))
            ..where((table) => table.entityId.equals(id)))
          .go();
      await database.into(database.periodDayLogs).insertOnConflictUpdate(
            PeriodDayLogsCompanion.insert(
              id: id,
              userId: Value(userId),
              periodEntryId: periodEntryId,
              logDate: normalized,
              flow: flow,
              createdAt: existing?.createdAt ?? now,
              updatedAt: now,
              deletedAt: const Value(null),
              syncStatus: const Value('pending'),
            ),
          );
      await database.into(database.syncQueue).insert(
            SyncQueueCompanion.insert(
              id: const Uuid().v4(),
              userId: Value(userId),
              entityType: 'period_day_log',
              entityId: id,
              operation: 'upsert',
              payload: jsonEncode({
                'id': id,
                'user_id': userId,
                'period_entry_id': periodEntryId,
                'log_date': normalized,
                'flow': flow,
                'created_at': existing?.createdAt ?? now,
                'updated_at': now,
                'deleted_at': null,
                'version': (existing?.version ?? 0) + 1,
              }),
              createdAt: now,
              updatedAt: now,
            ),
          );
    });
  }

  @override
  Future<void> softDelete(String id) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      await (database.delete(database.syncQueue)
            ..where((table) => table.userId.equals(userId))
            ..where((table) => table.entityType.equals('period_day_log'))
            ..where((table) => table.entityId.equals(id)))
          .go();
      await (database.update(database.periodDayLogs)
            ..where((table) => table.id.equals(id))
            ..where((table) => table.userId.equals(userId)))
          .write(PeriodDayLogsCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value('pending'),
      ));
      await database.into(database.syncQueue).insert(
            SyncQueueCompanion.insert(
              id: const Uuid().v4(),
              userId: Value(userId),
              entityType: 'period_day_log',
              entityId: id,
              operation: 'delete',
              payload: jsonEncode({'id': id, 'deleted_at': now}),
              createdAt: now,
              updatedAt: now,
            ),
          );
    });
  }

  PeriodDayLogRecord _fromRow(PeriodDayLog row) => PeriodDayLogRecord(
        id: row.id,
        periodEntryId: row.periodEntryId,
        logDate: DateOnly.parse(row.logDate),
        flow: row.flow,
        createdAt: DateTime.parse(row.createdAt),
        updatedAt: DateTime.parse(row.updatedAt),
        deletedAt: row.deletedAt == null ? null : DateTime.parse(row.deletedAt!),
      );
}
