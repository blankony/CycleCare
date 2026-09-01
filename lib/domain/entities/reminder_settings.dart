import 'package:flutter/material.dart';

class ReminderSettings {
  const ReminderSettings({
    required this.reminderTime,
    required this.dailyCheckinEnabled,
    required this.headsUpEnabled,
    required this.ovulationReminderEnabled,
    required this.periodReminderEnabled,
    required this.pillReminderEnabled,
    required this.pillReminderTime,
  });

  static const defaultReminderTime = TimeOfDay(hour: 6, minute: 0);
  static const defaultPillTime = TimeOfDay(hour: 20, minute: 0);

  static const kReminderTime = 'reminder_time_hhmm';
  static const kDailyCheckinEnabled = 'daily_checkin_enabled';
  static const kHeadsUpEnabled = 'heads_up_enabled';
  static const kOvulationReminderEnabled = 'ovulation_reminder_enabled';
  static const kPeriodReminderEnabled = 'period_reminder_enabled';
  static const kPillReminderEnabled = 'pill_reminder_enabled';
  static const kPillTime = 'pill_reminder_time_hhmm';
  static const kLegacyReminderEnabled = 'reminder_enabled';

  final TimeOfDay reminderTime;
  final bool dailyCheckinEnabled;
  final bool headsUpEnabled;
  final bool ovulationReminderEnabled;
  final bool periodReminderEnabled;
  final bool pillReminderEnabled;
  final TimeOfDay pillReminderTime;

  static ReminderSettings defaults() => const ReminderSettings(
        reminderTime: defaultReminderTime,
        dailyCheckinEnabled: true,
        headsUpEnabled: true,
        ovulationReminderEnabled: true,
        periodReminderEnabled: true,
        pillReminderEnabled: false,
        pillReminderTime: defaultPillTime,
      );

  static ReminderSettings fromMap(Map<String, String?> map) {
    TimeOfDay parse(String? raw, TimeOfDay fallback) {
      if (raw == null) return fallback;
      final parts = raw.split(':');
      if (parts.length != 2) return fallback;
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
        return fallback;
      }
      return TimeOfDay(hour: h, minute: m);
    }

    bool parseBool(String? raw, String legacyKey, bool fallback) {
      final v = map[raw == kPeriodReminderEnabled ? raw : raw];
      if (raw == kPeriodReminderEnabled && v == null) {
        final legacy = map[kLegacyReminderEnabled];
        if (legacy != null) return legacy == 'true';
      }
      if (v == null) return fallback;
      return v == 'true';
    }

    bool boolVal(String key, bool fallback) {
      final v = map[key];
      if (v == null) return fallback;
      return v == 'true';
    }

    return ReminderSettings(
      reminderTime: parse(map[kReminderTime], defaultReminderTime),
      dailyCheckinEnabled: boolVal(kDailyCheckinEnabled, true),
      headsUpEnabled: boolVal(kHeadsUpEnabled, true),
      ovulationReminderEnabled: boolVal(kOvulationReminderEnabled, true),
      periodReminderEnabled: parseBool(kPeriodReminderEnabled, kLegacyReminderEnabled, true),
      pillReminderEnabled: boolVal(kPillReminderEnabled, false),
      pillReminderTime: parse(map[kPillTime], defaultPillTime),
    );
  }

  static String formatHhMm(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
