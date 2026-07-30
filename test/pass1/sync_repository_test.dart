import 'package:flutter_test/flutter_test.dart';

import 'package:cycle_care/data/local/database.dart';
import 'package:cycle_care/data/repositories/period_day_log_repository.dart';
import 'package:cycle_care/data/repositories/period_repository.dart';
import 'package:cycle_care/data/repositories/sync_repository.dart';

class _FakeRemote implements SyncRemoteDataSource {
  _FakeRemote(this.currentUserId);

  @override
  final String? currentUserId;
  final tables = <String, List<Map<String, dynamic>>>{};

  @override
  Future<void> upsert(String table, Map<String, dynamic> payload) async {
    final rows = tables.putIfAbsent(table, () => []);
    final identity = table == 'user_cycle_settings' ? 'user_id' : 'id';
    final index = rows.indexWhere((row) => row[identity] == payload[identity]);
    final value = Map<String, dynamic>.from(payload);
    if (index < 0) {
      rows.add(value);
    } else {
      rows[index] = value;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> selectOwned(
      String table, String userId) async {
    return (tables[table] ?? const [])
        .where((row) => row['user_id'] == userId)
        .map(Map<String, dynamic>.from)
        .toList();
  }

  @override
  Future<Map<String, dynamic>?> selectOwnedSingle(
      String table, String userId) async {
    final rows = await selectOwned(table, userId);
    return rows.isEmpty ? null : rows.single;
  }
}

Map<String, dynamic> _remotePeriod({
  required String id,
  required String userId,
  required String startDate,
  required String updatedAt,
  String? notes,
  String? deletedAt,
}) =>
    {
      'id': id,
      'user_id': userId,
      'start_date': startDate,
      'end_date': null,
      'cycle_length_days': null,
      'period_duration_days': null,
      'predicted_start_at_entry': null,
      'window_start_at_entry': null,
      'window_end_at_entry': null,
      'variance_days': null,
      'classification': null,
      'notes': notes,
      'created_at': updatedAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'version': 1,
      'prediction_confidence_at_entry': null,
      'prediction_model_version_at_entry': null,
      'prediction_sample_size_at_entry': null,
      'prediction_snapshot_at': null,
    };

void main() {
  late AppDatabase database;
  late _FakeRemote remote;
  late SupabaseSyncRepository syncRepository;
  late DriftPeriodRepository periodRepository;

  setUp(() {
    database = AppDatabase.memory();
    remote = _FakeRemote('user-a');
    syncRepository = SupabaseSyncRepository.withRemote(database, remote);
    periodRepository = DriftPeriodRepository(database, userId: 'user-a');
  });

  tearDown(() => database.close());

  test('pushes one deduplicated pending period mutation', () async {
    await periodRepository.createPeriod(startDate: DateTime(2026, 1, 1));
    final record = (await periodRepository.getActivePeriods()).single;
    await periodRepository.updatePeriod(
        record: record.copyWith(notes: 'catatan terbaru'));

    final result = await syncRepository.synchronize();

    expect(result.failed, 0);
    expect(remote.tables['period_entries'], hasLength(1));
    expect(remote.tables['period_entries']!.single['notes'], 'catatan terbaru');
    expect(await database.select(database.syncQueue).get(), isEmpty);
  });

  test('pulls only rows owned by the authenticated user', () async {
    remote.tables['period_entries'] = [
      _remotePeriod(
        id: 'owned',
        userId: 'user-a',
        startDate: '2026-01-01',
        updatedAt: '2026-01-01T00:00:00Z',
      ),
      _remotePeriod(
        id: 'other',
        userId: 'user-b',
        startDate: '2026-02-01',
        updatedAt: '2026-02-01T00:00:00Z',
      ),
    ];

    await syncRepository.synchronize();

    final rows = await database.select(database.periodEntries).get();
    expect(rows.map((row) => row.id), ['owned']);
  });

  test('synchronizes soft deletion and daily flow foundations', () async {
    await periodRepository.createPeriod(startDate: DateTime(2026, 1, 1));
    final period = (await periodRepository.getActivePeriods()).single;
    await syncRepository.synchronize();

    final flowRepository =
        DriftPeriodDayLogRepository(database, userId: 'user-a');
    await flowRepository.save(
      periodEntryId: period.id,
      logDate: DateTime(2026, 1, 1),
      flow: 'MEDIUM',
    );
    await syncRepository.synchronize();
    expect(remote.tables['period_day_logs'], hasLength(1));

    await periodRepository.softDeletePeriod(period.id);
    await syncRepository.synchronize();
    expect(remote.tables['period_entries']!.single['deleted_at'], isNotNull);
  });

  test('pending local edits are pushed before remote conflict merging', () async {
    await periodRepository.createPeriod(startDate: DateTime(2026, 1, 1));
    await syncRepository.synchronize();
    final record = (await periodRepository.getActivePeriods()).single;
    remote.tables['period_entries'] = [
      _remotePeriod(
        id: record.id,
        userId: 'user-a',
        startDate: '2026-01-01',
        updatedAt: '2099-01-01T00:00:00Z',
        notes: 'remote',
      ),
    ];
    await periodRepository.updatePeriod(record: record.copyWith(notes: 'local'));

    await syncRepository.synchronize();

    expect((await periodRepository.getPeriodById(record.id))!.notes, 'local');
    expect(remote.tables['period_entries']!.single['notes'], 'local');
  });
}
