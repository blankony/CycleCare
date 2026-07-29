import 'dart:math' as math;

import '../../core/date/date_only.dart';
import '../entities/enums.dart';
import '../entities/prediction.dart';

class PredictionService {
  const PredictionService();

  static const modelVersion = 'robust-weighted-v1';

  CyclePrediction predict(List<DateTime> periodStartDates) {
    final normalized = periodStartDates.map(DateOnly.normalize).toSet().toList()
      ..sort();
    final allIntervals = <int>[];
    for (var index = 1; index < normalized.length; index++) {
      final days =
          DateOnly.differenceInDays(normalized[index], normalized[index - 1]);
      if (days > 0) allIntervals.add(days);
    }
    if (allIntervals.length < 2) {
      return CyclePrediction.insufficient(
        basedOnCycles: normalized.length,
        intervals: allIntervals,
      );
    }

    final intervals = allIntervals.length > 6
        ? allIntervals.sublist(allIntervals.length - 6)
        : allIntervals;
    final median = _median(intervals);
    final deviations =
        intervals.map((value) => (value - median).abs()).toList();
    final mad = _median(deviations);
    final threshold = math.max(7, (mad * 3).round());
    final excluded =
        intervals.where((value) => (value - median).abs() > threshold).toList();
    final usable =
        intervals.where((value) => !excluded.contains(value)).toList();
    final effective = usable.isEmpty ? intervals : usable;
    var weightedTotal = 0;
    var totalWeight = 0;
    for (var index = 0; index < effective.length; index++) {
      final weight = index + 1;
      weightedTotal += effective[index] * weight;
      totalWeight += weight;
    }
    final baseline = (weightedTotal / totalWeight).round();
    final variability = math.max(2, math.min(7, mad.round()));
    final confidence = effective.length >= 5 && variability <= 3
        ? PredictionConfidence.high
        : effective.length >= 3
            ? PredictionConfidence.medium
            : PredictionConfidence.low;
    final predictedStart = normalized.last.add(Duration(days: baseline));
    final windowStart = predictedStart.subtract(Duration(days: variability));
    final windowEnd = predictedStart.add(Duration(days: variability));
    return CyclePrediction(
      ready: true,
      predictedStart: predictedStart,
      windowStart: windowStart,
      windowEnd: windowEnd,
      baselineCycleDays: baseline,
      variabilityDays: variability,
      confidence: confidence,
      basedOnCycles: effective.length + 1,
      intervals: intervals,
      excludedIntervals: excluded,
      modelVersion: modelVersion,
    );
  }

  int _median(List<int> values) {
    final sorted = [...values]..sort();
    final middle = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[middle];
    return ((sorted[middle - 1] + sorted[middle]) / 2).round();
  }
}
