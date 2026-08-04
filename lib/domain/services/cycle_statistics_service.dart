import 'dart:math' as math;

import '../../core/date/date_only.dart';
import '../entities/cycle_insights.dart';
import '../entities/enums.dart';
import '../entities/period_day_log.dart';
import '../entities/period_record.dart';

class CycleStatisticsService {
  const CycleStatisticsService();

  static const sampleSize = 12;

  CycleStatistics calculate({
    required List<PeriodRecord> periods,
    List<PeriodDayLogRecord> flowLogs = const [],
    required DateTime today,
  }) {
    final active = periods.where((period) => period.deletedAt == null).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    if (active.isEmpty) return const CycleStatistics.empty();
    final sample = active.length > sampleSize
        ? active.sublist(active.length - sampleSize)
        : active;
    final cycleLengths = sample
        .map((period) => period.cycleLengthDays)
        .whereType<int>()
        .where((days) => days > 0 && days <= 180)
        .toList();
    final durations = sample
        .map((period) => period.periodDurationDays)
        .whereType<int>()
        .where((days) => days > 0 && days <= 60)
        .toList();
    final averageCycle = _average(cycleLengths);
    final recent = cycleLengths.length >= 2
        ? cycleLengths.sublist(math.max(0, cycleLengths.length - 3))
        : const <int>[];
    final variability = _medianAbsoluteDeviation(cycleLengths);
    final classificationCounts = <PeriodClassification, int>{};
    for (final period in sample) {
      final classification = period.classification;
      if (classification != null &&
          classification != PeriodClassification.insufficientData) {
        classificationCounts[classification] =
            (classificationCounts[classification] ?? 0) + 1;
      }
    }
    final samplePeriodIds = sample.map((period) => period.id).toSet();
    final flowCounts = <MenstrualFlow, int>{};
    for (final log in flowLogs.where(
      (log) =>
          log.deletedAt == null && samplePeriodIds.contains(log.periodEntryId),
    )) {
      final flow = MenstrualFlowText.fromValue(log.flow);
      if (flow != null) flowCounts[flow] = (flowCounts[flow] ?? 0) + 1;
    }
    final commonFlow = flowCounts.isEmpty
        ? null
        : flowCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    final currentCycleDay =
        DateOnly.differenceInDays(today, active.last.startDate) + 1;
    return CycleStatistics(
      recordedPeriods: active.length,
      completedPeriods: active.where((period) => period.endDate != null).length,
      currentCycleDay: currentCycleDay > 0 ? currentCycleDay : null,
      latestCycleLength: cycleLengths.isEmpty ? null : cycleLengths.last,
      averageCycleLength: averageCycle,
      medianCycleLength: _median(cycleLengths),
      shortestCycle:
          cycleLengths.isEmpty ? null : cycleLengths.reduce(math.min),
      longestCycle: cycleLengths.isEmpty ? null : cycleLengths.reduce(math.max),
      cycleRange: cycleLengths.isEmpty
          ? null
          : cycleLengths.reduce(math.max) - cycleLengths.reduce(math.min),
      cycleVariability: variability,
      pattern: patternForVariability(variability, cycleLengths.length),
      averagePeriodDuration: _average(durations),
      medianPeriodDuration: _median(durations),
      shortestPeriod: durations.isEmpty ? null : durations.reduce(math.min),
      longestPeriod: durations.isEmpty ? null : durations.reduce(math.max),
      recentTrendDays: recent.isEmpty || averageCycle == null
          ? null
          : _average(recent)! - averageCycle,
      classificationCounts: classificationCounts,
      mostCommonFlow: commonFlow,
      cycleLengthSamples: cycleLengths.length,
      periodDurationSamples: durations.length,
      recentCycleLengths: recent,
      flowCounts: flowCounts,
    );
  }

  CyclePattern patternForVariability(double? variability, int samples) {
    if (variability == null || samples < 2) {
      return CyclePattern.insufficientData;
    }
    if (variability <= 3) return CyclePattern.consistent;
    if (variability <= 6) return CyclePattern.variable;
    return CyclePattern.highlyVariable;
  }

  double? _average(List<int> values) =>
      values.isEmpty ? null : values.reduce((a, b) => a + b) / values.length;

  double? _median(List<int> values) {
    if (values.isEmpty) return null;
    final sorted = [...values]..sort();
    final middle = sorted.length ~/ 2;
    return sorted.length.isOdd
        ? sorted[middle].toDouble()
        : (sorted[middle - 1] + sorted[middle]) / 2;
  }

  double? _medianAbsoluteDeviation(List<int> values) {
    final median = _median(values);
    if (median == null) return null;
    final deviations = values.map((value) => (value - median).abs()).toList()
      ..sort();
    if (deviations.isEmpty) return null;
    final middle = deviations.length ~/ 2;
    return deviations.length.isOdd
        ? deviations[middle]
        : (deviations[middle - 1] + deviations[middle]) / 2;
  }
}
