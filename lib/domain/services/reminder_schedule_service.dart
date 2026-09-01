import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../entities/reminder_settings.dart';

class ReminderScheduleService {
  ReminderScheduleService(this.ref);
  final Ref ref;

  Future<void> rescheduleAll() async {
    final service = ref.read(notificationServiceProvider);
    final locale = _localeCode();
    final settings = _settings();
    final predictedStart = (await ref.read(predictionProvider.future))?.predictedStart;
    final fertility = ref.read(fertilityEstimateProvider);
    final hasOngoing = await _hasOngoingPeriod();

    await service.cancelDailyPeriodCheckin();
    await service.cancelPeriodHeadsUp();
    await service.cancelOvulationReminder();
    await service.cancelPillReminder();

    if (settings.dailyCheckinEnabled && hasOngoing) {
      try {
        await service.scheduleDailyPeriodCheckin(
          localeCode: locale,
          hour: settings.reminderTime.hour,
          minute: settings.reminderTime.minute,
        );
      } catch (_) {}
    }
    if (settings.headsUpEnabled && predictedStart != null) {
      try {
        await service.schedulePeriodHeadsUp(
          predictedStart: predictedStart,
          hour: settings.reminderTime.hour,
          minute: settings.reminderTime.minute,
          localeCode: locale,
        );
      } catch (_) {}
    }
    if (settings.ovulationReminderEnabled && fertility != null) {
      try {
        await service.scheduleOvulationReminder(
          ovulationDate: fertility.ovulationCenter,
          hour: settings.reminderTime.hour,
          minute: settings.reminderTime.minute,
          localeCode: locale,
        );
      } catch (_) {}
    }
    if (settings.pillReminderEnabled) {
      try {
        await service.schedulePillReminder(
          hour: settings.pillReminderTime.hour,
          minute: settings.pillReminderTime.minute,
          localeCode: locale,
        );
      } catch (_) {}
    }
  }

  Future<void> reschedulePill() async {
    final service = ref.read(notificationServiceProvider);
    final settings = _settings();
    await service.cancelPillReminder();
    if (!settings.pillReminderEnabled) return;
    try {
      await service.schedulePillReminder(
        hour: settings.pillReminderTime.hour,
        minute: settings.pillReminderTime.minute,
        localeCode: _localeCode(),
      );
    } catch (_) {}
  }

  Future<void> rescheduleFromPrediction() async {
    final service = ref.read(notificationServiceProvider);
    final locale = _localeCode();
    final settings = _settings();
    final predictedStart = (await ref.read(predictionProvider.future))?.predictedStart;
    final fertility = ref.read(fertilityEstimateProvider);
    await service.cancelPeriodHeadsUp();
    await service.cancelOvulationReminder();
    if (settings.headsUpEnabled && predictedStart != null) {
      try {
        await service.schedulePeriodHeadsUp(
          predictedStart: predictedStart,
          hour: settings.reminderTime.hour,
          minute: settings.reminderTime.minute,
          localeCode: locale,
        );
      } catch (_) {}
    } else if (!settings.headsUpEnabled) {
      try { await service.cancelPeriodHeadsUp(); } catch (_) {}
    }
    if (settings.ovulationReminderEnabled && fertility != null) {
      try {
        await service.scheduleOvulationReminder(
          ovulationDate: fertility.ovulationCenter,
          hour: settings.reminderTime.hour,
          minute: settings.reminderTime.minute,
          localeCode: locale,
        );
      } catch (_) {}
    } else if (!settings.ovulationReminderEnabled) {
      try { await service.cancelOvulationReminder(); } catch (_) {}
    }
  }

  String _localeCode() {
    try {
      final m = ref.read(settingsProvider).valueOrNull ?? const {};
      return m['app_locale'] == 'id' ? 'id' : 'en';
    } catch (_) { return 'en'; }
  }

  ReminderSettings _settings() {
    try {
      final m = ref.read(settingsProvider).valueOrNull ?? const {};
      return ReminderSettings.fromMap(m);
    } catch (_) { return ReminderSettings.defaults(); }
  }

  Future<bool> _hasOngoingPeriod() async {
    try {
      return await ref.read(periodRepositoryProvider).getActiveUnfinishedPeriod() != null;
    } catch (_) { return false; }
  }
}
