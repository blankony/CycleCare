import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/date/date_only.dart';
import '../../../core/errors/app_failure.dart';
import '../../../data/repositories/period_repository.dart';
import '../../../data/repositories/period_day_log_repository.dart';
import '../../../domain/entities/enums.dart';
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

  Future<void> saveForm({
    required DateTime startDate,
    required DateTime? endDate,
    required String? notes,
    required Map<DateTime, MenstrualFlow?> flowChanges,
    PeriodRecord? record,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      PeriodRecord savedRecord;
      if (record == null) {
        await repository.createPeriod(startDate: startDate, notes: notes);
        final normalizedStart = DateOnly.normalize(startDate);
        final records = await repository.getActivePeriods();
        savedRecord = records.firstWhere(
          (item) => DateOnly.normalize(item.startDate) == normalizedStart,
          orElse: () => throw const AppFailure(
            'Catatan yang baru disimpan belum dapat ditemukan.',
          ),
        );
        if (endDate != null) {
          savedRecord = savedRecord.copyWith(endDate: endDate);
          await repository.updatePeriod(record: savedRecord);
        }
      } else {
        savedRecord = record.copyWith(
          startDate: startDate,
          endDate: endDate,
          clearEndDate: endDate == null,
          notes: notes,
        );
        await repository.updatePeriod(record: savedRecord);
        await flowRepository.softDeleteOutsideRange(
          periodEntryId: savedRecord.id,
          startDate: startDate,
          endDate: endDate,
        );
      }

      final rangeEnd = DateOnly.normalize(endDate ?? DateTime.now());
      final existingLogs = await flowRepository.getForPeriod(savedRecord.id);
      for (final entry in flowChanges.entries) {
        final date = DateOnly.normalize(entry.key);
        if (date.isBefore(DateOnly.normalize(startDate)) ||
            date.isAfter(rangeEnd)) {
          continue;
        }
        final existing = existingLogs.where(
          (log) => DateOnly.normalize(log.logDate) == date,
        );
        if (entry.value == null) {
          for (final log in existing) {
            await flowRepository.softDelete(log.id);
          }
        } else {
          await flowRepository.save(
            periodEntryId: savedRecord.id,
            logDate: date,
            flow: entry.value!.value,
          );
        }
      }

      await _recalculateAndNotify(
        reminderStartDate: record == null && endDate == null ? startDate : null,
      );
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
    try {
      await notifications.cancelAll();
    } catch (_) {}
    if (prediction.ready) {
      try {
        await notifications.schedulePredictionReminders(
          windowStart: prediction.windowStart!,
          predictedStart: prediction.predictedStart!,
        );
      } catch (_) {}
    }
    if (reminderStartDate != null) {
      try {
        await notifications.scheduleEndReminder(startDate: reminderStartDate);
      } catch (_) {}
    }
    try {
      await ref.read(reminderScheduleServiceProvider).rescheduleAll();
    } catch (_) {}
    try {
      final periods = await ref.read(activePeriodsProvider.future);
      final pred = await ref.read(predictionProvider.future);
      final insights = await ref.read(cycleInsightsProvider.future);
      final locale = ref.read(settingsProvider).valueOrNull?['app_locale'] ?? 'en';
      await ref.read(homeWidgetServiceProvider).update(
            periods: periods,
            prediction: pred,
            fertility: insights.fertility,
            status: insights.status,
            localeCode: locale,
          );
    } catch (_) {}
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
