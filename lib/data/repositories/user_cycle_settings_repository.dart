import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../../domain/entities/user_cycle_settings.dart';

abstract interface class UserCycleSettingsRepository {
  Stream<UserCycleSettingsRecord> watch();
  Future<UserCycleSettingsRecord> get();
  Future<void> updateFertilityVisibility({
    required bool showOvulationEstimate,
    required bool showFertileWindow,
  });
  Future<void> updateReminder(bool enabled);
  Future<void> markSummaryShown(String periodId);
}

class DriftUserCycleSettingsRepository implements UserCycleSettingsRepository {
  DriftUserCycleSettingsRepository(this.database, {required this.userId});

  final AppDatabase database;
  final String userId;

  @override
  Stream<UserCycleSettingsRecord> watch() {
    _ensureExists();
    return (database.select(database.userCycleSettings)
          ..where((table) => table.userId.equals(userId)))
        .watchSingle()
        .map(_fromRow);
  }

  @override
  Future<UserCycleSettingsRecord> get() async {
    await _ensureExists();
    final row = await (database.select(database.userCycleSettings)
          ..where((table) => table.userId.equals(userId)))
        .getSingle();
    return _fromRow(row);
  }

  @override
  Future<void> updateFertilityVisibility({
    required bool showOvulationEstimate,
    required bool showFertileWindow,
  }) =>
      _update(
        showOvulationEstimate: showOvulationEstimate,
        showFertileWindow: showFertileWindow,
      );

  @override
  Future<void> updateReminder(bool enabled) =>
      _update(reminderEnabled: enabled);

  @override
  Future<void> markSummaryShown(String periodId) =>
      _update(lastSummaryPeriodId: periodId);

  Future<void> _ensureExists() async {
    final existing = await (database.select(database.userCycleSettings)
          ..where((table) => table.userId.equals(userId)))
        .getSingleOrNull();
    if (existing != null) return;
    final now = DateTime.now().toUtc().toIso8601String();
    await database.into(database.userCycleSettings).insert(
          UserCycleSettingsCompanion.insert(
            userId: userId,
            updatedAt: now,
            syncStatus: const Value('synced'),
          ),
        );
  }

  Future<void> _update({
    bool? showOvulationEstimate,
    bool? showFertileWindow,
    bool? reminderEnabled,
    String? lastSummaryPeriodId,
  }) async {
    await _ensureExists();
    final current = await get();
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      await (database.update(database.userCycleSettings)
            ..where((table) => table.userId.equals(userId)))
          .write(
        UserCycleSettingsCompanion(
          showOvulationEstimate:
              Value(showOvulationEstimate ?? current.showOvulationEstimate),
          showFertileWindow:
              Value(showFertileWindow ?? current.showFertileWindow),
          reminderEnabled: Value(reminderEnabled ?? current.reminderEnabled),
          lastSummaryPeriodId:
              Value(lastSummaryPeriodId ?? current.lastSummaryPeriodId),
          updatedAt: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _queue(now);
    });
  }

  Future<void> _queue(String now) async {
    final row = await (database.select(database.userCycleSettings)
          ..where((table) => table.userId.equals(userId)))
        .getSingle();
    await (database.delete(database.syncQueue)
          ..where((table) => table.userId.equals(userId))
          ..where((table) => table.entityType.equals('user_cycle_settings'))
          ..where((table) => table.entityId.equals(userId)))
        .go();
    await database.into(database.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: const Uuid().v4(),
            userId: Value(userId),
            entityType: 'user_cycle_settings',
            entityId: userId,
            operation: 'upsert',
            payload: jsonEncode({
              'user_id': userId,
              'show_ovulation_estimate': row.showOvulationEstimate,
              'show_fertile_window': row.showFertileWindow,
              'reminder_enabled': row.reminderEnabled,
              'last_summary_period_id': row.lastSummaryPeriodId,
              'last_successful_sync_at': row.lastSuccessfulSyncAt,
              'initial_sync_completed': row.initialSyncCompleted,
              'updated_at': now,
              'version': row.version + 1,
            }),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  UserCycleSettingsRecord _fromRow(UserCycleSetting row) =>
      UserCycleSettingsRecord(
        userId: row.userId,
        showOvulationEstimate: row.showOvulationEstimate,
        showFertileWindow: row.showFertileWindow,
        reminderEnabled: row.reminderEnabled,
        lastSummaryPeriodId: row.lastSummaryPeriodId,
        lastSuccessfulSyncAt: row.lastSuccessfulSyncAt == null
            ? null
            : DateTime.parse(row.lastSuccessfulSyncAt!),
        initialSyncCompleted: row.initialSyncCompleted,
        updatedAt: DateTime.parse(row.updatedAt),
      );
}
