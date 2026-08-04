import 'enums.dart';
import 'period_record.dart';
import 'prediction.dart';

class CycleStatus {
  const CycleStatus({
    this.currentCycleDay,
    this.currentMenstruationDay,
    this.lateDays = 0,
    this.isPredictionWindowToday = false,
  });

  final int? currentCycleDay;
  final int? currentMenstruationDay;
  final int lateDays;
  final bool isPredictionWindowToday;

  bool get isLate => lateDays > 0;
}

class FertilityEstimate {
  const FertilityEstimate({
    required this.ovulationCenter,
    required this.earliestOvulation,
    required this.latestOvulation,
    required this.fertileWindowStart,
    required this.fertileWindowEnd,
    required this.confidence,
  });

  final DateTime ovulationCenter;
  final DateTime earliestOvulation;
  final DateTime latestOvulation;
  final DateTime fertileWindowStart;
  final DateTime fertileWindowEnd;
  final PredictionConfidence confidence;
}

class FutureCycleProjection {
  const FutureCycleProjection({
    required this.sequence,
    required this.predictedStart,
    required this.windowStart,
    required this.windowEnd,
    required this.certainty,
    required this.confidence,
  });

  final int sequence;
  final DateTime predictedStart;
  final DateTime windowStart;
  final DateTime windowEnd;
  final ProjectionCertainty certainty;
  final PredictionConfidence confidence;
}

class CycleStatistics {
  const CycleStatistics({
    required this.recordedPeriods,
    required this.completedPeriods,
    required this.pattern,
    required this.classificationCounts,
    this.currentCycleDay,
    this.latestCycleLength,
    this.averageCycleLength,
    this.medianCycleLength,
    this.shortestCycle,
    this.longestCycle,
    this.cycleRange,
    this.cycleVariability,
    this.averagePeriodDuration,
    this.medianPeriodDuration,
    this.shortestPeriod,
    this.longestPeriod,
    this.recentTrendDays,
    this.mostCommonFlow,
    this.cycleLengthSamples = 0,
    this.periodDurationSamples = 0,
    this.recentCycleLengths = const [],
    this.flowCounts = const {},
  });

  const CycleStatistics.empty()
      : this(
          recordedPeriods: 0,
          completedPeriods: 0,
          pattern: CyclePattern.insufficientData,
          classificationCounts: const {},
        );

  final int recordedPeriods;
  final int completedPeriods;
  final int? currentCycleDay;
  final int? latestCycleLength;
  final double? averageCycleLength;
  final double? medianCycleLength;
  final int? shortestCycle;
  final int? longestCycle;
  final int? cycleRange;
  final double? cycleVariability;
  final CyclePattern pattern;
  final double? averagePeriodDuration;
  final double? medianPeriodDuration;
  final int? shortestPeriod;
  final int? longestPeriod;
  final double? recentTrendDays;
  final Map<PeriodClassification, int> classificationCounts;
  final MenstrualFlow? mostCommonFlow;
  final int cycleLengthSamples;
  final int periodDurationSamples;
  final List<int> recentCycleLengths;
  final Map<MenstrualFlow, int> flowCounts;
}

class AdultReferenceResult {
  const AdultReferenceResult({
    required this.cycleLength,
    required this.bleedingDuration,
  });

  final ReferenceComparison cycleLength;
  final ReferenceComparison bleedingDuration;

  bool get shouldSuggestConsultation =>
      cycleLength == ReferenceComparison.outsideRange ||
      bleedingDuration == ReferenceComparison.outsideRange;
}

class EndOfCycleSummary {
  const EndOfCycleSummary({
    required this.period,
    required this.flowCounts,
    required this.reference,
    required this.pattern,
    this.previousAverageCycleLength,
    this.differenceFromAverage,
  });

  final PeriodRecord period;
  final Map<MenstrualFlow, int> flowCounts;
  final double? previousAverageCycleLength;
  final double? differenceFromAverage;
  final AdultReferenceResult reference;
  final CyclePattern pattern;
}

class CycleInsights {
  const CycleInsights({
    required this.status,
    required this.statistics,
    required this.projections,
    this.prediction,
    this.fertility,
  });

  final CycleStatus status;
  final CycleStatistics statistics;
  final CyclePrediction? prediction;
  final FertilityEstimate? fertility;
  final List<FutureCycleProjection> projections;
}
