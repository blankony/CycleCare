import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum BootstrapPhase {
  loadingConfiguration,
  configurationMissing,
  initializationFailed,
  supabaseInitialized,
  restoringSession,
  ready,
}

typedef BootstrapConfigurationLoader = Future<void> Function();
typedef BootstrapSupabaseInitializer = Future<SupabaseClient> Function(
    String url, String anonKey);

class BootstrapController extends ChangeNotifier {
  BootstrapController({
    BootstrapConfigurationLoader? loadConfiguration,
    BootstrapSupabaseInitializer? initializeSupabase,
  })  : _loadConfiguration = loadConfiguration ?? _loadDotenv,
        _initializeSupabase = initializeSupabase ?? _initializeDefaultSupabase;

  final BootstrapConfigurationLoader _loadConfiguration;
  final BootstrapSupabaseInitializer _initializeSupabase;

  BootstrapPhase phase = BootstrapPhase.loadingConfiguration;
  SupabaseClient? client;
  Object? error;

  bool get isReady => phase == BootstrapPhase.ready && client != null;

  Future<void> start() async {
    phase = BootstrapPhase.loadingConfiguration;
    client = null;
    error = null;
    notifyListeners();

    try {
      await _loadConfiguration();
    } catch (loadError) {
      phase = BootstrapPhase.configurationMissing;
      error = loadError;
      notifyListeners();
      return;
    }

    final url = dotenv.env['SUPABASE_URL']?.trim() ?? '';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY']?.trim() ?? '';
    if (url.isEmpty || anonKey.isEmpty) {
      phase = BootstrapPhase.configurationMissing;
      notifyListeners();
      return;
    }

    try {
      client = await _initializeSupabase(url, anonKey);
      phase = BootstrapPhase.supabaseInitialized;
      notifyListeners();
      phase = BootstrapPhase.restoringSession;
      notifyListeners();
      await Future<void>.delayed(Duration.zero);
      phase = BootstrapPhase.ready;
      notifyListeners();
    } catch (initializationError) {
      phase = BootstrapPhase.initializationFailed;
      error = initializationError;
      notifyListeners();
    }
  }

  static Future<void> _loadDotenv() => dotenv.load(fileName: '.env');

  static Future<SupabaseClient> _initializeDefaultSupabase(
      String url, String anonKey) async {
    await Supabase.initialize(url: url, publishableKey: anonKey);
    return Supabase.instance.client;
  }
}
