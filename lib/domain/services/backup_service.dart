import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../core/date/date_only.dart';
import '../../core/errors/app_failure.dart';
import '../../data/local/database.dart';

class BackupService {
  const BackupService(this.database, {this.userId});

  final AppDatabase database;
  final String? userId;
  static const schemaVersion = 2;

  Future<Map<String, dynamic>> exportPayload() async {
    final periods = await database.select(database.periodEntries).get();
    final predictions = await database.select(database.predictions).get();
    final flowLogs = await database.select(database.periodDayLogs).get();
    final cycleSettings = userId == null
        ? const <UserCycleSetting>[]
        : await (database.select(database.userCycleSettings)
              ..where((table) => table.userId.equals(userId!)))
            .get();
    final settings = await database.select(database.appSettings).get();
    return {
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
                'predictionConfidenceAtEntry': row.predictionConfidenceAtEntry,
                'predictionModelVersionAtEntry':
                    row.predictionModelVersionAtEntry,
                'predictionSampleSizeAtEntry': row.predictionSampleSizeAtEntry,
                'predictionSnapshotAt': row.predictionSnapshotAt,
                'createdAt': row.createdAt,
                'updatedAt': row.updatedAt,
                'deletedAt': row.deletedAt,
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
      'periodDayLogs': flowLogs
          .where((row) => userId == null || row.userId == userId)
          .map((row) => {
                'id': row.id,
                'periodEntryId': row.periodEntryId,
                'logDate': row.logDate,
                'flow': row.flow,
                'createdAt': row.createdAt,
                'updatedAt': row.updatedAt,
                'deletedAt': row.deletedAt,
              })
          .toList(),
      'userCycleSettings': cycleSettings
          .map((row) => {
                'showOvulationEstimate': row.showOvulationEstimate,
                'showFertileWindow': row.showFertileWindow,
                'reminderEnabled': row.reminderEnabled,
                'lastSummaryPeriodId': row.lastSummaryPeriodId,
                'lastSuccessfulSyncAt': row.lastSuccessfulSyncAt,
                'initialSyncCompleted': row.initialSyncCompleted,
                'updatedAt': row.updatedAt,
              })
          .toList(),
      'settings': settings
          .map((row) => {
                'key': row.key,
                'value': row.value,
                'updatedAt': row.updatedAt,
              })
          .toList(),
    };
  }

  Future<File> createExportFile() async {
    final directory = await getTemporaryDirectory();
    final file = File(
        '${directory.path}/cyclecare-${DateTime.now().millisecondsSinceEpoch}.json');
    return file.writeAsString(jsonEncode(await exportPayload()));
  }

