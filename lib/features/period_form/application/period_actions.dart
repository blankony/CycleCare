import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_failure.dart';
import '../../../data/repositories/period_repository.dart';
import '../../../data/repositories/period_day_log_repository.dart';
import '../../../domain/entities/period_record.dart';
import '../../../domain/services/notification_service.dart';
import '../../../domain/services/period_recalculation_service.dart';

class PeriodActionsController extends AsyncNotifier<void> {
  late final PeriodRepository repository = ref.read(periodRepositoryProvider);
  late final PeriodDayLogRepository flowRepository =
      ref.read(periodDayLogRepositoryProvider);
  late final PeriodRecalculationService recalculation =
      ref.read(recalculationServiceProvider);
  late final NotificationService notifications =
      ref.read(notificationServiceProvider);

  @override
  Future<void> build() async {}

  Future<void> create({required DateTime startDate, String? notes}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.createPeriod(startDate: startDate, notes: notes);
      await _recalculateAndNotify(reminderStartDate: startDate);
      _invalidateData();
      await _syncBestEffort();
    });
  }

  Future<void> finishToday() async {
    final record = await repository.getActiveUnfinishedPeriod();
    if (record == null) {
      throw const ValidationFailure(
          'Tidak ada period yang sedang berlangsung.');
    }
    await finish(record.id, DateTime.now());
  }

  Future<void> finish(String id, DateTime endDate) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updatePeriodEnd(id: id, endDate: endDate);
      await _recalculateAndNotify();
      _invalidateData();
      await _syncBestEffort();
    });
  }

  Future<void> updateRecord({required PeriodRecord record}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updatePeriod(record: record);
      await _recalculateAndNotify();
      _invalidateData();
      await _syncBestEffort();
    });
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.softDeletePeriod(id);
      await _recalculateAndNotify();
      _invalidateData();
      await _syncBestEffort();
    });
  }

  Future<void> restore(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.restorePeriod(id);
      await _recalculateAndNotify();
      _invalidateData();
      await _syncBestEffort();
    });
  }

  Future<void> saveFlow({
    required String periodEntryId,
    required DateTime logDate,
    required String flow,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await flowRepository.save(
        periodEntryId: periodEntryId,
        logDate: logDate,
        flow: flow,
      );
      _invalidateData();
      await _syncBestEffort();
    });
  }

  Future<void> clearFlow(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await flowRepository.softDelete(id);
      _invalidateData();
      await _syncBestEffort();
    });
  }

  Future<void> clearFlowsOutsideRange({
    required String periodEntryId,
    required DateTime startDate,
    required DateTime? endDate,
  }) async {
    await flowRepository.softDeleteOutsideRange(
      periodEntryId: periodEntryId,
      startDate: startDate,
      endDate: endDate,
    );
    _invalidateData();
  }

  Future<void> _recalculateAndNotify({DateTime? reminderStartDate}) async {
    final prediction = await recalculation.recalculate();
    await notifications.cancelAll();
    if (prediction.ready) {
      await notifications.schedulePredictionReminders(
        windowStart: prediction.windowStart!,
        predictedStart: prediction.predictedStart!,
      );
    }
    if (reminderStartDate != null) {
      await notifications.scheduleEndReminder(startDate: reminderStartDate);
    }
  }

  void _invalidateData() {
    ref.invalidate(activePeriodsProvider);
    ref.invalidate(predictionProvider);
    ref.invalidate(deletedPeriodsProvider);
    ref.invalidate(flowLogsProvider);
    ref.invalidate(cycleStatisticsProvider);
    ref.invalidate(cycleInsightsProvider);
    ref.invalidate(endOfCycleSummaryProvider);
  }

  Future<void> _syncBestEffort() async {
    try {
      await ref.read(syncControllerProvider).synchronizeNow();
    } catch (_) {}
  }
}
