import 'enums.dart';

class CyclePrediction {
  const CyclePrediction({
    required this.ready,
    required this.basedOnCycles,
    required this.intervals,
    required this.excludedIntervals,
    required this.modelVersion,
    this.predictedStart,
    this.windowStart,
    this.windowEnd,
    this.baselineCycleDays,
    this.variabilityDays,
    this.confidence,
  });

  const CyclePrediction.insufficient({
    required int basedOnCycles,
    required List<int> intervals,
    String modelVersion = 'robust-weighted-v1',
  }) : this(
          ready: false,
          basedOnCycles: basedOnCycles,
          intervals: intervals,
          excludedIntervals: const [],
          modelVersion: modelVersion,
        );

  final bool ready;
  final DateTime? predictedStart;
  final DateTime? windowStart;
  final DateTime? windowEnd;
  final int? baselineCycleDays;
  final int? variabilityDays;
  final int basedOnCycles;
  final PredictionConfidence? confidence;
  final List<int> intervals;
  final List<int> excludedIntervals;
  final String modelVersion;
}

class ClassificationResult {
  const ClassificationResult({
    required this.classification,
    required this.signedVarianceDays,
    required this.absoluteVarianceDays,
  });

  final PeriodClassification classification;
  final int signedVarianceDays;
  final int absoluteVarianceDays;
}
