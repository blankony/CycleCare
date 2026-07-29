import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';

class LocalNotificationService implements NotificationService {
  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<void> initialize() async {
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
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
  Future<void> cancelAll() => _plugin.cancelAll();

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
            'cyclecare_reminders', 'Pengingat CycleCare',
            importance: Importance.defaultImportance),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
