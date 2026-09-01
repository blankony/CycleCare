import 'package:flutter/foundation.dart';

abstract interface class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<bool> hasRequestPermission();
  Future<void> schedulePredictionReminders(
      {required DateTime windowStart, required DateTime predictedStart});
  Future<void> scheduleEndReminder({required DateTime startDate});
  Future<void> scheduleDailyPeriodCheckin(
      {required String localeCode,
      required int hour,
      required int minute});
  Future<void> cancelDailyPeriodCheckin();
  Future<void> schedulePeriodHeadsUp({
    required DateTime predictedStart,
    required int hour,
    required int minute,
    required String localeCode,
  });
  Future<void> cancelPeriodHeadsUp();
  Future<void> scheduleOvulationReminder({
    required DateTime ovulationDate,
    required int hour,
    required int minute,
    required String localeCode,
  });
  Future<void> cancelOvulationReminder();
  Future<void> schedulePillReminder({
    required int hour,
    required int minute,
    required String localeCode,
  });
  Future<void> cancelPillReminder();
  Future<void> cancelAll();
}

class UnsupportedNotificationService implements NotificationService {
  const UnsupportedNotificationService();

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<bool> hasRequestPermission() async => false;

  @override
  Future<void> schedulePredictionReminders(
      {required DateTime windowStart,
      required DateTime predictedStart}) async {}

  @override
  Future<void> scheduleEndReminder({required DateTime startDate}) async {}

  @override
  Future<void> scheduleDailyPeriodCheckin(
          {required String localeCode,
          required int hour,
          required int minute}) async {}

  @override
  Future<void> cancelDailyPeriodCheckin() async {}

  @override
  Future<void> schedulePeriodHeadsUp({
    required DateTime predictedStart,
    required int hour,
    required int minute,
    required String localeCode,
  }) async {}

  @override
  Future<void> cancelPeriodHeadsUp() async {}

  @override
  Future<void> scheduleOvulationReminder({
    required DateTime ovulationDate,
    required int hour,
    required int minute,
    required String localeCode,
  }) async {}

  @override
  Future<void> cancelOvulationReminder() async {}

  @override
  Future<void> schedulePillReminder({
    required int hour,
    required int minute,
    required String localeCode,
  }) async {}

  @override
  Future<void> cancelPillReminder() async {}

  @override
  Future<void> cancelAll() async {}
}

bool get notificationsSupported => !kIsWeb;
