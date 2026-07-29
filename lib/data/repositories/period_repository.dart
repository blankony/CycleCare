import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert';

import '../../core/date/date_only.dart';
import '../../core/errors/app_failure.dart';
import '../../data/local/database.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/period_record.dart';

abstract interface class PeriodRepository {
  Stream<List<PeriodRecord>> watchActivePeriods();
  Future<List<PeriodRecord>> getActivePeriods();
  Future<List<PeriodRecord>> getDeletedPeriods();
  Future<PeriodRecord?> getPeriodById(String id);
  Future<PeriodRecord?> getLatestPeriod();
  Future<PeriodRecord?> getActiveUnfinishedPeriod();
  Future<void> createPeriod({required DateTime startDate, String? notes});
  Future<void> updatePeriodEnd({required String id, required DateTime endDate});
  Future<void> updatePeriod({required PeriodRecord record});
  Future<void> softDeletePeriod(String id);
  Future<void> restorePeriod(String id);
}

class DriftPeriodRepository implements PeriodRepository {
  DriftPeriodRepository(this.database);

  final AppDatabase database;

  @override
  Stream<List<PeriodRecord>> watchActivePeriods() =>
      (database.select(database.periodEntries)
            ..where((table) => table.deletedAt.isNull())
            ..orderBy([(table) => OrderingTerm.asc(table.startDate)]))
          .watch()
          .map((rows) => rows.map(_fromRow).toList());

  @override
  Future<List<PeriodRecord>> getActivePeriods() async =>
      (database.select(database.periodEntries)
            ..where((table) => table.deletedAt.isNull())
            ..orderBy([(table) => OrderingTerm.asc(table.startDate)]))
          .get()
          .then((rows) => rows.map(_fromRow).toList());

  @override
  Future<List<PeriodRecord>> getDeletedPeriods() async =>
      (database.select(database.periodEntries)
            ..where((table) => table.deletedAt.isNotNull())
            ..orderBy([(table) => OrderingTerm.desc(table.startDate)]))
          .get()
          .then((rows) => rows.map(_fromRow).toList());

