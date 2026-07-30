import 'package:flutter_test/flutter_test.dart';

import 'package:cycle_care/core/date/date_only.dart';
import 'package:cycle_care/domain/entities/enums.dart';
import 'package:cycle_care/domain/services/prediction_service.dart';

void main() {
  const service = PredictionService();
  DateTime d(String value) => DateOnly.parse(value);

  test('returns insufficient data for empty and one date', () {
    expect(service.predict([]).ready, isFalse);
    expect(service.predict([d('2026-01-01')]).ready, isFalse);
  });

  test('returns insufficient data with only one interval', () {
    final result = service.predict([d('2026-01-01'), d('2026-01-29')]);
    expect(result.ready, isFalse);
    expect(result.intervals, [28]);
  });

  test('calculates stable 28 day cycles and minimum window', () {
    final result = service.predict([
      d('2026-01-01'),
      d('2026-01-29'),
      d('2026-02-26'),
      d('2026-03-26'),
    ]);
    expect(result.ready, isTrue);
    expect(result.baselineCycleDays, 28);
    expect(result.variabilityDays, 2);
    expect(result.predictedStart, d('2026-04-23'));
  });

  test('handles 29, 30 day cycles, unsorted dates, and duplicates', () {
    final result = service.predict([
      d('2026-03-31'),
      d('2026-01-01'),
      d('2026-01-30'),
      d('2026-01-30'),
      d('2026-03-01'),
    ]);
    expect(result.ready, isTrue);
    expect(result.intervals, [29, 30, 30]);
    expect(result.baselineCycleDays, inInclusiveRange(29, 30));
  });

  test('excludes a large outlier from the robust baseline', () {
    final result = service.predict([
      d('2026-01-01'),
      d('2026-01-29'),
      d('2026-02-26'),
      d('2026-04-27'),
      d('2026-05-25'),
    ]);
    expect(result.excludedIntervals, contains(60));
    expect(result.baselineCycleDays, 28);
  });

  test('uses at most the six latest intervals', () {
    final dates = <DateTime>[];
    var current = d('2025-01-01');
    for (var index = 0; index < 9; index++) {
      dates.add(current);
      current = current.add(Duration(days: index < 2 ? 60 : 28));
    }
    final result = service.predict(dates);
    expect(result.intervals.length, 6);
  });

  test('caps high variability window at seven days and reports confidence', () {
    final result = service.predict([
      d('2026-01-01'),
      d('2026-01-15'),
      d('2026-03-15'),
      d('2026-03-29'),
      d('2026-06-27'),
      d('2026-07-11'),
      d('2026-09-09'),
    ]);
    expect(result.ready, isTrue);
    expect(result.variabilityDays, lessThanOrEqualTo(7));
    expect(result.confidence, isNot(PredictionConfidence.high));
  });

  test('gives high confidence with five stable usable intervals', () {
    final result = service.predict([
      d('2026-01-01'),
      d('2026-01-29'),
      d('2026-02-26'),
      d('2026-03-26'),
      d('2026-04-23'),
      d('2026-05-21'),
      d('2026-06-18'),
    ]);
    expect(result.confidence, PredictionConfidence.high);
  });

  test('preserves calendar dates across month, year, and leap boundaries', () {
    final result = service.predict(
        [d('2024-01-31'), d('2024-02-29'), d('2024-03-29'), d('2024-04-28')]);
    expect(result.predictedStart, d('2024-05-28'));
    expect(DateOnly.format(d('2024-12-31')), '2024-12-31');
  });
}
