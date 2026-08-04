import 'package:flutter_test/flutter_test.dart';

import 'package:cycle_care/domain/entities/enums.dart';
import 'package:cycle_care/domain/entities/period_day_log.dart';
import 'package:cycle_care/domain/entities/period_record.dart';
import 'package:cycle_care/domain/services/clinical_reference_service.dart';
import 'package:cycle_care/domain/services/cycle_statistics_service.dart';

PeriodRecord record(
        String id, int cycle, int duration, String classification) =>
    PeriodRecord(
      id: id,
      startDate:
          DateTime(2026, 1, 1).add(Duration(days: cycle * int.parse(id))),
      endDate: DateTime(2026, 1, 1)
          .add(Duration(days: cycle * int.parse(id) + duration - 1)),
      cycleLengthDays: cycle,
      periodDurationDays: duration,
      classification: PeriodClassificationText.fromValue(classification),
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
      syncStatus: SyncStatus.synced,
    );

void main() {
  test('calculates personal statistics and consistency label', () {
    final value = const CycleStatisticsService().calculate(
      periods: [
        record('1', 28, 5, 'ON_WINDOW'),
        record('2', 29, 6, 'LATE'),
        record('3', 28, 4, 'EARLY'),
      ],
      flowLogs: [
        PeriodDayLogRecord(
          id: 'flow-1',
          periodEntryId: '1',
          logDate: DateTime(2026, 1, 29),
          flow: MenstrualFlow.light.value,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
        PeriodDayLogRecord(
          id: 'flow-outside-sample',
          periodEntryId: 'archived-period',
          logDate: DateTime(2025, 12, 1),
          flow: MenstrualFlow.heavy.value,
          createdAt: DateTime(2025),
          updatedAt: DateTime(2025),
        ),
      ],
      today: DateTime(2026, 8, 1),
    );
    expect(value.recordedPeriods, 3);
    expect(value.completedPeriods, 3);
    expect(value.averageCycleLength, closeTo(28.33, 0.01));
    expect(value.shortestPeriod, 4);
    expect(value.longestPeriod, 6);
    expect(value.pattern, CyclePattern.consistent);
    expect(value.cycleLengthSamples, 3);
    expect(value.periodDurationSamples, 3);
    expect(value.recentCycleLengths, [28, 29, 28]);
    expect(value.flowCounts, {MenstrualFlow.light: 1});
    expect(value.mostCommonFlow, MenstrualFlow.light);
  });

  test('uses neutral adult reference labels', () {
    const service = ClinicalReferenceService();
    expect(
        service
            .compare(cycleLengthDays: 28, bleedingDurationDays: 5)
            .cycleLength,
        ReferenceComparison.withinRange);
    expect(
        service
            .compare(cycleLengthDays: 40, bleedingDurationDays: 10)
            .shouldSuggestConsultation,
        isTrue);
  });
}
