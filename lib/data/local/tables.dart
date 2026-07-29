import 'package:drift/drift.dart';

class PeriodEntries extends Table {
  TextColumn get id => text()();
  TextColumn get startDate => text()();
  TextColumn get endDate => text().nullable()();
  IntColumn get cycleLengthDays => integer().nullable()();
  IntColumn get periodDurationDays => integer().nullable()();
  TextColumn get predictedStartAtEntry => text().nullable()();
  TextColumn get windowStartAtEntry => text().nullable()();
  TextColumn get windowEndAtEntry => text().nullable()();
  IntColumn get varianceDays => integer().nullable()();
  TextColumn get classification => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get remoteUpdatedAt => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Predictions extends Table {
  TextColumn get id => text()();
  TextColumn get generatedAt => text()();
  TextColumn get predictedStart => text()();
  TextColumn get windowStart => text()();
  TextColumn get windowEnd => text()();
  IntColumn get baselineCycleDays => integer()();
  IntColumn get variabilityDays => integer()();
  TextColumn get confidence => text()();
  IntColumn get basedOnCycles => integer()();
  TextColumn get modelVersion => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