  @override
  Future<PeriodRecord?> getPeriodById(String id) async {
    final row = await (database.select(database.periodEntries)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<PeriodRecord?> getLatestPeriod() async {
    final rows = await getActivePeriods();
    return rows.isEmpty ? null : rows.last;
  }

  @override
  Future<PeriodRecord?> getActiveUnfinishedPeriod() async {
    final rows = await getActivePeriods();
    final unfinished = rows.where((record) => record.endDate == null).toList();
    return unfinished.isEmpty ? null : unfinished.last;
  }

  @override
  Future<void> createPeriod(
      {required DateTime startDate, String? notes}) async {
    final normalized = DateOnly.normalize(startDate);
    final today = DateOnly.normalize(DateTime.now());
    if (normalized.isAfter(today)) {
      throw const ValidationFailure('Tanggal mulai tidak boleh di masa depan.');
    }
    final existing = await (database.select(database.periodEntries)
          ..where(
              (table) => table.startDate.equals(DateOnly.format(normalized)))
          ..where((table) => table.deletedAt.isNull()))
        .getSingleOrNull();
    if (existing != null) {
      throw const ValidationFailure('Tanggal mulai tersebut sudah tercatat.');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    final active = await getActivePeriods();
    final previous = active
        .where((record) => record.startDate.isBefore(normalized))
        .lastOrNull;
    final cycleLength = previous == null
        ? null
        : DateOnly.differenceInDays(normalized, previous.startDate);
    await database.transaction(() async {
      final id = const Uuid().v4();
      await database.into(database.periodEntries).insert(
            PeriodEntriesCompanion.insert(
              id: id,
              startDate: DateOnly.format(normalized),
              cycleLengthDays: Value(cycleLength),
              notes: Value(_cleanNotes(notes)),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _queue(id, SyncOperation.upsert, now);
    });
  }

  @override
  Future<void> updatePeriodEnd(
      {required String id, required DateTime endDate}) async {
    final record = await getPeriodById(id);
    if (record == null) {
      throw const ValidationFailure('Catatan period tidak ditemukan.');
    }
    final normalized = DateOnly.normalize(endDate);
    if (normalized.isBefore(record.startDate)) {
      throw const ValidationFailure(
          'Tanggal selesai tidak boleh sebelum tanggal mulai.');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      await (database.update(database.periodEntries)
            ..where((table) => table.id.equals(id)))
          .write(
        PeriodEntriesCompanion(
          endDate: Value(DateOnly.format(normalized)),
          periodDurationDays: Value(
              DateOnly.differenceInDays(normalized, record.startDate) + 1),
          updatedAt: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _queue(id, SyncOperation.upsert, now);
    });
  }

  @override
  Future<void> updatePeriod({required PeriodRecord record}) async {
    final normalizedStart = DateOnly.normalize(record.startDate);
    final today = DateOnly.normalize(DateTime.now());
    if (normalizedStart.isAfter(today)) {
      throw const ValidationFailure('Tanggal mulai tidak boleh di masa depan.');
    }
    if (record.endDate != null && record.endDate!.isBefore(normalizedStart)) {
      throw const ValidationFailure(
          'Tanggal selesai tidak boleh sebelum tanggal mulai.');
    }
    final duplicate = await (database.select(database.periodEntries)
          ..where((table) =>
              table.startDate.equals(DateOnly.format(normalizedStart)))
          ..where((table) => table.id.isNotIn([record.id]))
          ..where((table) => table.deletedAt.isNull()))
        .getSingleOrNull();
    if (duplicate != null) {
      throw const ValidationFailure('Tanggal mulai tersebut sudah tercatat.');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    final duration = record.endDate == null
        ? null
        : DateOnly.differenceInDays(record.endDate!, normalizedStart) + 1;
    final active = await getActivePeriods();
    final previous = active
        .where((item) =>
            item.id != record.id && item.startDate.isBefore(normalizedStart))
        .lastOrNull;
    final cycleLength = previous == null
        ? null
        : DateOnly.differenceInDays(normalizedStart, previous.startDate);
    await database.transaction(() async {
      await (database.update(database.periodEntries)
            ..where((table) => table.id.equals(record.id)))
          .write(
        PeriodEntriesCompanion(
          startDate: Value(DateOnly.format(normalizedStart)),
          endDate: Value(
              record.endDate == null ? null : DateOnly.format(record.endDate!)),
          cycleLengthDays: Value(cycleLength),
          periodDurationDays: Value(duration),
          notes: Value(_cleanNotes(record.notes)),
          updatedAt: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _queue(record.id, SyncOperation.upsert, now);
    });
  }

  @override
  Future<void> softDeletePeriod(String id) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      await (database.update(database.periodEntries)
            ..where((table) => table.id.equals(id)))
          .write(
        PeriodEntriesCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _queue(id, SyncOperation.delete, now);
    });
  }

  @override
  Future<void> restorePeriod(String id) async {
    final record = await getPeriodById(id);
    if (record == null) {
      throw const ValidationFailure('Catatan period tidak ditemukan.');
    }
    final duplicate = await (database.select(database.periodEntries)
          ..where((table) =>
              table.startDate.equals(DateOnly.format(record.startDate)))
          ..where((table) => table.id.isNotIn([id]))
          ..where((table) => table.deletedAt.isNull()))
        .getSingleOrNull();
    if (duplicate != null) {
      throw const ValidationFailure('Tanggal mulai tersebut sudah tercatat.');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      await (database.update(database.periodEntries)
            ..where((table) => table.id.equals(id)))
          .write(
        const PeriodEntriesCompanion(
          deletedAt: Value(null),
          syncStatus: Value('pending'),
        ).copyWith(updatedAt: Value(now)),
      );
      await _queue(id, SyncOperation.upsert, now);
    });
  }

  Future<void> _queue(
      String entityId, SyncOperation operation, String now) async {
    final record = await getPeriodById(entityId);
    final payload = record == null ? '{}' : jsonEncode(_toJson(record));
    await database.into(database.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: const Uuid().v4(),
            entityType: 'period_entry',
            entityId: entityId,
            operation: operation.name,
            payload: payload,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  PeriodRecord _fromRow(PeriodEntry row) => PeriodRecord(
        id: row.id,
        startDate: DateOnly.parse(row.startDate),
        endDate: row.endDate == null ? null : DateOnly.parse(row.endDate!),
        cycleLengthDays: row.cycleLengthDays,
        periodDurationDays: row.periodDurationDays,
        predictedStartAtEntry: _parseDate(row.predictedStartAtEntry),
        windowStartAtEntry: _parseDate(row.windowStartAtEntry),
        windowEndAtEntry: _parseDate(row.windowEndAtEntry),
        varianceDays: row.varianceDays,
        classification: PeriodClassificationText.fromValue(row.classification),
        notes: row.notes,
        createdAt: DateTime.parse(row.createdAt),
        updatedAt: DateTime.parse(row.updatedAt),
        deletedAt: _parseDateTime(row.deletedAt),
        syncStatus: SyncStatus.values.firstWhere(
          (item) => item.name == row.syncStatus,
          orElse: () => SyncStatus.pending,
        ),
        remoteUpdatedAt: _parseDateTime(row.remoteUpdatedAt),
      );

  Map<String, Object?> _toJson(PeriodRecord record) => {
        'id': record.id,
        'startDate': DateOnly.format(record.startDate),
        'endDate':
            record.endDate == null ? null : DateOnly.format(record.endDate!),
        'notes': record.notes,
        'createdAt': record.createdAt.toUtc().toIso8601String(),
        'updatedAt': record.updatedAt.toUtc().toIso8601String(),
      };

  String? _cleanNotes(String? notes) {
    final value = notes?.trim();
    if (value == null || value.isEmpty) return null;
    if (value.length > 500) {
      throw const ValidationFailure('Catatan maksimal 500 karakter.');
    }
    return value;
  }

  DateTime? _parseDate(String? value) =>
      value == null ? null : DateOnly.parse(value);
  DateTime? _parseDateTime(String? value) =>
      value == null ? null : DateTime.parse(value);
}
