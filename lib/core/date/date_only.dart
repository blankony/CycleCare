import 'package:intl/intl.dart';

class DateOnly {
  const DateOnly._();

  static DateTime normalize(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static String format(DateTime value) =>
      DateFormat('yyyy-MM-dd').format(normalize(value));

  static DateTime parse(String value) {
    final parts = value.split('-');
    if (parts.length != 3) throw const FormatException('Invalid date');
    return DateTime(
        int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  static int differenceInDays(DateTime later, DateTime earlier) =>
      normalize(later).difference(normalize(earlier)).inDays;

  static String _resolveLocale(String? locale) {
    final loc = locale ?? Intl.getCurrentLocale();
    if (loc.startsWith('id')) return 'id_ID';
    return 'en';
  }

  static String display(DateTime value, [String? locale]) =>
      DateFormat('d MMMM yyyy', _resolveLocale(locale))
          .format(normalize(value));
}
