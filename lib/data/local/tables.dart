import 'package:drift/drift.dart';

class PeriodEntries extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
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
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get predictionConfidenceAtEntry => text().nullable()();
  TextColumn get predictionModelVersionAtEntry => text().nullable()();
  IntColumn get predictionSampleSizeAtEntry => integer().nullable()();
  TextColumn get predictionSnapshotAt => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Predictions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
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

class PeriodDayLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get periodEntryId => text()();
  TextColumn get logDate => text()();
  TextColumn get flow => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get remoteUpdatedAt => text().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {periodEntryId, logDate},
      ];
}

class UserCycleSettings extends Table {
  TextColumn get userId => text()();
  BoolColumn get showOvulationEstimate =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get showFertileWindow =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get lastSummaryPeriodId => text().nullable()();
  TextColumn get lastSuccessfulSyncAt => text().nullable()();
  BoolColumn get initialSyncCompleted =>
      boolean().withDefault(const Constant(false))();
  TextColumn get updatedAt => text()();
  TextColumn get remoteUpdatedAt => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {userId};
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
  TextColumn get userId => text().nullable()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
