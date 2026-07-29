import 'package:flutter_test/flutter_test.dart';

import 'package:cycle_care/core/date/date_only.dart';
import 'package:cycle_care/domain/entities/enums.dart';
import 'package:cycle_care/domain/services/classification_service.dart';

void main() {
  const service = ClassificationService();
  final center = DateOnly.parse('2026-03-15');
  final start = DateOnly.parse('2026-03-13');
  final end = DateOnly.parse('2026-03-17');

  test('classifies early, boundaries, center, and late', () {
    expect(
        service
            .classify(
                actualStart: DateOnly.parse('2026-03-12'),
                predictedStart: center,
                windowStart: start,
                windowEnd: end)
            .classification,
        PeriodClassification.early);
    expect(
        service
            .classify(
                actualStart: start,
                predictedStart: center,
                windowStart: start,
                windowEnd: end)
            .classification,
        PeriodClassification.onWindow);
    expect(
        service
            .classify(
                actualStart: end,
                predictedStart: center,
                windowStart: start,
                windowEnd: end)
            .classification,
        PeriodClassification.onWindow);
    expect(
        service
            .classify(
                actualStart: center,
                predictedStart: center,
                windowStart: start,
                windowEnd: end)
            .signedVarianceDays,
        0);
    expect(
        service
            .classify(
                actualStart: DateOnly.parse('2026-03-18'),
                predictedStart: center,
                windowStart: start,
                windowEnd: end)
            .classification,
        PeriodClassification.late);
  });

  test('returns signed and absolute variance', () {
    final early = service.classify(
        actualStart: DateOnly.parse('2026-03-10'),
        predictedStart: center,
        windowStart: start,
        windowEnd: end);
    final late = service.classify(
        actualStart: DateOnly.parse('2026-03-20'),
        predictedStart: center,
        windowStart: start,
        windowEnd: end);
    expect(early.signedVarianceDays, -5);
    expect(early.absoluteVarianceDays, 5);
    expect(late.signedVarianceDays, 5);
  });

  test('classifies missing prediction as insufficient data', () {
    final result = service.classify(
        actualStart: center,
        predictedStart: null,
        windowStart: null,
        windowEnd: null);
    expect(result.classification, PeriodClassification.insufficientData);
  });
}
