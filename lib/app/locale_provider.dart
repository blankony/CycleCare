import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

final appLocaleProvider = Provider<Locale>((ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  final code = settings?['app_locale'];
  if (code == 'id') return const Locale('id');
  return const Locale('en');
});

final appLocaleCodeProvider = Provider<String>((ref) {
  final locale = ref.watch(appLocaleProvider);
  return locale.languageCode;
});

class LocaleController {
  const LocaleController(this.ref);
  final Ref ref;

  Future<void> setLocale(String code) async {
    final normalized = code == 'id' ? 'id' : 'en';
    await ref.read(settingsRepositoryProvider).set('app_locale', normalized);
    ref.invalidate(settingsProvider);
    try {
      final service = ref.read(notificationServiceProvider);
      final db = ref.read(databaseProvider);
      final rows = await db.select(db.appSettings).get();
      final enabled =
          rows.where((r) => r.key == 'daily_checkin_enabled').firstOrNull?.value !=
              'false';
      if (!enabled) return;
      final periodRepo = ref.read(periodRepositoryProvider);
      final active = await periodRepo.getActiveUnfinishedPeriod();
      if (active == null) return;
      await service.scheduleDailyPeriodCheckin(localeCode: normalized);
    } catch (_) {}
  }
}

final localeControllerProvider = Provider<LocaleController>((ref) {
  return LocaleController(ref);
});
