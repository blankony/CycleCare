import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

import 'app/app.dart';
import 'app/bootstrap_state.dart';
import 'app/theme.dart';
import 'app/providers.dart';
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
    final title = isConfigurationError
        ? 'Konfigurasi Supabase belum tersedia'
        : phase == BootstrapPhase.initializationFailed
            ? 'Supabase tidak dapat diinisialisasi'
            : 'Menyiapkan CycleCare';
    final message = isConfigurationError
        ? 'Salin .env.example menjadi .env, lalu isi SUPABASE_URL dan SUPABASE_ANON_KEY.'
        : phase == BootstrapPhase.initializationFailed
            ? 'Periksa URL dan publishable key Supabase, lalu coba lagi.'
            : phase == BootstrapPhase.restoringSession
                ? 'Memulihkan sesi akun dengan aman.'
                : 'Memuat konfigurasi aplikasi.';
    return MaterialApp(
      title: 'CycleCare',
      theme: CycleCareTheme.light(),
      home: Scaffold(
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
                      onPressed: onRetry, child: const Text('Coba lagi')),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
