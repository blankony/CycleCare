import 'package:flutter_test/flutter_test.dart';

import 'package:cycle_care/core/errors/app_failure.dart';
import 'package:cycle_care/data/local/database.dart';
import 'package:cycle_care/data/repositories/period_repository.dart';

void main() {
  late AppDatabase database;
  late DriftPeriodRepository repository;
  final today = DateTime.now();
  final first = DateTime(today.year, today.month, today.day)
      .subtract(const Duration(days: 56));
  final second = DateTime(today.year, today.month, today.day)
      .subtract(const Duration(days: 28));

  setUp(() {
    database = AppDatabase.memory();
    repository = DriftPeriodRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('creates local records and rejects duplicate and future starts',
      () async {
    await repository.createPeriod(startDate: first, notes: '  catatan  ');
    expect((await repository.getActivePeriods()).single.notes, 'catatan');
    expect(() => repository.createPeriod(startDate: first),
        throwsA(isA<ValidationFailure>()));
    expect(
      () => repository.createPeriod(
          startDate: today.add(const Duration(days: 1))),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('validates end date and calculates duration', () async {
    await repository.createPeriod(startDate: first);
    final record = (await repository.getActivePeriods()).single;
    expect(
      () => repository.updatePeriodEnd(
          id: record.id, endDate: first.subtract(const Duration(days: 1))),
      throwsA(isA<ValidationFailure>()),
    );
    await repository.updatePeriodEnd(
        id: record.id, endDate: first.add(const Duration(days: 4)));
    expect((await repository.getPeriodById(record.id))!.periodDurationDays, 5);
  });

  test('calculates cycle length and supports soft delete and restore',
      () async {
    await repository.createPeriod(startDate: first);
    await repository.createPeriod(startDate: second);
    expect((await repository.getLatestPeriod())!.cycleLengthDays, 28);
    final latest = await repository.getLatestPeriod();
    await repository.softDeletePeriod(latest!.id);
    expect((await repository.getActivePeriods()).length, 1);
    expect((await repository.getDeletedPeriods()).length, 1);
    await repository.restorePeriod(latest.id);
    expect((await repository.getActivePeriods()).length, 2);
  });
}
