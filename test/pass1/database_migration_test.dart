import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cycle_care/data/local/database.dart';

void main() {
  test('version 1 records survive the version 2 migration', () async {
    final executor = NativeDatabase.memory(setup: (rawDatabase) {
      rawDatabase.execute('''
        CREATE TABLE period_entries (
          id TEXT NOT NULL PRIMARY KEY,
          start_date TEXT NOT NULL,
          end_date TEXT,
          cycle_length_days INTEGER,
          period_duration_days INTEGER,
          predicted_start_at_entry TEXT,
          window_start_at_entry TEXT,
          window_end_at_entry TEXT,
          variance_days INTEGER,
          classification TEXT,
          notes TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          deleted_at TEXT,
          sync_status TEXT NOT NULL DEFAULT 'pending',
          remote_updated_at TEXT
        )
      ''');
      rawDatabase.execute('''
        CREATE TABLE predictions (
          id TEXT NOT NULL PRIMARY KEY,
          generated_at TEXT NOT NULL,
          predicted_start TEXT NOT NULL,
          window_start TEXT NOT NULL,
          window_end TEXT NOT NULL,
          baseline_cycle_days INTEGER NOT NULL,
          variability_days INTEGER NOT NULL,
          confidence TEXT NOT NULL,
          based_on_cycles INTEGER NOT NULL,
          model_version TEXT NOT NULL
        )
      ''');
      rawDatabase.execute('''
        CREATE TABLE app_settings (
          key TEXT NOT NULL PRIMARY KEY,
          value TEXT,
          updated_at TEXT NOT NULL
        )
      ''');
      rawDatabase.execute('''
        CREATE TABLE sync_queue (
          id TEXT NOT NULL PRIMARY KEY,
          entity_type TEXT NOT NULL,
          entity_id TEXT NOT NULL,
          operation TEXT NOT NULL,
          payload TEXT NOT NULL,
          attempt_count INTEGER NOT NULL DEFAULT 0,
          last_error TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
      rawDatabase.execute('''
        INSERT INTO period_entries
          (id, start_date, created_at, updated_at, sync_status)
        VALUES ('legacy-period', '2026-01-01',
          '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'pending')
      ''');
      rawDatabase.execute('PRAGMA user_version = 1');
    });
    final database = AppDatabase(executor);

    final periods = await database.select(database.periodEntries).get();
    expect(database.schemaVersion, 2);
    expect(periods.single.id, 'legacy-period');
    expect(periods.single.userId, isNull);
    expect(await database.hasUnassignedLocalData(), isTrue);
    expect(await database.select(database.periodDayLogs).get(), isEmpty);

    await database.close();
  });
}
