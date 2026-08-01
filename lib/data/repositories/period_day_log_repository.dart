import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../../core/date/date_only.dart';
import '../../core/errors/app_failure.dart';
import '../../domain/entities/period_day_log.dart';

abstract interface class PeriodDayLogRepository {
  Stream<List<PeriodDayLogRecord>> watchAll();
  Future<List<PeriodDayLogRecord>> getAll();
  Future<List<PeriodDayLogRecord>> getForPeriod(String periodEntryId);
  Future<List<PeriodDayLogRecord>> getOutsideRange({
    required String periodEntryId,
    required DateTime startDate,
    required DateTime? endDate,
  });
  Future<void> save({
    required String periodEntryId,
    required DateTime logDate,
    required String flow,
  });
  Future<void> softDelete(String id);
  Future<void> softDeleteOutsideRange({
    required String periodEntryId,
    required DateTime startDate,
    required DateTime? endDate,
  });
}

class DriftPeriodDayLogRepository implements PeriodDayLogRepository {
  DriftPeriodDayLogRepository(this.database, {required this.userId});

  final AppDatabase database;
  final String userId;

  @override
  Stream<List<PeriodDayLogRecord>> watchAll() =>
      (database.select(database.periodDayLogs)
            ..where((table) => table.userId.equals(userId))
            ..where((table) => table.deletedAt.isNull())
            ..orderBy([(table) => OrderingTerm.asc(table.logDate)]))
          .watch()
          .map((rows) => rows.map(_fromRow).toList());

  @override
  Future<List<PeriodDayLogRecord>> getAll() async =>
      (database.select(database.periodDayLogs)
            ..where((table) => table.userId.equals(userId))
            ..where((table) => table.deletedAt.isNull())
            ..orderBy([(table) => OrderingTerm.asc(table.logDate)]))
          .get()
          .then((rows) => rows.map(_fromRow).toList());

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
    final period = await (database.select(database.periodEntries)
          ..where((table) => table.id.equals(periodEntryId))
          ..where((table) => table.userId.equals(userId))
          ..where((table) => table.deletedAt.isNull()))
        .getSingleOrNull();
    if (period == null) {
      throw const ValidationFailure('Catatan period tidak ditemukan.');
    }
    final normalizedDate = DateOnly.normalize(logDate);
    final startDate = DateOnly.parse(period.startDate);
    final endDate = period.endDate == null
        ? DateOnly.normalize(DateTime.now())
        : DateOnly.parse(period.endDate!);
    if (normalizedDate.isBefore(startDate) || normalizedDate.isAfter(endDate)) {
      throw const ValidationFailure(
          'Tanggal flow harus berada dalam rentang period.');
    }
    final normalized = DateOnly.format(normalizedDate);
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
  Future<List<PeriodDayLogRecord>> getOutsideRange({
    required String periodEntryId,
    required DateTime startDate,
    required DateTime? endDate,
  }) async {
    final logs = await getForPeriod(periodEntryId);
    final start = DateOnly.normalize(startDate);
    final end = DateOnly.normalize(endDate ?? DateTime.now());
    return logs
        .where((log) => log.logDate.isBefore(start) || log.logDate.isAfter(end))
        .toList();
  }

  @override
  Future<void> softDeleteOutsideRange({
    required String periodEntryId,
    required DateTime startDate,
    required DateTime? endDate,
  }) async {
    final outside = await getOutsideRange(
      periodEntryId: periodEntryId,
      startDate: startDate,
      endDate: endDate,
    );
    for (final log in outside) {
      await softDelete(log.id);
    }
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
        deletedAt:
            row.deletedAt == null ? null : DateTime.parse(row.deletedAt!),
      );
}
