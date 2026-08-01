import '../entities/cycle_insights.dart';
import '../entities/enums.dart';
import '../entities/period_day_log.dart';
import '../entities/period_record.dart';
import 'clinical_reference_service.dart';
import 'cycle_statistics_service.dart';

class EndOfCycleSummaryService {
  const EndOfCycleSummaryService(
    this.statisticsService,
    this.referenceService,
  );

  final CycleStatisticsService statisticsService;
  final ClinicalReferenceService referenceService;

  EndOfCycleSummary build({
    required PeriodRecord period,
    required List<PeriodRecord> periods,
    required List<PeriodDayLogRecord> flowLogs,
    required DateTime today,
  }) {
    final earlier = periods
        .where((item) => item.startDate.isBefore(period.startDate))
        .toList();
    final previousStats = statisticsService.calculate(
      periods: earlier,
      flowLogs: flowLogs,
      today: today,
    );
    final flowCounts = <MenstrualFlow, int>{};
    for (final log in flowLogs.where((log) => log.periodEntryId == period.id)) {
      final flow = MenstrualFlowText.fromValue(log.flow);
      if (flow != null) flowCounts[flow] = (flowCounts[flow] ?? 0) + 1;
    }
    final average = previousStats.averageCycleLength;
    return EndOfCycleSummary(
      period: period,
      flowCounts: flowCounts,
      previousAverageCycleLength: average,
      differenceFromAverage: average == null || period.cycleLengthDays == null
          ? null
          : period.cycleLengthDays! - average,
      reference: referenceService.compare(
        cycleLengthDays: period.cycleLengthDays,
        bleedingDurationDays: period.periodDurationDays,
      ),
      pattern: previousStats.pattern,
    );
  }
}
