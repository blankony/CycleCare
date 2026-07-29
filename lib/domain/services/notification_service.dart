import 'package:flutter/foundation.dart';

abstract interface class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<void> schedulePredictionReminders(
      {required DateTime windowStart, required DateTime predictedStart});
  Future<void> scheduleEndReminder({required DateTime startDate});
  Future<void> cancelAll();
}

class UnsupportedNotificationService implements NotificationService {
  const UnsupportedNotificationService();

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> schedulePredictionReminders(
      {required DateTime windowStart,
      required DateTime predictedStart}) async {}

  @override
  Future<void> scheduleEndReminder({required DateTime startDate}) async {}

  @override
  Future<void> cancelAll() async {}
}

bool get notificationsSupported => !kIsWeb;
