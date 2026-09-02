import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../core/date/date_only.dart';
import '../entities/cycle_insights.dart';
import '../entities/period_record.dart';
import '../entities/prediction.dart';

class HomeWidgetService {
  const HomeWidgetService();

  static const _androidProvider = 'CycleCareWidgetProvider';

  Future<void> update({
    required List<PeriodRecord> periods,
    required CyclePrediction? prediction,
    required FertilityEstimate? fertility,
    required CycleStatus? status,
    required String localeCode,
  }) async {
    final isId = localeCode.startsWith('id');
    final active = periods.where((p) => p.deletedAt == null).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    final cycleDay = status?.currentCycleDay;
    final cycleDayText = cycleDay == null
        ? (isId ? 'Belum ada data' : 'No data yet')
        : (isId ? 'Hari $cycleDay' : 'Day $cycleDay');

    String phase;
    if (active.isEmpty) {
      phase = isId ? 'Catat period pertamamu' : 'Log your first period';
    } else if (status?.currentMenstruationDay != null) {
      phase = isId ? 'Fase Menstruasi' : 'Menstrual Phase';
    } else if (fertility != null) {
      final today = DateOnly.normalize(DateTime.now());
      final fs = DateOnly.normalize(fertility.fertileWindowStart);
      final fe = DateOnly.normalize(fertility.fertileWindowEnd);
      final ov = DateOnly.normalize(fertility.ovulationCenter);
      if (!today.isBefore(fs) && !today.isAfter(fe)) {
        phase = today == ov
            ? (isId ? 'Fase Ovulasi' : 'Ovulation Phase')
            : (isId ? 'Fase Subur' : 'Fertile Phase');
      } else if (today.isBefore(fs)) {
        phase = isId ? 'Fase Folikuler' : 'Follicular Phase';
      } else {
        phase = isId ? 'Fase Luteal' : 'Luteal Phase';
      }
    } else {
      phase = isId ? 'Fase Folikuler' : 'Follicular Phase';
    }

    String nextPeriod;
    if (prediction?.ready == true && prediction?.predictedStart != null) {
      final d = prediction!.predictedStart!;
      final fmt = DateFormat('d MMM yyyy', isId ? 'id_ID' : 'en').format(d);
      nextPeriod = isId ? 'Berikutnya: $fmt' : 'Next: $fmt';
    } else {
      nextPeriod = isId ? 'Prediksi belum tersedia' : 'No prediction yet';
    }

    try {
      await HomeWidget.saveWidgetData<String>('cycle_day', cycleDayText);
      await HomeWidget.saveWidgetData<String>('cycle_phase', phase);
      await HomeWidget.saveWidgetData<String>('next_period', nextPeriod);
      await HomeWidget.updateWidget(androidName: _androidProvider);
    } catch (_) {}
  }
}
