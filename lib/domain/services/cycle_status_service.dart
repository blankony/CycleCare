import '../../core/date/date_only.dart';
import '../entities/cycle_insights.dart';
import '../entities/period_record.dart';
import '../entities/prediction.dart';

class CycleStatusService {
  const CycleStatusService();

  CycleStatus calculate({
    required List<PeriodRecord> periods,
    required DateTime today,
    CyclePrediction? prediction,
  }) {
    final active = periods.where((period) => period.deletedAt == null).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    if (active.isEmpty) return const CycleStatus();
    final normalizedToday = DateOnly.normalize(today);
    final latest = active.last;
    final cycleDay =
        DateOnly.differenceInDays(normalizedToday, latest.startDate) + 1;
    final isMenstruating = !normalizedToday.isBefore(latest.startDate) &&
        (latest.endDate == null || !normalizedToday.isAfter(latest.endDate!));
    var lateDays = 0;
    var inWindow = false;
    if (prediction?.ready == true) {
      final windowStart = prediction!.windowStart!;
      final windowEnd = prediction.windowEnd!;
      inWindow = !normalizedToday.isBefore(windowStart) &&
          !normalizedToday.isAfter(windowEnd);
      if (normalizedToday.isAfter(windowEnd)) {
        lateDays = DateOnly.differenceInDays(normalizedToday, windowEnd);
      }
    }
    return CycleStatus(
      currentCycleDay: cycleDay > 0 ? cycleDay : null,
      currentMenstruationDay: isMenstruating && cycleDay > 0 ? cycleDay : null,
      lateDays: lateDays,
      isPredictionWindowToday: inWindow,
    );
  }
}
