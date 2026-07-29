import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/date/date_only.dart';
import '../../core/errors/app_failure.dart';
import '../../data/local/database.dart';

class BackupService {
  const BackupService(this.database);

  final AppDatabase database;
  static const schemaVersion = 1;

  Future<File> createExportFile() async {
    final periods = await database.select(database.periodEntries).get();
    final predictions = await database.select(database.predictions).get();
    final settings = await database.select(database.appSettings).get();
    final payload = {
      'schemaVersion': schemaVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'periodEntries': periods
          .map((row) => {
                'id': row.id,
                'startDate': row.startDate,
                'endDate': row.endDate,
                'cycleLengthDays': row.cycleLengthDays,
                'periodDurationDays': row.periodDurationDays,
                'predictedStartAtEntry': row.predictedStartAtEntry,
                'windowStartAtEntry': row.windowStartAtEntry,
                'windowEndAtEntry': row.windowEndAtEntry,
                'varianceDays': row.varianceDays,
                'classification': row.classification,
                'notes': row.notes,
                'createdAt': row.createdAt,
                'updatedAt': row.updatedAt,
                'deletedAt': row.deletedAt,
                'syncStatus': row.syncStatus,
                'remoteUpdatedAt': row.remoteUpdatedAt,
              })
          .toList(),
      'predictions': predictions
          .map((row) => {
                'id': row.id,
                'generatedAt': row.generatedAt,
                'predictedStart': row.predictedStart,
                'windowStart': row.windowStart,
                'windowEnd': row.windowEnd,
                'baselineCycleDays': row.baselineCycleDays,
                'variabilityDays': row.variabilityDays,
                'confidence': row.confidence,
                'basedOnCycles': row.basedOnCycles,
                'modelVersion': row.modelVersion,
              })
          .toList(),
      'settings': settings
          .map((row) =>
              {'key': row.key, 'value': row.value, 'updatedAt': row.updatedAt})
          .toList(),
    };
    final directory = await getTemporaryDirectory();
    final file = File(
        '${directory.path}/cyclecare-${DateTime.now().millisecondsSinceEpoch}.json');
    return file.writeAsString(jsonEncode(payload));
  }

  Future<void> shareExport() async {
    final file = await createExportFile();
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'Backup data CycleCare'),
    );
  }

  Future<void> importFromPicker({required bool replaceExisting}) async {
    final result = await FilePicker.platform.pickFiles(
        withData: true, type: FileType.custom, allowedExtensions: ['json']);
    if (result == null || result.files.single.bytes == null) return;
    final payload = jsonDecode(utf8.decode(result.files.single.bytes!));
    if (payload is! Map<String, dynamic> ||
        payload['schemaVersion'] != schemaVersion) {
      throw const AppFailure('Versi backup tidak didukung.');
    }
    final periods = _list(payload, 'periodEntries');
    final predictions = _list(payload, 'predictions');
    final settings = _list(payload, 'settings');
    await database.transaction(() async {
      if (replaceExisting) {
        await database.delete(database.periodEntries).go();
        await database.delete(database.predictions).go();
        await database.delete(database.appSettings).go();
        await database.delete(database.syncQueue).go();
      }
      for (final row in periods) {
        _require(row, ['id', 'startDate', 'createdAt', 'updatedAt']);
        DateOnly.parse(row['startDate'] as String);
        await database.into(database.periodEntries).insertOnConflictUpdate(
              PeriodEntriesCompanion.insert(
                id: row['id'] as String,
                startDate: row['startDate'] as String,
                endDate: Value(row['endDate'] as String?),
                cycleLengthDays: Value(row['cycleLengthDays'] as int?),
                periodDurationDays: Value(row['periodDurationDays'] as int?),
                predictedStartAtEntry:
                    Value(row['predictedStartAtEntry'] as String?),
                windowStartAtEntry: Value(row['windowStartAtEntry'] as String?),
                windowEndAtEntry: Value(row['windowEndAtEntry'] as String?),
                varianceDays: Value(row['varianceDays'] as int?),
                classification: Value(row['classification'] as String?),
                notes: Value(row['notes'] as String?),
                createdAt: row['createdAt'] as String,
                updatedAt: row['updatedAt'] as String,
                deletedAt: Value(row['deletedAt'] as String?),
                syncStatus: const Value('pending'),
                remoteUpdatedAt: Value(row['remoteUpdatedAt'] as String?),
              ),
            );
      }
      for (final row in predictions) {
        _require(row, [
          'id',
          'generatedAt',
          'predictedStart',
          'windowStart',
          'windowEnd'
        ]);
        await database.into(database.predictions).insertOnConflictUpdate(
              PredictionsCompanion.insert(
                id: row['id'] as String,
                generatedAt: row['generatedAt'] as String,
                predictedStart: row['predictedStart'] as String,
                windowStart: row['windowStart'] as String,
                windowEnd: row['windowEnd'] as String,
                baselineCycleDays: row['baselineCycleDays'] as int,
                variabilityDays: row['variabilityDays'] as int,
                confidence: row['confidence'] as String,
                basedOnCycles: row['basedOnCycles'] as int,
                modelVersion: row['modelVersion'] as String,
              ),
            );
      }
      for (final row in settings) {
        _require(row, ['key', 'updatedAt']);
        await database.into(database.appSettings).insertOnConflictUpdate(
              AppSettingsCompanion.insert(
                  key: row['key'] as String,
                  value: Value(row['value'] as String?),
                  updatedAt: row['updatedAt'] as String),
            );
      }
    });
  }

  List<Map<String, dynamic>> _list(Map<String, dynamic> payload, String key) {
    final value = payload[key];
    if (value is! List) throw AppFailure('Backup tidak memiliki bagian $key.');
    return value.whereType<Map<String, dynamic>>().toList();
  }

  void _require(Map<String, dynamic> row, List<String> keys) {
    if (keys.any((key) => row[key] == null)) {
      throw const AppFailure('Format backup tidak valid.');
    }
  }
}
