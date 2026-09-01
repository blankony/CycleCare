import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'daily_period_checkin_messages.dart';
import 'notification_service.dart';

class LocalNotificationService implements NotificationService {
  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const _predictionChannelId = 'cyclecare_reminders';
  static const _predictionChannelName = 'CycleCare Reminders';
  static const _dailyChannelId = 'period_daily_mood';
  static const _dailyChannelName = 'Daily Period Check-in';
  static const _pillChannelId = 'cyclecare_pill';
  static const _pillChannelName = 'Pill Reminder';
  static const _dailyCheckinId = 2001;
  static const _headsUpId = 2002;
  static const _ovulationId = 2003;
  static const _pillId = 2004;

  @override
  Future<void> initialize() async {
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _dailyChannelId,
        _dailyChannelName,
        description: 'Daily 6 AM check-in while your period is ongoing.',
        importance: Importance.high,
      ),
    );
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _pillChannelId,
        _pillChannelName,
        description: 'Daily pill / supplement reminder.',
        importance: Importance.high,
      ),
    );
  }

  @override
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final androidResult = await android?.requestNotificationsPermission();
    final iosResult =
        await ios?.requestPermissions(alert: true, badge: true, sound: true);
    return androidResult ?? iosResult ?? false;
  }

  @override
  Future<bool> hasRequestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final androidGranted = await android?.areNotificationsEnabled();
    if (androidGranted != null) return androidGranted;
    final iosSettings = await ios?.checkPermissions();
    if (iosSettings != null) return iosSettings.isEnabled;
    return false;
  }

  @override
  Future<void> schedulePredictionReminders(
      {required DateTime windowStart, required DateTime predictedStart}) async {
    await _plugin.cancel(1001);
    await _plugin.cancel(1002);
    final start = tz.TZDateTime.from(windowStart, tz.local);
    final threeDaysBefore = start.subtract(const Duration(days: 3));
    await _schedule(1001, threeDaysBefore, 'Pengingat CycleCare',
        'Rentang perkiraan period akan segera dimulai.');
    await _schedule(1002, start, 'Pengingat CycleCare',
        'Hari pertama rentang perkiraan period.');
  }

  @override
  Future<void> scheduleEndReminder({required DateTime startDate}) async {
    await _plugin.cancel(1003);
    final date =
        tz.TZDateTime.from(startDate.add(const Duration(days: 5)), tz.local);
    await _schedule(1003, date, 'Pengingat CycleCare',
        'Jika sudah selesai, kamu dapat menambahkan tanggal akhir period.');
  }

  @override
  Future<void> scheduleDailyPeriodCheckin(
      {required String localeCode,
      required int hour,
      required int minute}) async {
    await _plugin.cancel(_dailyCheckinId);
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    final dayOfYear = _dayOfYear(scheduled);
    final title = DailyPeriodCheckinMessages.title(localeCode);
    final body = DailyPeriodCheckinMessages.body(localeCode, dayOfYear);
    await _plugin.zonedSchedule(
      _dailyCheckinId,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _dailyChannelId,
          _dailyChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelDailyPeriodCheckin() => _plugin.cancel(_dailyCheckinId);

  @override
  Future<void> schedulePeriodHeadsUp({
    required DateTime predictedStart,
    required int hour,
    required int minute,
    required String localeCode,
  }) async {
    await _plugin.cancel(_headsUpId);
    final target = predictedStart.subtract(const Duration(days: 2));
    final when = _atCustomTime(target, hour, minute);
    final isId = localeCode == 'id';
    await _plugin.zonedSchedule(
      _headsUpId,
      isId ? 'Heads-up: Period akan datang \u{1F338}' : 'Heads-up: Your period is coming \u{1F338}',
      isId
          ? 'Period diperkirakan 2 hari lagi. Siapkan yang kamu butuhkan.'
          : 'Your period is expected in 2 days. Get anything you need ready.',
      when,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _predictionChannelId,
          _predictionChannelName,
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancelPeriodHeadsUp() => _plugin.cancel(_headsUpId);

  @override
  Future<void> scheduleOvulationReminder({
    required DateTime ovulationDate,
    required int hour,
    required int minute,
    required String localeCode,
  }) async {
    await _plugin.cancel(_ovulationId);
    final when = _atCustomTime(ovulationDate, hour, minute);
    final isId = localeCode == 'id';
    await _plugin.zonedSchedule(
      _ovulationId,
      isId ? 'Hari ovulasi \u{1F95A}' : 'Ovulation day \u{1F95A}',
      isId
          ? 'Hari ini diperkirakan hari ovulasi. Estimasi ini bukan panduan kontrasepsi.'
          : 'Today is your estimated ovulation day. This is not contraception guidance.',
      when,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _predictionChannelId,
          _predictionChannelName,
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancelOvulationReminder() => _plugin.cancel(_ovulationId);

  @override
  Future<void> schedulePillReminder({
    required int hour,
    required int minute,
    required String localeCode,
  }) async {
    await _plugin.cancel(_pillId);
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (when.isBefore(now)) when = when.add(const Duration(days: 1));
    final isId = localeCode == 'id';
    await _plugin.zonedSchedule(
      _pillId,
      isId ? 'Pengingat pil / suplemen \u{1F48A}' : 'Pill / supplement reminder \u{1F48A}',
      isId
          ? 'Waktunya minum pil atau suplemen harianmu.'
          : 'Time to take your daily pill or supplement.',
      when,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _pillChannelId,
          _pillChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelPillReminder() => _plugin.cancel(_pillId);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  tz.TZDateTime _atCustomTime(DateTime date, int hour, int minute) {
    return tz.TZDateTime(tz.local, date.year, date.month, date.day, hour, minute);
  }

  Future<void> _schedule(
      int id, tz.TZDateTime date, String title, String body) async {
    if (date.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      date,
      const NotificationDetails(
        android: AndroidNotificationDetails(
            _predictionChannelId, _predictionChannelName,
            importance: Importance.defaultImportance),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  int _dayOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    return date.difference(start).inDays;
  }
}
