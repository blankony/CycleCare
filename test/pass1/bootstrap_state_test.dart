import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cycle_care/app/bootstrap_state.dart';
import 'package:cycle_care/app/providers.dart';
import 'package:cycle_care/data/local/database.dart';

void main() {
  test('missing configuration produces an explicit error state', () async {
    dotenv.testLoad(fileInput: 'SUPABASE_URL=\nSUPABASE_ANON_KEY=\n');
    final controller = BootstrapController(loadConfiguration: () async {});
    await controller.start();

    expect(controller.phase, BootstrapPhase.configurationMissing);
    expect(controller.client, isNull);
  });

  test('initialization failures do not open the tracker', () async {
    dotenv.testLoad(
        fileInput: 'SUPABASE_URL=https://example.supabase.co\nSUPABASE_ANON_KEY=anon\n');
    final controller = BootstrapController(
      loadConfiguration: () async {},
      initializeSupabase: (_, __) async => throw StateError('invalid key'),
    );
    await controller.start();

    expect(controller.phase, BootstrapPhase.initializationFailed);
    expect(controller.isReady, isFalse);
  });

  test('successful bootstrap exposes a required client', () async {
    dotenv.testLoad(
        fileInput: 'SUPABASE_URL=https://example.supabase.co\nSUPABASE_ANON_KEY=anon\n');
    final client = SupabaseClient('https://example.supabase.co', 'anon');
    final controller = BootstrapController(
      loadConfiguration: () async {},
      initializeSupabase: (_, __) async => client,
    );
    await controller.start();

    expect(controller.phase, BootstrapPhase.ready);
    expect(controller.client, same(client));

    final database = AppDatabase.memory();
    final container = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(database),
      supabaseClientProvider.overrideWithValue(client),
    ]);
    expect(container.read(authRepositoryProvider), isNotNull);
    container.dispose();
    await database.close();
  });
}
