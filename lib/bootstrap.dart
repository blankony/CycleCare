import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

import 'app/app.dart';
import 'app/bootstrap_state.dart';
import 'app/theme.dart';
import 'app/providers.dart';
import 'data/local/database.dart';
import 'domain/services/local_notification_service.dart';
import 'l10n/app_localizations.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en');
  await initializeDateFormatting('id_ID');
  Intl.defaultLocale = 'en';
  timezone.initializeTimeZones();
  timezone.setLocalLocation(timezone.getLocation('Asia/Jakarta'));

  final database = await AppDatabase.open();
  try {
    await LocalNotificationService().initialize();
  } catch (_) {}

  runApp(
    CycleCareBootstrap(database: database),
  );
}

class CycleCareBootstrap extends StatefulWidget {
  const CycleCareBootstrap({required this.database, super.key});

  final AppDatabase database;

  @override
  State<CycleCareBootstrap> createState() => _CycleCareBootstrapState();
}

class _CycleCareBootstrapState extends State<CycleCareBootstrap> {
  late final BootstrapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BootstrapController()..addListener(_onChanged);
    _controller.start();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (!_controller.isReady) {
      return _BootstrapStatusApp(
        phase: _controller.phase,
        error: _controller.error,
        onRetry: _controller.start,
      );
    }
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(widget.database),
        supabaseClientProvider.overrideWithValue(_controller.client!),
      ],
      child: const CycleCareApp(),
    );
  }
}

class _BootstrapStatusApp extends StatelessWidget {
  const _BootstrapStatusApp({
    required this.phase,
    required this.onRetry,
    this.error,
  });

  final BootstrapPhase phase;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isConfigurationError = phase == BootstrapPhase.configurationMissing;
    return MaterialApp(
      title: 'CycleCare',
      theme: CycleCareTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          final title = isConfigurationError
              ? 'Supabase configuration not available'
              : phase == BootstrapPhase.initializationFailed
                  ? 'Supabase initialization failed'
                  : l10n.loadingPreparingCycle;
          final message = isConfigurationError
              ? 'Copy .env.example to .env and fill SUPABASE_URL and SUPABASE_ANON_KEY.'
              : phase == BootstrapPhase.initializationFailed
                  ? 'Check Supabase URL and anon key, then try again.'
                  : phase == BootstrapPhase.restoringSession
                      ? 'Restoring account session securely.'
                      : 'Loading app configuration.';
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isConfigurationError ? Icons.cloud_off : Icons.sync,
                      size: 56,
                    ),
                    const SizedBox(height: 16),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Text(message, textAlign: TextAlign.center),
                    if (error != null && !isConfigurationError) ...[
                      const SizedBox(height: 8),
                      Text('Detail: ${error.runtimeType}',
                          textAlign: TextAlign.center),
                    ],
                    if (phase == BootstrapPhase.loadingConfiguration ||
                        phase == BootstrapPhase.supabaseInitialized ||
                        phase == BootstrapPhase.restoringSession) ...[
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(),
                    ] else ...[
                      const SizedBox(height: 20),
                      FilledButton(
                          onPressed: onRetry, child: Text(l10n.commonRetry)),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
