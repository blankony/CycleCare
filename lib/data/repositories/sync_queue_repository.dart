import 'package:drift/drift.dart';

import '../../data/local/database.dart';

class SyncQueueRepository {
  const SyncQueueRepository(this.database);

  final AppDatabase database;

  Future<int> get pendingCount async =>
      (database.select(database.syncQueue)).get().then((rows) => rows.length);

  Future<void> markFailure(String id, Object error) async {
    final item = await (database.select(database.syncQueue)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (item == null) return;
    await (database.update(database.syncQueue)
          ..where((table) => table.id.equals(id)))
        .write(
      SyncQueueCompanion(
        attemptCount: Value(item.attemptCount + 1),
        lastError: Value('$error'),
        updatedAt: Value(DateTime.now().toUtc().toIso8601String()),
      ),
    );
  }
}
