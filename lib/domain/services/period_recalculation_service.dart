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
    this.database,
    this.predictionService,
    this.classificationService,
  );

  final AppDatabase database;
  final PredictionService predictionService;
  final ClassificationService classificationService;

  Future<CyclePrediction> recalculate() async {
    final rows = await (database.select(database.periodEntries)
          ..where((table) => table.deletedAt.isNull())
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
            updatedAt: Value(DateTime.now().toUtc().toIso8601String()),
            syncStatus: const Value('pending'),
          ),
        );
      }
    });
    final next = predictionService.predict(starts);
    await database.delete(database.predictions).go();
    if (next.ready) {
      await database.into(database.predictions).insert(
            PredictionsCompanion.insert(
              id: const Uuid().v4(),
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
}
