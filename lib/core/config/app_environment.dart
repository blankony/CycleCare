import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@immutable
class AppEnvironment {
  const AppEnvironment._();

  static String get supabaseUrl => _value('SUPABASE_URL');
  static String get supabaseAnonKey => _value('SUPABASE_ANON_KEY');

  static String _value(String key) {
    if (!dotenv.isInitialized) return '';
    return dotenv.env[key]?.trim() ?? '';
  }

  static bool get hasSupabaseConfiguration =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;
}
