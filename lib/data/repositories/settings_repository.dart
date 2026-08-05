import 'package:drift/drift.dart';

import '../local/database.dart';

abstract interface class SettingsRepository {
  Future<void> set(String key, String value);
}

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this.database);

  final AppDatabase database;

  @override
  Future<void> set(String key, String value) async {
    await database.into(database.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: key,
            value: Value(value),
            updatedAt: DateTime.now().toUtc().toIso8601String(),
          ),
        );
  }
}
