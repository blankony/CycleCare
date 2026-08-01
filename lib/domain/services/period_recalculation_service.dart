import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/date/date_only.dart';
import '../../data/local/database.dart';
import '../entities/enums.dart';
import '../entities/prediction.dart';
import 'classification_service.dart';
import 'prediction_service.dart';

class PeriodRecalculationService {
  PeriodRecalculationService(
      this.database, this.predictionService, this.classificationService,
      {this.userId});

  final AppDatabase database;
  final PredictionService predictionService;
  final ClassificationService classificationService;
  final String? userId;

  Future<CyclePrediction> recalculate() async {
    final rows = await (database.select(database.periodEntries)
          ..where((table) => table.deletedAt.isNull())
          ..where((table) => userId == null
              ? const Constant(true)
              : table.userId.equals(userId!))
          ..orderBy([(table) => OrderingTerm.asc(table.startDate)]))
        .get();
    final starts = rows.map((row) => DateOnly.parse(row.startDate)).toList();
    final predictionsBefore = <String, CyclePrediction>{};
    final history = <DateTime>[];
    for (final row in rows) {
      final before = predictionService.predict(history);
      predictionsBefore[row.id] = before;
      history.add(DateOnly.parse(row.startDate));
    }
    await database.transaction(() async {
      for (var index = 0; index < rows.length; index++) {
        final row = rows[index];
        final start = DateOnly.parse(row.startDate);
        final previousStart =
            index == 0 ? null : DateOnly.parse(rows[index - 1].startDate);
        final cycleLength = previousStart == null
            ? null
            : DateOnly.differenceInDays(start, previousStart);
        final duration = row.endDate == null
            ? null
            : DateOnly.differenceInDays(DateOnly.parse(row.endDate!), start) +
                1;
        final before = predictionsBefore[row.id]!;
        final classification = classificationService.classify(
          actualStart: start,
          predictedStart: before.predictedStart,
          windowStart: before.windowStart,
          windowEnd: before.windowEnd,
        );
        await (database.update(database.periodEntries)
              ..where((table) => table.id.equals(row.id)))
            .write(
          PeriodEntriesCompanion(
            cycleLengthDays: Value(cycleLength),
            periodDurationDays: Value(duration),
            predictedStartAtEntry: Value(before.predictedStart == null
                ? null
                : DateOnly.format(before.predictedStart!)),
            windowStartAtEntry: Value(before.windowStart == null
                ? null
                : DateOnly.format(before.windowStart!)),
            windowEndAtEntry: Value(before.windowEnd == null
                ? null
                : DateOnly.format(before.windowEnd!)),
            varianceDays: Value(classification.signedVarianceDays),
            classification: Value(classification.classification.value),
            predictionConfidenceAtEntry: row.predictionConfidenceAtEntry == null
                ? Value(before.confidence?.value)
                : Value(row.predictionConfidenceAtEntry),
            predictionModelVersionAtEntry:
                row.predictionModelVersionAtEntry == null
                    ? Value(before.modelVersion)
                    : Value(row.predictionModelVersionAtEntry),
            predictionSampleSizeAtEntry: row.predictionSampleSizeAtEntry == null
                ? Value(before.basedOnCycles)
                : Value(row.predictionSampleSizeAtEntry),
            predictionSnapshotAt: row.predictionSnapshotAt == null
                ? Value(DateTime.now().toUtc().toIso8601String())
                : Value(row.predictionSnapshotAt),
            updatedAt: Value(DateTime.now().toUtc().toIso8601String()),
            syncStatus: const Value('pending'),
          ),
        );
        await _queueFreshPeriod(row.id);
      }
    });
    final next = predictionService.predict(starts);
    await (database.delete(database.predictions)
          ..where((table) => userId == null
              ? const Constant(true)
              : table.userId.equals(userId!)))
        .go();
    if (next.ready) {
      await database.into(database.predictions).insert(
            PredictionsCompanion.insert(
              id: const Uuid().v4(),
              userId: Value(userId),
              generatedAt: DateTime.now().toUtc().toIso8601String(),
              predictedStart: DateOnly.format(next.predictedStart!),
              windowStart: DateOnly.format(next.windowStart!),
              windowEnd: DateOnly.format(next.windowEnd!),
              baselineCycleDays: next.baselineCycleDays!,
              variabilityDays: next.variabilityDays!,
              confidence: next.confidence!.value,
              basedOnCycles: next.basedOnCycles,
              modelVersion: next.modelVersion,
            ),
          );
    }
    return next;
  }

  Future<void> _queueFreshPeriod(String id) async {
    final row = await (database.select(database.periodEntries)
          ..where((table) => table.id.equals(id)))
        .getSingle();
    final now = DateTime.now().toUtc().toIso8601String();
    final payload = jsonEncode({
      'id': row.id,
      'user_id': row.userId,
      'start_date': row.startDate,
      'end_date': row.endDate,
      'cycle_length_days': row.cycleLengthDays,
      'period_duration_days': row.periodDurationDays,
      'predicted_start_at_entry': row.predictedStartAtEntry,
      'window_start_at_entry': row.windowStartAtEntry,
      'window_end_at_entry': row.windowEndAtEntry,
      'variance_days': row.varianceDays,
      'classification': row.classification,
      'notes': row.notes,
      'created_at': row.createdAt,
      'updated_at': row.updatedAt,
      'deleted_at': row.deletedAt,
      'version': row.version,
      'prediction_confidence_at_entry': row.predictionConfidenceAtEntry,
      'prediction_model_version_at_entry': row.predictionModelVersionAtEntry,
      'prediction_sample_size_at_entry': row.predictionSampleSizeAtEntry,
      'prediction_snapshot_at': row.predictionSnapshotAt,
    });
    await (database.delete(database.syncQueue)
          ..where((table) => table.entityType.equals('period_entry'))
          ..where((table) => table.entityId.equals(id))
          ..where((table) => userId == null
              ? table.userId.isNull()
              : table.userId.equals(userId!)))
        .go();
    await database.into(database.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: const Uuid().v4(),
            userId: Value(userId),
            entityType: 'period_entry',
            entityId: id,
            operation: 'upsert',
            payload: payload,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }
}
