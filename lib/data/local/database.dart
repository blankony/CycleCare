import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [PeriodEntries, Predictions, AppSettings, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  factory AppDatabase.memory() => AppDatabase(NativeDatabase.memory());

  static Future<AppDatabase> open() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'cycle_care.sqlite'));
    return AppDatabase(NativeDatabase(file));
  }

  @override
  int get schemaVersion => 1;

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
        },
        onUpgrade: (Migrator m, int from, int to) async {},
      );

  Future<void> deleteAllLocalData() async {
    await transaction(() async {
      await delete(periodEntries).go();
      await delete(predictions).go();
      await delete(appSettings).go();
      await delete(syncQueue).go();
    });
  }

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