  Future<void> shareExport() async {
    final file = await createExportFile();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text:
            'Backup data CycleCare. File tidak terenkripsi dan berisi data kesehatan sensitif.',
      ),
    );
  }

  Future<void> importFromPicker({required bool replaceExisting}) async {
    if (userId == null) {
      throw const AppFailure('Sesi akun diperlukan untuk import.');
    }
    final result = await FilePicker.platform.pickFiles(
        withData: true, type: FileType.custom, allowedExtensions: ['json']);
    if (result == null || result.files.single.bytes == null) {
      return;
    }
    final decoded = jsonDecode(utf8.decode(result.files.single.bytes!));
    if (decoded is! Map<String, dynamic>) {
      throw const AppFailure('Format backup tidak valid.');
    }
    final version = decoded['schemaVersion'];
    if (version is! int || (version != 1 && version != schemaVersion)) {
      throw const AppFailure('Versi backup tidak didukung.');
    }
    final periods = _list(decoded, 'periodEntries');
    final predictions = _list(decoded, 'predictions', optional: true);
    final flowLogs = _list(decoded, 'periodDayLogs', optional: true);
    final cycleSettings = _list(decoded, 'userCycleSettings', optional: true);
    final settings = _list(decoded, 'settings', optional: true);
    _validatePeriods(periods);
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      if (replaceExisting) {
        await database.deleteAllLocalData();
      }
      for (final row in periods) {
        final id = _string(row, 'id');
        await database.into(database.periodEntries).insertOnConflictUpdate(
              PeriodEntriesCompanion.insert(
                id: id,
                userId: Value(userId),
                startDate: _dateOnly(row, 'startDate'),
                endDate: Value(_nullableString(row, 'endDate')),
                cycleLengthDays: Value(_nullableInt(row, 'cycleLengthDays')),
                periodDurationDays:
                    Value(_nullableInt(row, 'periodDurationDays')),
                predictedStartAtEntry:
                    Value(_nullableString(row, 'predictedStartAtEntry')),
                windowStartAtEntry:
                    Value(_nullableString(row, 'windowStartAtEntry')),
                windowEndAtEntry:
                    Value(_nullableString(row, 'windowEndAtEntry')),
                varianceDays: Value(_nullableInt(row, 'varianceDays')),
                classification: Value(_nullableString(row, 'classification')),
                notes: Value(_nullableString(row, 'notes')),
                createdAt: _string(row, 'createdAt', fallback: now),
                updatedAt: now,
                deletedAt: Value(_nullableString(row, 'deletedAt')),
                syncStatus: const Value('pending'),
                predictionConfidenceAtEntry:
                    Value(_nullableString(row, 'predictionConfidenceAtEntry')),
                predictionModelVersionAtEntry: Value(
                    _nullableString(row, 'predictionModelVersionAtEntry')),
                predictionSampleSizeAtEntry:
                    Value(_nullableInt(row, 'predictionSampleSizeAtEntry')),
                predictionSnapshotAt:
                    Value(_nullableString(row, 'predictionSnapshotAt')),
              ),
            );
        final deletedAt = _nullableString(row, 'deletedAt');
        await _queue(
            'period_entry', id, deletedAt == null ? 'upsert' : 'delete', now, {
          'id': id,
          'user_id': userId,
          'start_date': _dateOnly(row, 'startDate'),
          'end_date': _nullableString(row, 'endDate'),
          'cycle_length_days': _nullableInt(row, 'cycleLengthDays'),
          'period_duration_days': _nullableInt(row, 'periodDurationDays'),
          'predicted_start_at_entry':
              _nullableString(row, 'predictedStartAtEntry'),
          'window_start_at_entry': _nullableString(row, 'windowStartAtEntry'),
          'window_end_at_entry': _nullableString(row, 'windowEndAtEntry'),
          'variance_days': _nullableInt(row, 'varianceDays'),
          'classification': _nullableString(row, 'classification'),
          'notes': _nullableString(row, 'notes'),
          'created_at': _string(row, 'createdAt', fallback: now),
          'updated_at': now,
          'deleted_at': deletedAt,
          'prediction_confidence_at_entry':
              _nullableString(row, 'predictionConfidenceAtEntry'),
          'prediction_model_version_at_entry':
              _nullableString(row, 'predictionModelVersionAtEntry'),
          'prediction_sample_size_at_entry':
              _nullableInt(row, 'predictionSampleSizeAtEntry'),
          'prediction_snapshot_at':
              _nullableString(row, 'predictionSnapshotAt'),
          'version': 1,
        });
      }
      for (final row in flowLogs) {
        final id = _string(row, 'id');
        await database.into(database.periodDayLogs).insertOnConflictUpdate(
              PeriodDayLogsCompanion.insert(
                id: id,
                userId: Value(userId),
                periodEntryId: _string(row, 'periodEntryId'),
                logDate: _dateOnly(row, 'logDate'),
                flow: _string(row, 'flow'),
                createdAt: _string(row, 'createdAt', fallback: now),
                updatedAt: now,
                deletedAt: Value(_nullableString(row, 'deletedAt')),
                syncStatus: const Value('pending'),
              ),
            );
        final deletedAt = _nullableString(row, 'deletedAt');
        await _queue('period_day_log', id,
            deletedAt == null ? 'upsert' : 'delete', now, {
          'id': id,
          'user_id': userId,
          'period_entry_id': _string(row, 'periodEntryId'),
          'log_date': _dateOnly(row, 'logDate'),
          'flow': _string(row, 'flow'),
          'created_at': _string(row, 'createdAt', fallback: now),
          'updated_at': now,
          'deleted_at': deletedAt,
          'version': 1,
        });
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
                id: _string(row, 'id'),
                userId: Value(userId),
                generatedAt: _string(row, 'generatedAt'),
                predictedStart: _dateOnly(row, 'predictedStart'),
                windowStart: _dateOnly(row, 'windowStart'),
                windowEnd: _dateOnly(row, 'windowEnd'),
                baselineCycleDays: _int(row, 'baselineCycleDays'),
                variabilityDays: _int(row, 'variabilityDays'),
                confidence: _string(row, 'confidence'),
                basedOnCycles: _int(row, 'basedOnCycles'),
                modelVersion: _string(row, 'modelVersion'),
              ),
            );
      }
      for (final row in cycleSettings) {
        await database.into(database.userCycleSettings).insertOnConflictUpdate(
              UserCycleSettingsCompanion.insert(
                userId: userId!,
                showOvulationEstimate:
                    Value(row['showOvulationEstimate'] as bool? ?? false),
                showFertileWindow:
                    Value(row['showFertileWindow'] as bool? ?? false),
                reminderEnabled:
                    Value(row['reminderEnabled'] as bool? ?? false),
                lastSummaryPeriodId:
                    Value(_nullableString(row, 'lastSummaryPeriodId')),
                lastSuccessfulSyncAt:
                    Value(_nullableString(row, 'lastSuccessfulSyncAt')),
                initialSyncCompleted:
                    Value(row['initialSyncCompleted'] as bool? ?? false),
                updatedAt: now,
                syncStatus: const Value('pending'),
              ),
            );
        await _queue('user_cycle_settings', userId!, 'upsert', now, {
          'user_id': userId,
          'show_ovulation_estimate':
              row['showOvulationEstimate'] as bool? ?? false,
          'show_fertile_window': row['showFertileWindow'] as bool? ?? false,
          'reminder_enabled': row['reminderEnabled'] as bool? ?? false,
          'last_summary_period_id': _nullableString(row, 'lastSummaryPeriodId'),
          'last_successful_sync_at':
              _nullableString(row, 'lastSuccessfulSyncAt'),
          'initial_sync_completed':
              row['initialSyncCompleted'] as bool? ?? false,
          'updated_at': now,
          'version': 1,
        });
      }
      for (final row in settings) {
        _require(row, ['key']);
        await database.into(database.appSettings).insertOnConflictUpdate(
              AppSettingsCompanion.insert(
                key: _string(row, 'key'),
                value: Value(_nullableString(row, 'value')),
                updatedAt: now,
              ),
            );
      }
    });
    if (cycleSettings.isEmpty) {
      await database.markInitialSyncCompleted(userId!, now);
    }
  }

  Future<void> _queue(String entityType, String entityId, String operation,
      String now, Map<String, dynamic> payload) async {
    await (database.delete(database.syncQueue)
          ..where((table) => table.userId.equals(userId!))
          ..where((table) => table.entityType.equals(entityType))
          ..where((table) => table.entityId.equals(entityId)))
        .go();
    await database.into(database.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: const Uuid().v4(),
            userId: Value(userId),
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: jsonEncode(payload),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  void _validatePeriods(List<Map<String, dynamic>> periods) {
    final ranges = <(DateTime, DateTime)>[];
    for (final row in periods) {
      _require(row, ['id', 'startDate']);
      final start = DateOnly.parse(_dateOnly(row, 'startDate'));
      final endValue = _nullableString(row, 'endDate');
      final end = endValue == null ? null : DateOnly.parse(endValue);
      if (end != null && end.isBefore(start)) {
        throw const AppFailure('Rentang period pada backup tidak valid.');
      }
      if (start.isAfter(DateOnly.normalize(DateTime.now()))) {
        throw const AppFailure('Backup berisi tanggal period di masa depan.');
      }
      if (_nullableString(row, 'deletedAt') == null) {
        ranges.add((start, end ?? DateOnly.normalize(DateTime.now())));
      }
    }
    ranges.sort((a, b) => a.$1.compareTo(b.$1));
    for (var index = 1; index < ranges.length; index++) {
      if (!ranges[index].$1.isAfter(ranges[index - 1].$2)) {
        throw const AppFailure(
            'Backup berisi tanggal duplikat atau rentang period tumpang tindih.');
      }
    }
  }

  List<Map<String, dynamic>> _list(Map<String, dynamic> payload, String key,
      {bool optional = false}) {
    final value = payload[key];
    if (value == null && optional) {
      return [];
    }
    if (value is! List) {
      throw AppFailure('Backup tidak memiliki bagian $key.');
    }
    return value.whereType<Map<String, dynamic>>().toList();
  }

  void _require(Map<String, dynamic> row, List<String> keys) {
    if (keys.any((key) => row[key] == null)) {
      throw const AppFailure('Format backup tidak valid.');
    }
  }

  String _string(Map<String, dynamic> row, String key, {String? fallback}) {
    final value = row[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    if (fallback != null) {
      return fallback;
    }
    throw AppFailure('Field backup $key tidak valid.');
  }

  String? _nullableString(Map<String, dynamic> row, String key) {
    final value = row[key];
    return value is String && value.isNotEmpty ? value : null;
  }

  int _int(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value is int) {
      return value;
    }
    throw AppFailure('Field backup $key tidak valid.');
  }

  int? _nullableInt(Map<String, dynamic> row, String key) {
    final value = row[key];
    return value is int ? value : null;
  }

  String _dateOnly(Map<String, dynamic> row, String key) {
    final value = _string(row, key);
    return DateOnly.format(DateOnly.parse(value));
  }
}
