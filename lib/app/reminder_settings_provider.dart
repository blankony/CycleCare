import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/reminder_settings.dart';
import 'providers.dart';

final reminderSettingsProvider =
    NotifierProvider<ReminderSettingsController, ReminderSettings>(
        ReminderSettingsController.new);

class ReminderSettingsController extends Notifier<ReminderSettings> {
  @override
  ReminderSettings build() {
    final m = ref.watch(settingsProvider).valueOrNull ?? const {};
    return ReminderSettings.fromMap(m);
  }

  TimeOfDay get reminderTime => state.reminderTime;
  TimeOfDay get pillReminderTime => state.pillReminderTime;

  Future<void> setReminderTime(TimeOfDay t) async {
    await ref.read(settingsRepositoryProvider).set(
        ReminderSettings.kReminderTime, ReminderSettings.formatHhMm(t));
    ref.invalidate(settingsProvider);
  }

  Future<void> setPillReminderTime(TimeOfDay t) async {
    await ref.read(settingsRepositoryProvider).set(
        ReminderSettings.kPillTime, ReminderSettings.formatHhMm(t));
    ref.invalidate(settingsProvider);
  }

  Future<void> _setBool(String key, bool value) async {
    await ref.read(settingsRepositoryProvider).set(key, value ? 'true' : 'false');
    ref.invalidate(settingsProvider);
  }

  Future<void> setDailyCheckinEnabled(bool v) =>
      _setBool(ReminderSettings.kDailyCheckinEnabled, v);
  Future<void> setHeadsUpEnabled(bool v) =>
      _setBool(ReminderSettings.kHeadsUpEnabled, v);
  Future<void> setOvulationReminderEnabled(bool v) =>
      _setBool(ReminderSettings.kOvulationReminderEnabled, v);
  Future<void> setPeriodReminderEnabled(bool v) =>
      _setBool(ReminderSettings.kPeriodReminderEnabled, v);
  Future<void> setPillReminderEnabled(bool v) =>
      _setBool(ReminderSettings.kPillReminderEnabled, v);
}
