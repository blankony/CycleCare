import 'package:flutter_test/flutter_test.dart';

import 'package:cycle_care/data/local/database.dart';
import 'package:cycle_care/data/repositories/period_day_log_repository.dart';

void main() {
  late AppDatabase database;
  late DriftPeriodDayLogRepository repository;

  setUp(() {
    database = AppDatabase.memory();
    repository = DriftPeriodDayLogRepository(database, userId: 'user-a');
  });

  tearDown(() => database.close());

  test('upserts one flow log per period day and soft deletes it', () async {
    await repository.save(
      periodEntryId: 'period-a',
      logDate: DateTime(2026, 7, 30),
      flow: 'LIGHT',
    );
    await repository.save(
      periodEntryId: 'period-a',
      logDate: DateTime(2026, 7, 30),
      flow: 'HEAVY',
    );

    final logs = await repository.getForPeriod('period-a');
    expect(logs, hasLength(1));
    expect(logs.single.flow, 'HEAVY');

    await repository.softDelete(logs.single.id);
    expect(await repository.getForPeriod('period-a'), isEmpty);
    expect((await database.select(database.syncQueue).get()), hasLength(1));
  });
}
