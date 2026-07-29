import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

import 'app/app.dart';
import 'app/providers.dart';
import 'core/config/app_environment.dart';
import 'data/local/database.dart';
import 'domain/services/local_notification_service.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  timezone.initializeTimeZones();
  timezone.setLocalLocation(timezone.getLocation('Asia/Jakarta'));

  final database = await AppDatabase.open();
  try {
    await LocalNotificationService().initialize();
  } catch (_) {}

  SupabaseClient? client;
  if (AppEnvironment.hasSupabaseConfiguration) {
    try {
      await Supabase.initialize(
        url: AppEnvironment.supabaseUrl,
        publishableKey: AppEnvironment.supabaseAnonKey,
      );
      client = Supabase.instance.client;
    } catch (_) {
      client = null;
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        supabaseClientProvider.overrideWithValue(client),
      ],
      child: const CycleCareApp(),
    ),
  );
}
