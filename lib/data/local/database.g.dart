// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PeriodEntriesTable extends PeriodEntries
    with TableInfo<$PeriodEntriesTable, PeriodEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
      'start_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
      'end_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cycleLengthDaysMeta =
      const VerificationMeta('cycleLengthDays');
  @override
  late final GeneratedColumn<int> cycleLengthDays = GeneratedColumn<int>(
      'cycle_length_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _periodDurationDaysMeta =
      const VerificationMeta('periodDurationDays');
  @override
  late final GeneratedColumn<int> periodDurationDays = GeneratedColumn<int>(
      'period_duration_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _predictedStartAtEntryMeta =
      const VerificationMeta('predictedStartAtEntry');
  @override
  late final GeneratedColumn<String> predictedStartAtEntry =
      GeneratedColumn<String>('predicted_start_at_entry', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _windowStartAtEntryMeta =
      const VerificationMeta('windowStartAtEntry');
  @override
  late final GeneratedColumn<String> windowStartAtEntry =
      GeneratedColumn<String>('window_start_at_entry', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _windowEndAtEntryMeta =
      const VerificationMeta('windowEndAtEntry');
  @override
  late final GeneratedColumn<String> windowEndAtEntry = GeneratedColumn<String>(
      'window_end_at_entry', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _varianceDaysMeta =
      const VerificationMeta('varianceDays');
  @override
  late final GeneratedColumn<int> varianceDays = GeneratedColumn<int>(
      'variance_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _classificationMeta =
      const VerificationMeta('classification');
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
      'classification', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _remoteUpdatedAtMeta =
      const VerificationMeta('remoteUpdatedAt');
  @override
  late final GeneratedColumn<String> remoteUpdatedAt = GeneratedColumn<String>(
      'remote_updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _predictionConfidenceAtEntryMeta =
      const VerificationMeta('predictionConfidenceAtEntry');
  @override
  late final GeneratedColumn<String> predictionConfidenceAtEntry =
      GeneratedColumn<String>(
          'prediction_confidence_at_entry', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _predictionModelVersionAtEntryMeta =
      const VerificationMeta('predictionModelVersionAtEntry');
  @override
  late final GeneratedColumn<String> predictionModelVersionAtEntry =
      GeneratedColumn<String>(
          'prediction_model_version_at_entry', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _predictionSampleSizeAtEntryMeta =
      const VerificationMeta('predictionSampleSizeAtEntry');
  @override
  late final GeneratedColumn<int> predictionSampleSizeAtEntry =
      GeneratedColumn<int>('prediction_sample_size_at_entry', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _predictionSnapshotAtMeta =
      const VerificationMeta('predictionSnapshotAt');
  @override
  late final GeneratedColumn<String> predictionSnapshotAt =
      GeneratedColumn<String>('prediction_snapshot_at', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        startDate,
        endDate,
        cycleLengthDays,
        periodDurationDays,
        predictedStartAtEntry,
        windowStartAtEntry,
        windowEndAtEntry,
        varianceDays,
        classification,
        notes,
        createdAt,
        updatedAt,
        deletedAt,
        syncStatus,
        remoteUpdatedAt,
        version,
        predictionConfidenceAtEntry,
        predictionModelVersionAtEntry,
        predictionSampleSizeAtEntry,
        predictionSnapshotAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'period_entries';
  @override
  VerificationContext validateIntegrity(Insertable<PeriodEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('cycle_length_days')) {
      context.handle(
          _cycleLengthDaysMeta,
          cycleLengthDays.isAcceptableOrUnknown(
              data['cycle_length_days']!, _cycleLengthDaysMeta));
    }
    if (data.containsKey('period_duration_days')) {
      context.handle(
          _periodDurationDaysMeta,
          periodDurationDays.isAcceptableOrUnknown(
              data['period_duration_days']!, _periodDurationDaysMeta));
    }
    if (data.containsKey('predicted_start_at_entry')) {
      context.handle(
          _predictedStartAtEntryMeta,
          predictedStartAtEntry.isAcceptableOrUnknown(
              data['predicted_start_at_entry']!, _predictedStartAtEntryMeta));
    }
    if (data.containsKey('window_start_at_entry')) {
      context.handle(
          _windowStartAtEntryMeta,
          windowStartAtEntry.isAcceptableOrUnknown(
              data['window_start_at_entry']!, _windowStartAtEntryMeta));
    }
    if (data.containsKey('window_end_at_entry')) {
      context.handle(
          _windowEndAtEntryMeta,
          windowEndAtEntry.isAcceptableOrUnknown(
              data['window_end_at_entry']!, _windowEndAtEntryMeta));
    }
    if (data.containsKey('variance_days')) {
      context.handle(
          _varianceDaysMeta,
          varianceDays.isAcceptableOrUnknown(
              data['variance_days']!, _varianceDaysMeta));
    }
    if (data.containsKey('classification')) {
      context.handle(
          _classificationMeta,
          classification.isAcceptableOrUnknown(
              data['classification']!, _classificationMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
          _remoteUpdatedAtMeta,
          remoteUpdatedAt.isAcceptableOrUnknown(
              data['remote_updated_at']!, _remoteUpdatedAtMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('prediction_confidence_at_entry')) {
      context.handle(
          _predictionConfidenceAtEntryMeta,
          predictionConfidenceAtEntry.isAcceptableOrUnknown(
              data['prediction_confidence_at_entry']!,
              _predictionConfidenceAtEntryMeta));
    }
    if (data.containsKey('prediction_model_version_at_entry')) {
      context.handle(
          _predictionModelVersionAtEntryMeta,
          predictionModelVersionAtEntry.isAcceptableOrUnknown(
              data['prediction_model_version_at_entry']!,
              _predictionModelVersionAtEntryMeta));
    }
    if (data.containsKey('prediction_sample_size_at_entry')) {
      context.handle(
          _predictionSampleSizeAtEntryMeta,
          predictionSampleSizeAtEntry.isAcceptableOrUnknown(
              data['prediction_sample_size_at_entry']!,
              _predictionSampleSizeAtEntryMeta));
    }
    if (data.containsKey('prediction_snapshot_at')) {
      context.handle(
          _predictionSnapshotAtMeta,
          predictionSnapshotAt.isAcceptableOrUnknown(
              data['prediction_snapshot_at']!, _predictionSnapshotAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeriodEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeriodEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_date']),
      cycleLengthDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cycle_length_days']),
      periodDurationDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}period_duration_days']),
      predictedStartAtEntry: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}predicted_start_at_entry']),
      windowStartAtEntry: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}window_start_at_entry']),
      windowEndAtEntry: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}window_end_at_entry']),
      varianceDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}variance_days']),
      classification: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}classification']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      remoteUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}remote_updated_at']),
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      predictionConfidenceAtEntry: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}prediction_confidence_at_entry']),
      predictionModelVersionAtEntry: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}prediction_model_version_at_entry']),
      predictionSampleSizeAtEntry: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}prediction_sample_size_at_entry']),
      predictionSnapshotAt: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}prediction_snapshot_at']),
    );
  }

  @override
  $PeriodEntriesTable createAlias(String alias) {
    return $PeriodEntriesTable(attachedDatabase, alias);
  }
}

class PeriodEntry extends DataClass implements Insertable<PeriodEntry> {
  final String id;
  final String? userId;
  final String startDate;
  final String? endDate;
  final int? cycleLengthDays;
  final int? periodDurationDays;
  final String? predictedStartAtEntry;
  final String? windowStartAtEntry;
  final String? windowEndAtEntry;
  final int? varianceDays;
  final String? classification;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String syncStatus;
  final String? remoteUpdatedAt;
  final int version;
  final String? predictionConfidenceAtEntry;
  final String? predictionModelVersionAtEntry;
  final int? predictionSampleSizeAtEntry;
  final String? predictionSnapshotAt;
  const PeriodEntry(
      {required this.id,
      this.userId,
      required this.startDate,
      this.endDate,
      this.cycleLengthDays,
      this.periodDurationDays,
      this.predictedStartAtEntry,
      this.windowStartAtEntry,
      this.windowEndAtEntry,
      this.varianceDays,
      this.classification,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.syncStatus,
      this.remoteUpdatedAt,
      required this.version,
      this.predictionConfidenceAtEntry,
      this.predictionModelVersionAtEntry,
      this.predictionSampleSizeAtEntry,
      this.predictionSnapshotAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    if (!nullToAbsent || cycleLengthDays != null) {
      map['cycle_length_days'] = Variable<int>(cycleLengthDays);
    }
    if (!nullToAbsent || periodDurationDays != null) {
      map['period_duration_days'] = Variable<int>(periodDurationDays);
    }
    if (!nullToAbsent || predictedStartAtEntry != null) {
      map['predicted_start_at_entry'] = Variable<String>(predictedStartAtEntry);
    }
    if (!nullToAbsent || windowStartAtEntry != null) {
      map['window_start_at_entry'] = Variable<String>(windowStartAtEntry);
    }
    if (!nullToAbsent || windowEndAtEntry != null) {
      map['window_end_at_entry'] = Variable<String>(windowEndAtEntry);
    }
    if (!nullToAbsent || varianceDays != null) {
      map['variance_days'] = Variable<int>(varianceDays);
    }
    if (!nullToAbsent || classification != null) {
      map['classification'] = Variable<String>(classification);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || remoteUpdatedAt != null) {
      map['remote_updated_at'] = Variable<String>(remoteUpdatedAt);
    }
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || predictionConfidenceAtEntry != null) {
      map['prediction_confidence_at_entry'] =
          Variable<String>(predictionConfidenceAtEntry);
    }
    if (!nullToAbsent || predictionModelVersionAtEntry != null) {
      map['prediction_model_version_at_entry'] =
          Variable<String>(predictionModelVersionAtEntry);
    }
    if (!nullToAbsent || predictionSampleSizeAtEntry != null) {
      map['prediction_sample_size_at_entry'] =
          Variable<int>(predictionSampleSizeAtEntry);
    }
    if (!nullToAbsent || predictionSnapshotAt != null) {
      map['prediction_snapshot_at'] = Variable<String>(predictionSnapshotAt);
    }
    return map;
  }

  PeriodEntriesCompanion toCompanion(bool nullToAbsent) {
    return PeriodEntriesCompanion(
      id: Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      cycleLengthDays: cycleLengthDays == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleLengthDays),
      periodDurationDays: periodDurationDays == null && nullToAbsent
          ? const Value.absent()
          : Value(periodDurationDays),
      predictedStartAtEntry: predictedStartAtEntry == null && nullToAbsent
          ? const Value.absent()
          : Value(predictedStartAtEntry),
      windowStartAtEntry: windowStartAtEntry == null && nullToAbsent
          ? const Value.absent()
          : Value(windowStartAtEntry),
      windowEndAtEntry: windowEndAtEntry == null && nullToAbsent
          ? const Value.absent()
          : Value(windowEndAtEntry),
      varianceDays: varianceDays == null && nullToAbsent
          ? const Value.absent()
          : Value(varianceDays),
      classification: classification == null && nullToAbsent
          ? const Value.absent()
          : Value(classification),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      remoteUpdatedAt: remoteUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUpdatedAt),
      version: Value(version),
      predictionConfidenceAtEntry:
          predictionConfidenceAtEntry == null && nullToAbsent
              ? const Value.absent()
              : Value(predictionConfidenceAtEntry),
      predictionModelVersionAtEntry:
          predictionModelVersionAtEntry == null && nullToAbsent
              ? const Value.absent()
              : Value(predictionModelVersionAtEntry),
      predictionSampleSizeAtEntry:
          predictionSampleSizeAtEntry == null && nullToAbsent
              ? const Value.absent()
              : Value(predictionSampleSizeAtEntry),
      predictionSnapshotAt: predictionSnapshotAt == null && nullToAbsent
          ? const Value.absent()
          : Value(predictionSnapshotAt),
    );
  }

  factory PeriodEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeriodEntry(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      cycleLengthDays: serializer.fromJson<int?>(json['cycleLengthDays']),
      periodDurationDays: serializer.fromJson<int?>(json['periodDurationDays']),
      predictedStartAtEntry:
          serializer.fromJson<String?>(json['predictedStartAtEntry']),
      windowStartAtEntry:
          serializer.fromJson<String?>(json['windowStartAtEntry']),
      windowEndAtEntry: serializer.fromJson<String?>(json['windowEndAtEntry']),
      varianceDays: serializer.fromJson<int?>(json['varianceDays']),
      classification: serializer.fromJson<String?>(json['classification']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      remoteUpdatedAt: serializer.fromJson<String?>(json['remoteUpdatedAt']),
      version: serializer.fromJson<int>(json['version']),
      predictionConfidenceAtEntry:
          serializer.fromJson<String?>(json['predictionConfidenceAtEntry']),
      predictionModelVersionAtEntry:
          serializer.fromJson<String?>(json['predictionModelVersionAtEntry']),
      predictionSampleSizeAtEntry:
          serializer.fromJson<int?>(json['predictionSampleSizeAtEntry']),
      predictionSnapshotAt:
          serializer.fromJson<String?>(json['predictionSnapshotAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'cycleLengthDays': serializer.toJson<int?>(cycleLengthDays),
      'periodDurationDays': serializer.toJson<int?>(periodDurationDays),
      'predictedStartAtEntry':
          serializer.toJson<String?>(predictedStartAtEntry),
      'windowStartAtEntry': serializer.toJson<String?>(windowStartAtEntry),
      'windowEndAtEntry': serializer.toJson<String?>(windowEndAtEntry),
      'varianceDays': serializer.toJson<int?>(varianceDays),
      'classification': serializer.toJson<String?>(classification),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'remoteUpdatedAt': serializer.toJson<String?>(remoteUpdatedAt),
      'version': serializer.toJson<int>(version),
      'predictionConfidenceAtEntry':
          serializer.toJson<String?>(predictionConfidenceAtEntry),
      'predictionModelVersionAtEntry':
          serializer.toJson<String?>(predictionModelVersionAtEntry),
      'predictionSampleSizeAtEntry':
          serializer.toJson<int?>(predictionSampleSizeAtEntry),
      'predictionSnapshotAt': serializer.toJson<String?>(predictionSnapshotAt),
    };
  }

  PeriodEntry copyWith(
          {String? id,
          Value<String?> userId = const Value.absent(),
          String? startDate,
          Value<String?> endDate = const Value.absent(),
          Value<int?> cycleLengthDays = const Value.absent(),
          Value<int?> periodDurationDays = const Value.absent(),
          Value<String?> predictedStartAtEntry = const Value.absent(),
          Value<String?> windowStartAtEntry = const Value.absent(),
          Value<String?> windowEndAtEntry = const Value.absent(),
          Value<int?> varianceDays = const Value.absent(),
          Value<String?> classification = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? createdAt,
          String? updatedAt,
          Value<String?> deletedAt = const Value.absent(),
          String? syncStatus,
          Value<String?> remoteUpdatedAt = const Value.absent(),
          int? version,
          Value<String?> predictionConfidenceAtEntry = const Value.absent(),
          Value<String?> predictionModelVersionAtEntry = const Value.absent(),
          Value<int?> predictionSampleSizeAtEntry = const Value.absent(),
          Value<String?> predictionSnapshotAt = const Value.absent()}) =>
      PeriodEntry(
        id: id ?? this.id,
        userId: userId.present ? userId.value : this.userId,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        cycleLengthDays: cycleLengthDays.present
            ? cycleLengthDays.value
            : this.cycleLengthDays,
        periodDurationDays: periodDurationDays.present
            ? periodDurationDays.value
            : this.periodDurationDays,
        predictedStartAtEntry: predictedStartAtEntry.present
            ? predictedStartAtEntry.value
            : this.predictedStartAtEntry,
        windowStartAtEntry: windowStartAtEntry.present
            ? windowStartAtEntry.value
            : this.windowStartAtEntry,
        windowEndAtEntry: windowEndAtEntry.present
            ? windowEndAtEntry.value
            : this.windowEndAtEntry,
        varianceDays:
            varianceDays.present ? varianceDays.value : this.varianceDays,
        classification:
            classification.present ? classification.value : this.classification,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteUpdatedAt: remoteUpdatedAt.present
            ? remoteUpdatedAt.value
            : this.remoteUpdatedAt,
        version: version ?? this.version,
        predictionConfidenceAtEntry: predictionConfidenceAtEntry.present
            ? predictionConfidenceAtEntry.value
            : this.predictionConfidenceAtEntry,
        predictionModelVersionAtEntry: predictionModelVersionAtEntry.present
            ? predictionModelVersionAtEntry.value
            : this.predictionModelVersionAtEntry,
        predictionSampleSizeAtEntry: predictionSampleSizeAtEntry.present
            ? predictionSampleSizeAtEntry.value
            : this.predictionSampleSizeAtEntry,
        predictionSnapshotAt: predictionSnapshotAt.present
            ? predictionSnapshotAt.value
            : this.predictionSnapshotAt,
      );
  PeriodEntry copyWithCompanion(PeriodEntriesCompanion data) {
    return PeriodEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      cycleLengthDays: data.cycleLengthDays.present
          ? data.cycleLengthDays.value
          : this.cycleLengthDays,
      periodDurationDays: data.periodDurationDays.present
          ? data.periodDurationDays.value
          : this.periodDurationDays,
      predictedStartAtEntry: data.predictedStartAtEntry.present
          ? data.predictedStartAtEntry.value
          : this.predictedStartAtEntry,
      windowStartAtEntry: data.windowStartAtEntry.present
          ? data.windowStartAtEntry.value
          : this.windowStartAtEntry,
      windowEndAtEntry: data.windowEndAtEntry.present
          ? data.windowEndAtEntry.value
          : this.windowEndAtEntry,
      varianceDays: data.varianceDays.present
          ? data.varianceDays.value
          : this.varianceDays,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      version: data.version.present ? data.version.value : this.version,
      predictionConfidenceAtEntry: data.predictionConfidenceAtEntry.present
          ? data.predictionConfidenceAtEntry.value
          : this.predictionConfidenceAtEntry,
      predictionModelVersionAtEntry: data.predictionModelVersionAtEntry.present
          ? data.predictionModelVersionAtEntry.value
          : this.predictionModelVersionAtEntry,
      predictionSampleSizeAtEntry: data.predictionSampleSizeAtEntry.present
          ? data.predictionSampleSizeAtEntry.value
          : this.predictionSampleSizeAtEntry,
      predictionSnapshotAt: data.predictionSnapshotAt.present
          ? data.predictionSnapshotAt.value
          : this.predictionSnapshotAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeriodEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('cycleLengthDays: $cycleLengthDays, ')
          ..write('periodDurationDays: $periodDurationDays, ')
          ..write('predictedStartAtEntry: $predictedStartAtEntry, ')
          ..write('windowStartAtEntry: $windowStartAtEntry, ')
          ..write('windowEndAtEntry: $windowEndAtEntry, ')
          ..write('varianceDays: $varianceDays, ')
          ..write('classification: $classification, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('version: $version, ')
          ..write('predictionConfidenceAtEntry: $predictionConfidenceAtEntry, ')
          ..write(
              'predictionModelVersionAtEntry: $predictionModelVersionAtEntry, ')
          ..write('predictionSampleSizeAtEntry: $predictionSampleSizeAtEntry, ')
          ..write('predictionSnapshotAt: $predictionSnapshotAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        startDate,
        endDate,
        cycleLengthDays,
        periodDurationDays,
        predictedStartAtEntry,
        windowStartAtEntry,
        windowEndAtEntry,
        varianceDays,
        classification,
        notes,
        createdAt,
        updatedAt,
        deletedAt,
        syncStatus,
        remoteUpdatedAt,
        version,
        predictionConfidenceAtEntry,
        predictionModelVersionAtEntry,
        predictionSampleSizeAtEntry,
        predictionSnapshotAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeriodEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.cycleLengthDays == this.cycleLengthDays &&
          other.periodDurationDays == this.periodDurationDays &&
          other.predictedStartAtEntry == this.predictedStartAtEntry &&
          other.windowStartAtEntry == this.windowStartAtEntry &&
          other.windowEndAtEntry == this.windowEndAtEntry &&
          other.varianceDays == this.varianceDays &&
          other.classification == this.classification &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.version == this.version &&
          other.predictionConfidenceAtEntry ==
              this.predictionConfidenceAtEntry &&
          other.predictionModelVersionAtEntry ==
              this.predictionModelVersionAtEntry &&
          other.predictionSampleSizeAtEntry ==
              this.predictionSampleSizeAtEntry &&
          other.predictionSnapshotAt == this.predictionSnapshotAt);
}

class PeriodEntriesCompanion extends UpdateCompanion<PeriodEntry> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> startDate;
  final Value<String?> endDate;
  final Value<int?> cycleLengthDays;
  final Value<int?> periodDurationDays;
  final Value<String?> predictedStartAtEntry;
  final Value<String?> windowStartAtEntry;
  final Value<String?> windowEndAtEntry;
  final Value<int?> varianceDays;
  final Value<String?> classification;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> remoteUpdatedAt;
  final Value<int> version;
  final Value<String?> predictionConfidenceAtEntry;
  final Value<String?> predictionModelVersionAtEntry;
  final Value<int?> predictionSampleSizeAtEntry;
  final Value<String?> predictionSnapshotAt;
  final Value<int> rowid;
  const PeriodEntriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.cycleLengthDays = const Value.absent(),
    this.periodDurationDays = const Value.absent(),
    this.predictedStartAtEntry = const Value.absent(),
    this.windowStartAtEntry = const Value.absent(),
    this.windowEndAtEntry = const Value.absent(),
    this.varianceDays = const Value.absent(),
    this.classification = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.predictionConfidenceAtEntry = const Value.absent(),
    this.predictionModelVersionAtEntry = const Value.absent(),
    this.predictionSampleSizeAtEntry = const Value.absent(),
    this.predictionSnapshotAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PeriodEntriesCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String startDate,
    this.endDate = const Value.absent(),
    this.cycleLengthDays = const Value.absent(),
    this.periodDurationDays = const Value.absent(),
    this.predictedStartAtEntry = const Value.absent(),
    this.windowStartAtEntry = const Value.absent(),
    this.windowEndAtEntry = const Value.absent(),
    this.varianceDays = const Value.absent(),
    this.classification = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.predictionConfidenceAtEntry = const Value.absent(),
    this.predictionModelVersionAtEntry = const Value.absent(),
    this.predictionSampleSizeAtEntry = const Value.absent(),
    this.predictionSnapshotAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startDate = Value(startDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PeriodEntry> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<int>? cycleLengthDays,
    Expression<int>? periodDurationDays,
    Expression<String>? predictedStartAtEntry,
    Expression<String>? windowStartAtEntry,
    Expression<String>? windowEndAtEntry,
    Expression<int>? varianceDays,
    Expression<String>? classification,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteUpdatedAt,
    Expression<int>? version,
    Expression<String>? predictionConfidenceAtEntry,
    Expression<String>? predictionModelVersionAtEntry,
    Expression<int>? predictionSampleSizeAtEntry,
    Expression<String>? predictionSnapshotAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (cycleLengthDays != null) 'cycle_length_days': cycleLengthDays,
      if (periodDurationDays != null)
        'period_duration_days': periodDurationDays,
      if (predictedStartAtEntry != null)
        'predicted_start_at_entry': predictedStartAtEntry,
      if (windowStartAtEntry != null)
        'window_start_at_entry': windowStartAtEntry,
      if (windowEndAtEntry != null) 'window_end_at_entry': windowEndAtEntry,
      if (varianceDays != null) 'variance_days': varianceDays,
      if (classification != null) 'classification': classification,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (version != null) 'version': version,
      if (predictionConfidenceAtEntry != null)
        'prediction_confidence_at_entry': predictionConfidenceAtEntry,
      if (predictionModelVersionAtEntry != null)
        'prediction_model_version_at_entry': predictionModelVersionAtEntry,
      if (predictionSampleSizeAtEntry != null)
        'prediction_sample_size_at_entry': predictionSampleSizeAtEntry,
      if (predictionSnapshotAt != null)
        'prediction_snapshot_at': predictionSnapshotAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PeriodEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? userId,
      Value<String>? startDate,
      Value<String?>? endDate,
      Value<int?>? cycleLengthDays,
      Value<int?>? periodDurationDays,
      Value<String?>? predictedStartAtEntry,
      Value<String?>? windowStartAtEntry,
      Value<String?>? windowEndAtEntry,
      Value<int?>? varianceDays,
      Value<String?>? classification,
      Value<String?>? notes,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? deletedAt,
      Value<String>? syncStatus,
      Value<String?>? remoteUpdatedAt,
      Value<int>? version,
      Value<String?>? predictionConfidenceAtEntry,
      Value<String?>? predictionModelVersionAtEntry,
      Value<int?>? predictionSampleSizeAtEntry,
      Value<String?>? predictionSnapshotAt,
      Value<int>? rowid}) {
    return PeriodEntriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cycleLengthDays: cycleLengthDays ?? this.cycleLengthDays,
      periodDurationDays: periodDurationDays ?? this.periodDurationDays,
      predictedStartAtEntry:
          predictedStartAtEntry ?? this.predictedStartAtEntry,
      windowStartAtEntry: windowStartAtEntry ?? this.windowStartAtEntry,
      windowEndAtEntry: windowEndAtEntry ?? this.windowEndAtEntry,
      varianceDays: varianceDays ?? this.varianceDays,
      classification: classification ?? this.classification,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      version: version ?? this.version,
      predictionConfidenceAtEntry:
          predictionConfidenceAtEntry ?? this.predictionConfidenceAtEntry,
      predictionModelVersionAtEntry:
          predictionModelVersionAtEntry ?? this.predictionModelVersionAtEntry,
      predictionSampleSizeAtEntry:
          predictionSampleSizeAtEntry ?? this.predictionSampleSizeAtEntry,
      predictionSnapshotAt: predictionSnapshotAt ?? this.predictionSnapshotAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (cycleLengthDays.present) {
      map['cycle_length_days'] = Variable<int>(cycleLengthDays.value);
    }
    if (periodDurationDays.present) {
      map['period_duration_days'] = Variable<int>(periodDurationDays.value);
    }
    if (predictedStartAtEntry.present) {
      map['predicted_start_at_entry'] =
          Variable<String>(predictedStartAtEntry.value);
    }
    if (windowStartAtEntry.present) {
      map['window_start_at_entry'] = Variable<String>(windowStartAtEntry.value);
    }
    if (windowEndAtEntry.present) {
      map['window_end_at_entry'] = Variable<String>(windowEndAtEntry.value);
    }
    if (varianceDays.present) {
      map['variance_days'] = Variable<int>(varianceDays.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<String>(remoteUpdatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (predictionConfidenceAtEntry.present) {
      map['prediction_confidence_at_entry'] =
          Variable<String>(predictionConfidenceAtEntry.value);
    }
    if (predictionModelVersionAtEntry.present) {
      map['prediction_model_version_at_entry'] =
          Variable<String>(predictionModelVersionAtEntry.value);
    }
    if (predictionSampleSizeAtEntry.present) {
      map['prediction_sample_size_at_entry'] =
          Variable<int>(predictionSampleSizeAtEntry.value);
    }
    if (predictionSnapshotAt.present) {
      map['prediction_snapshot_at'] =
          Variable<String>(predictionSnapshotAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodEntriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('cycleLengthDays: $cycleLengthDays, ')
          ..write('periodDurationDays: $periodDurationDays, ')
          ..write('predictedStartAtEntry: $predictedStartAtEntry, ')
          ..write('windowStartAtEntry: $windowStartAtEntry, ')
          ..write('windowEndAtEntry: $windowEndAtEntry, ')
          ..write('varianceDays: $varianceDays, ')
          ..write('classification: $classification, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('version: $version, ')
          ..write('predictionConfidenceAtEntry: $predictionConfidenceAtEntry, ')
          ..write(
              'predictionModelVersionAtEntry: $predictionModelVersionAtEntry, ')
          ..write('predictionSampleSizeAtEntry: $predictionSampleSizeAtEntry, ')
          ..write('predictionSnapshotAt: $predictionSnapshotAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PredictionsTable extends Predictions
    with TableInfo<$PredictionsTable, Prediction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PredictionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<String> generatedAt = GeneratedColumn<String>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _predictedStartMeta =
      const VerificationMeta('predictedStart');
  @override
  late final GeneratedColumn<String> predictedStart = GeneratedColumn<String>(
      'predicted_start', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _windowStartMeta =
      const VerificationMeta('windowStart');
  @override
  late final GeneratedColumn<String> windowStart = GeneratedColumn<String>(
      'window_start', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _windowEndMeta =
      const VerificationMeta('windowEnd');
  @override
  late final GeneratedColumn<String> windowEnd = GeneratedColumn<String>(
      'window_end', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baselineCycleDaysMeta =
      const VerificationMeta('baselineCycleDays');
  @override
  late final GeneratedColumn<int> baselineCycleDays = GeneratedColumn<int>(
      'baseline_cycle_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _variabilityDaysMeta =
      const VerificationMeta('variabilityDays');
  @override
  late final GeneratedColumn<int> variabilityDays = GeneratedColumn<int>(
      'variability_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
      'confidence', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _basedOnCyclesMeta =
      const VerificationMeta('basedOnCycles');
  @override
  late final GeneratedColumn<int> basedOnCycles = GeneratedColumn<int>(
      'based_on_cycles', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _modelVersionMeta =
      const VerificationMeta('modelVersion');
  @override
  late final GeneratedColumn<String> modelVersion = GeneratedColumn<String>(
      'model_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        generatedAt,
        predictedStart,
        windowStart,
        windowEnd,
        baselineCycleDays,
        variabilityDays,
        confidence,
        basedOnCycles,
        modelVersion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'predictions';
  @override
  VerificationContext validateIntegrity(Insertable<Prediction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('predicted_start')) {
      context.handle(
          _predictedStartMeta,
          predictedStart.isAcceptableOrUnknown(
              data['predicted_start']!, _predictedStartMeta));
    } else if (isInserting) {
      context.missing(_predictedStartMeta);
    }
    if (data.containsKey('window_start')) {
      context.handle(
          _windowStartMeta,
          windowStart.isAcceptableOrUnknown(
              data['window_start']!, _windowStartMeta));
    } else if (isInserting) {
      context.missing(_windowStartMeta);
    }
    if (data.containsKey('window_end')) {
      context.handle(_windowEndMeta,
          windowEnd.isAcceptableOrUnknown(data['window_end']!, _windowEndMeta));
    } else if (isInserting) {
      context.missing(_windowEndMeta);
    }
    if (data.containsKey('baseline_cycle_days')) {
      context.handle(
          _baselineCycleDaysMeta,
          baselineCycleDays.isAcceptableOrUnknown(
              data['baseline_cycle_days']!, _baselineCycleDaysMeta));
    } else if (isInserting) {
      context.missing(_baselineCycleDaysMeta);
    }
    if (data.containsKey('variability_days')) {
      context.handle(
          _variabilityDaysMeta,
          variabilityDays.isAcceptableOrUnknown(
              data['variability_days']!, _variabilityDaysMeta));
    } else if (isInserting) {
      context.missing(_variabilityDaysMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('based_on_cycles')) {
      context.handle(
          _basedOnCyclesMeta,
          basedOnCycles.isAcceptableOrUnknown(
              data['based_on_cycles']!, _basedOnCyclesMeta));
    } else if (isInserting) {
      context.missing(_basedOnCyclesMeta);
    }
    if (data.containsKey('model_version')) {
      context.handle(
          _modelVersionMeta,
          modelVersion.isAcceptableOrUnknown(
              data['model_version']!, _modelVersionMeta));
    } else if (isInserting) {
      context.missing(_modelVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prediction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prediction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}generated_at'])!,
      predictedStart: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}predicted_start'])!,
      windowStart: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}window_start'])!,
      windowEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}window_end'])!,
      baselineCycleDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}baseline_cycle_days'])!,
      variabilityDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}variability_days'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}confidence'])!,
      basedOnCycles: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}based_on_cycles'])!,
      modelVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_version'])!,
    );
  }

  @override
  $PredictionsTable createAlias(String alias) {
    return $PredictionsTable(attachedDatabase, alias);
  }
}

class Prediction extends DataClass implements Insertable<Prediction> {
  final String id;
  final String? userId;
  final String generatedAt;
  final String predictedStart;
  final String windowStart;
  final String windowEnd;
  final int baselineCycleDays;
  final int variabilityDays;
  final String confidence;
  final int basedOnCycles;
  final String modelVersion;
  const Prediction(
      {required this.id,
      this.userId,
      required this.generatedAt,
      required this.predictedStart,
      required this.windowStart,
      required this.windowEnd,
      required this.baselineCycleDays,
      required this.variabilityDays,
      required this.confidence,
      required this.basedOnCycles,
      required this.modelVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['generated_at'] = Variable<String>(generatedAt);
    map['predicted_start'] = Variable<String>(predictedStart);
    map['window_start'] = Variable<String>(windowStart);
    map['window_end'] = Variable<String>(windowEnd);
    map['baseline_cycle_days'] = Variable<int>(baselineCycleDays);
    map['variability_days'] = Variable<int>(variabilityDays);
    map['confidence'] = Variable<String>(confidence);
    map['based_on_cycles'] = Variable<int>(basedOnCycles);
    map['model_version'] = Variable<String>(modelVersion);
    return map;
  }

  PredictionsCompanion toCompanion(bool nullToAbsent) {
    return PredictionsCompanion(
      id: Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      generatedAt: Value(generatedAt),
      predictedStart: Value(predictedStart),
      windowStart: Value(windowStart),
      windowEnd: Value(windowEnd),
      baselineCycleDays: Value(baselineCycleDays),
      variabilityDays: Value(variabilityDays),
      confidence: Value(confidence),
      basedOnCycles: Value(basedOnCycles),
      modelVersion: Value(modelVersion),
    );
  }

  factory Prediction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prediction(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      generatedAt: serializer.fromJson<String>(json['generatedAt']),
      predictedStart: serializer.fromJson<String>(json['predictedStart']),
      windowStart: serializer.fromJson<String>(json['windowStart']),
      windowEnd: serializer.fromJson<String>(json['windowEnd']),
      baselineCycleDays: serializer.fromJson<int>(json['baselineCycleDays']),
      variabilityDays: serializer.fromJson<int>(json['variabilityDays']),
      confidence: serializer.fromJson<String>(json['confidence']),
      basedOnCycles: serializer.fromJson<int>(json['basedOnCycles']),
      modelVersion: serializer.fromJson<String>(json['modelVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'generatedAt': serializer.toJson<String>(generatedAt),
      'predictedStart': serializer.toJson<String>(predictedStart),
      'windowStart': serializer.toJson<String>(windowStart),
      'windowEnd': serializer.toJson<String>(windowEnd),
      'baselineCycleDays': serializer.toJson<int>(baselineCycleDays),
      'variabilityDays': serializer.toJson<int>(variabilityDays),
      'confidence': serializer.toJson<String>(confidence),
      'basedOnCycles': serializer.toJson<int>(basedOnCycles),
      'modelVersion': serializer.toJson<String>(modelVersion),
    };
  }

  Prediction copyWith(
          {String? id,
          Value<String?> userId = const Value.absent(),
          String? generatedAt,
          String? predictedStart,
          String? windowStart,
          String? windowEnd,
          int? baselineCycleDays,
          int? variabilityDays,
          String? confidence,
          int? basedOnCycles,
          String? modelVersion}) =>
      Prediction(
        id: id ?? this.id,
        userId: userId.present ? userId.value : this.userId,
        generatedAt: generatedAt ?? this.generatedAt,
        predictedStart: predictedStart ?? this.predictedStart,
        windowStart: windowStart ?? this.windowStart,
        windowEnd: windowEnd ?? this.windowEnd,
        baselineCycleDays: baselineCycleDays ?? this.baselineCycleDays,
        variabilityDays: variabilityDays ?? this.variabilityDays,
        confidence: confidence ?? this.confidence,
        basedOnCycles: basedOnCycles ?? this.basedOnCycles,
        modelVersion: modelVersion ?? this.modelVersion,
      );
  Prediction copyWithCompanion(PredictionsCompanion data) {
    return Prediction(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      predictedStart: data.predictedStart.present
          ? data.predictedStart.value
          : this.predictedStart,
      windowStart:
          data.windowStart.present ? data.windowStart.value : this.windowStart,
      windowEnd: data.windowEnd.present ? data.windowEnd.value : this.windowEnd,
      baselineCycleDays: data.baselineCycleDays.present
          ? data.baselineCycleDays.value
          : this.baselineCycleDays,
      variabilityDays: data.variabilityDays.present
          ? data.variabilityDays.value
          : this.variabilityDays,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      basedOnCycles: data.basedOnCycles.present
          ? data.basedOnCycles.value
          : this.basedOnCycles,
      modelVersion: data.modelVersion.present
          ? data.modelVersion.value
          : this.modelVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prediction(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('predictedStart: $predictedStart, ')
          ..write('windowStart: $windowStart, ')
          ..write('windowEnd: $windowEnd, ')
          ..write('baselineCycleDays: $baselineCycleDays, ')
          ..write('variabilityDays: $variabilityDays, ')
          ..write('confidence: $confidence, ')
          ..write('basedOnCycles: $basedOnCycles, ')
          ..write('modelVersion: $modelVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      generatedAt,
      predictedStart,
      windowStart,
      windowEnd,
      baselineCycleDays,
      variabilityDays,
      confidence,
      basedOnCycles,
      modelVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prediction &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.generatedAt == this.generatedAt &&
          other.predictedStart == this.predictedStart &&
          other.windowStart == this.windowStart &&
          other.windowEnd == this.windowEnd &&
          other.baselineCycleDays == this.baselineCycleDays &&
          other.variabilityDays == this.variabilityDays &&
          other.confidence == this.confidence &&
          other.basedOnCycles == this.basedOnCycles &&
          other.modelVersion == this.modelVersion);
}

class PredictionsCompanion extends UpdateCompanion<Prediction> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> generatedAt;
  final Value<String> predictedStart;
  final Value<String> windowStart;
  final Value<String> windowEnd;
  final Value<int> baselineCycleDays;
  final Value<int> variabilityDays;
  final Value<String> confidence;
  final Value<int> basedOnCycles;
  final Value<String> modelVersion;
  final Value<int> rowid;
  const PredictionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.predictedStart = const Value.absent(),
    this.windowStart = const Value.absent(),
    this.windowEnd = const Value.absent(),
    this.baselineCycleDays = const Value.absent(),
    this.variabilityDays = const Value.absent(),
    this.confidence = const Value.absent(),
    this.basedOnCycles = const Value.absent(),
    this.modelVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PredictionsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String generatedAt,
    required String predictedStart,
    required String windowStart,
    required String windowEnd,
    required int baselineCycleDays,
    required int variabilityDays,
    required String confidence,
    required int basedOnCycles,
    required String modelVersion,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        generatedAt = Value(generatedAt),
        predictedStart = Value(predictedStart),
        windowStart = Value(windowStart),
        windowEnd = Value(windowEnd),
        baselineCycleDays = Value(baselineCycleDays),
        variabilityDays = Value(variabilityDays),
        confidence = Value(confidence),
        basedOnCycles = Value(basedOnCycles),
        modelVersion = Value(modelVersion);
  static Insertable<Prediction> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? generatedAt,
    Expression<String>? predictedStart,
    Expression<String>? windowStart,
    Expression<String>? windowEnd,
    Expression<int>? baselineCycleDays,
    Expression<int>? variabilityDays,
    Expression<String>? confidence,
    Expression<int>? basedOnCycles,
    Expression<String>? modelVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (predictedStart != null) 'predicted_start': predictedStart,
      if (windowStart != null) 'window_start': windowStart,
      if (windowEnd != null) 'window_end': windowEnd,
      if (baselineCycleDays != null) 'baseline_cycle_days': baselineCycleDays,
      if (variabilityDays != null) 'variability_days': variabilityDays,
      if (confidence != null) 'confidence': confidence,
      if (basedOnCycles != null) 'based_on_cycles': basedOnCycles,
      if (modelVersion != null) 'model_version': modelVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PredictionsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? userId,
      Value<String>? generatedAt,
      Value<String>? predictedStart,
      Value<String>? windowStart,
      Value<String>? windowEnd,
      Value<int>? baselineCycleDays,
      Value<int>? variabilityDays,
      Value<String>? confidence,
      Value<int>? basedOnCycles,
      Value<String>? modelVersion,
      Value<int>? rowid}) {
    return PredictionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      generatedAt: generatedAt ?? this.generatedAt,
      predictedStart: predictedStart ?? this.predictedStart,
      windowStart: windowStart ?? this.windowStart,
      windowEnd: windowEnd ?? this.windowEnd,
      baselineCycleDays: baselineCycleDays ?? this.baselineCycleDays,
      variabilityDays: variabilityDays ?? this.variabilityDays,
      confidence: confidence ?? this.confidence,
      basedOnCycles: basedOnCycles ?? this.basedOnCycles,
      modelVersion: modelVersion ?? this.modelVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<String>(generatedAt.value);
    }
    if (predictedStart.present) {
      map['predicted_start'] = Variable<String>(predictedStart.value);
    }
    if (windowStart.present) {
      map['window_start'] = Variable<String>(windowStart.value);
    }
    if (windowEnd.present) {
      map['window_end'] = Variable<String>(windowEnd.value);
    }
    if (baselineCycleDays.present) {
      map['baseline_cycle_days'] = Variable<int>(baselineCycleDays.value);
    }
    if (variabilityDays.present) {
      map['variability_days'] = Variable<int>(variabilityDays.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (basedOnCycles.present) {
      map['based_on_cycles'] = Variable<int>(basedOnCycles.value);
    }
    if (modelVersion.present) {
      map['model_version'] = Variable<String>(modelVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PredictionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('predictedStart: $predictedStart, ')
          ..write('windowStart: $windowStart, ')
          ..write('windowEnd: $windowEnd, ')
          ..write('baselineCycleDays: $baselineCycleDays, ')
          ..write('variabilityDays: $variabilityDays, ')
          ..write('confidence: $confidence, ')
          ..write('basedOnCycles: $basedOnCycles, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PeriodDayLogsTable extends PeriodDayLogs
    with TableInfo<$PeriodDayLogsTable, PeriodDayLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodDayLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _periodEntryIdMeta =
      const VerificationMeta('periodEntryId');
  @override
  late final GeneratedColumn<String> periodEntryId = GeneratedColumn<String>(
      'period_entry_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _logDateMeta =
      const VerificationMeta('logDate');
  @override
  late final GeneratedColumn<String> logDate = GeneratedColumn<String>(
      'log_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _flowMeta = const VerificationMeta('flow');
  @override
  late final GeneratedColumn<String> flow = GeneratedColumn<String>(
      'flow', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _remoteUpdatedAtMeta =
      const VerificationMeta('remoteUpdatedAt');
  @override
  late final GeneratedColumn<String> remoteUpdatedAt = GeneratedColumn<String>(
      'remote_updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        periodEntryId,
        logDate,
        flow,
        createdAt,
        updatedAt,
        deletedAt,
        syncStatus,
        remoteUpdatedAt,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'period_day_logs';
  @override
  VerificationContext validateIntegrity(Insertable<PeriodDayLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('period_entry_id')) {
      context.handle(
          _periodEntryIdMeta,
          periodEntryId.isAcceptableOrUnknown(
              data['period_entry_id']!, _periodEntryIdMeta));
    } else if (isInserting) {
      context.missing(_periodEntryIdMeta);
    }
    if (data.containsKey('log_date')) {
      context.handle(_logDateMeta,
          logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta));
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('flow')) {
      context.handle(
          _flowMeta, flow.isAcceptableOrUnknown(data['flow']!, _flowMeta));
    } else if (isInserting) {
      context.missing(_flowMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
          _remoteUpdatedAtMeta,
          remoteUpdatedAt.isAcceptableOrUnknown(
              data['remote_updated_at']!, _remoteUpdatedAtMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {periodEntryId, logDate},
      ];
  @override
  PeriodDayLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeriodDayLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      periodEntryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}period_entry_id'])!,
      logDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}log_date'])!,
      flow: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flow'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deleted_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      remoteUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}remote_updated_at']),
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $PeriodDayLogsTable createAlias(String alias) {
    return $PeriodDayLogsTable(attachedDatabase, alias);
  }
}

class PeriodDayLog extends DataClass implements Insertable<PeriodDayLog> {
  final String id;
  final String? userId;
  final String periodEntryId;
  final String logDate;
  final String flow;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String syncStatus;
  final String? remoteUpdatedAt;
  final int version;
  const PeriodDayLog(
      {required this.id,
      this.userId,
      required this.periodEntryId,
      required this.logDate,
      required this.flow,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.syncStatus,
      this.remoteUpdatedAt,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['period_entry_id'] = Variable<String>(periodEntryId);
    map['log_date'] = Variable<String>(logDate);
    map['flow'] = Variable<String>(flow);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || remoteUpdatedAt != null) {
      map['remote_updated_at'] = Variable<String>(remoteUpdatedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  PeriodDayLogsCompanion toCompanion(bool nullToAbsent) {
    return PeriodDayLogsCompanion(
      id: Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      periodEntryId: Value(periodEntryId),
      logDate: Value(logDate),
      flow: Value(flow),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      remoteUpdatedAt: remoteUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUpdatedAt),
      version: Value(version),
    );
  }

  factory PeriodDayLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeriodDayLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      periodEntryId: serializer.fromJson<String>(json['periodEntryId']),
      logDate: serializer.fromJson<String>(json['logDate']),
      flow: serializer.fromJson<String>(json['flow']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      remoteUpdatedAt: serializer.fromJson<String?>(json['remoteUpdatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'periodEntryId': serializer.toJson<String>(periodEntryId),
      'logDate': serializer.toJson<String>(logDate),
      'flow': serializer.toJson<String>(flow),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'remoteUpdatedAt': serializer.toJson<String?>(remoteUpdatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  PeriodDayLog copyWith(
          {String? id,
          Value<String?> userId = const Value.absent(),
          String? periodEntryId,
          String? logDate,
          String? flow,
          String? createdAt,
          String? updatedAt,
          Value<String?> deletedAt = const Value.absent(),
          String? syncStatus,
          Value<String?> remoteUpdatedAt = const Value.absent(),
          int? version}) =>
      PeriodDayLog(
        id: id ?? this.id,
        userId: userId.present ? userId.value : this.userId,
        periodEntryId: periodEntryId ?? this.periodEntryId,
        logDate: logDate ?? this.logDate,
        flow: flow ?? this.flow,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteUpdatedAt: remoteUpdatedAt.present
            ? remoteUpdatedAt.value
            : this.remoteUpdatedAt,
        version: version ?? this.version,
      );
  PeriodDayLog copyWithCompanion(PeriodDayLogsCompanion data) {
    return PeriodDayLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      periodEntryId: data.periodEntryId.present
          ? data.periodEntryId.value
          : this.periodEntryId,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      flow: data.flow.present ? data.flow.value : this.flow,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeriodDayLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('periodEntryId: $periodEntryId, ')
          ..write('logDate: $logDate, ')
          ..write('flow: $flow, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, periodEntryId, logDate, flow,
      createdAt, updatedAt, deletedAt, syncStatus, remoteUpdatedAt, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeriodDayLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.periodEntryId == this.periodEntryId &&
          other.logDate == this.logDate &&
          other.flow == this.flow &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.version == this.version);
}

class PeriodDayLogsCompanion extends UpdateCompanion<PeriodDayLog> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> periodEntryId;
  final Value<String> logDate;
  final Value<String> flow;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> remoteUpdatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const PeriodDayLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.periodEntryId = const Value.absent(),
    this.logDate = const Value.absent(),
    this.flow = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PeriodDayLogsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String periodEntryId,
    required String logDate,
    required String flow,
    required String createdAt,
    required String updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        periodEntryId = Value(periodEntryId),
        logDate = Value(logDate),
        flow = Value(flow),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PeriodDayLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? periodEntryId,
    Expression<String>? logDate,
    Expression<String>? flow,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? remoteUpdatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (periodEntryId != null) 'period_entry_id': periodEntryId,
      if (logDate != null) 'log_date': logDate,
      if (flow != null) 'flow': flow,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PeriodDayLogsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? userId,
      Value<String>? periodEntryId,
      Value<String>? logDate,
      Value<String>? flow,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? deletedAt,
      Value<String>? syncStatus,
      Value<String?>? remoteUpdatedAt,
      Value<int>? version,
      Value<int>? rowid}) {
    return PeriodDayLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      periodEntryId: periodEntryId ?? this.periodEntryId,
      logDate: logDate ?? this.logDate,
      flow: flow ?? this.flow,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (periodEntryId.present) {
      map['period_entry_id'] = Variable<String>(periodEntryId.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<String>(logDate.value);
    }
    if (flow.present) {
      map['flow'] = Variable<String>(flow.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<String>(remoteUpdatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodDayLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('periodEntryId: $periodEntryId, ')
          ..write('logDate: $logDate, ')
          ..write('flow: $flow, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserCycleSettingsTable extends UserCycleSettings
    with TableInfo<$UserCycleSettingsTable, UserCycleSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserCycleSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _showOvulationEstimateMeta =
      const VerificationMeta('showOvulationEstimate');
  @override
  late final GeneratedColumn<bool> showOvulationEstimate =
      GeneratedColumn<bool>('show_ovulation_estimate', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("show_ovulation_estimate" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _showFertileWindowMeta =
      const VerificationMeta('showFertileWindow');
  @override
  late final GeneratedColumn<bool> showFertileWindow = GeneratedColumn<bool>(
      'show_fertile_window', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_fertile_window" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reminderEnabledMeta =
      const VerificationMeta('reminderEnabled');
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
      'reminder_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminder_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastSummaryPeriodIdMeta =
      const VerificationMeta('lastSummaryPeriodId');
  @override
  late final GeneratedColumn<String> lastSummaryPeriodId =
      GeneratedColumn<String>('last_summary_period_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSuccessfulSyncAtMeta =
      const VerificationMeta('lastSuccessfulSyncAt');
  @override
  late final GeneratedColumn<String> lastSuccessfulSyncAt =
      GeneratedColumn<String>('last_successful_sync_at', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _initialSyncCompletedMeta =
      const VerificationMeta('initialSyncCompleted');
  @override
  late final GeneratedColumn<bool> initialSyncCompleted = GeneratedColumn<bool>(
      'initial_sync_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("initial_sync_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _remoteUpdatedAtMeta =
      const VerificationMeta('remoteUpdatedAt');
  @override
  late final GeneratedColumn<String> remoteUpdatedAt = GeneratedColumn<String>(
      'remote_updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        showOvulationEstimate,
        showFertileWindow,
        reminderEnabled,
        lastSummaryPeriodId,
        lastSuccessfulSyncAt,
        initialSyncCompleted,
        updatedAt,
        remoteUpdatedAt,
        syncStatus,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_cycle_settings';
  @override
  VerificationContext validateIntegrity(Insertable<UserCycleSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('show_ovulation_estimate')) {
      context.handle(
          _showOvulationEstimateMeta,
          showOvulationEstimate.isAcceptableOrUnknown(
              data['show_ovulation_estimate']!, _showOvulationEstimateMeta));
    }
    if (data.containsKey('show_fertile_window')) {
      context.handle(
          _showFertileWindowMeta,
          showFertileWindow.isAcceptableOrUnknown(
              data['show_fertile_window']!, _showFertileWindowMeta));
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
          _reminderEnabledMeta,
          reminderEnabled.isAcceptableOrUnknown(
              data['reminder_enabled']!, _reminderEnabledMeta));
    }
    if (data.containsKey('last_summary_period_id')) {
      context.handle(
          _lastSummaryPeriodIdMeta,
          lastSummaryPeriodId.isAcceptableOrUnknown(
              data['last_summary_period_id']!, _lastSummaryPeriodIdMeta));
    }
    if (data.containsKey('last_successful_sync_at')) {
      context.handle(
          _lastSuccessfulSyncAtMeta,
          lastSuccessfulSyncAt.isAcceptableOrUnknown(
              data['last_successful_sync_at']!, _lastSuccessfulSyncAtMeta));
    }
    if (data.containsKey('initial_sync_completed')) {
      context.handle(
          _initialSyncCompletedMeta,
          initialSyncCompleted.isAcceptableOrUnknown(
              data['initial_sync_completed']!, _initialSyncCompletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
          _remoteUpdatedAtMeta,
          remoteUpdatedAt.isAcceptableOrUnknown(
              data['remote_updated_at']!, _remoteUpdatedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserCycleSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCycleSetting(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      showOvulationEstimate: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}show_ovulation_estimate'])!,
      showFertileWindow: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_fertile_window'])!,
      reminderEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}reminder_enabled'])!,
      lastSummaryPeriodId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}last_summary_period_id']),
      lastSuccessfulSyncAt: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}last_successful_sync_at']),
      initialSyncCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}initial_sync_completed'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      remoteUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}remote_updated_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $UserCycleSettingsTable createAlias(String alias) {
    return $UserCycleSettingsTable(attachedDatabase, alias);
  }
}

class UserCycleSetting extends DataClass
    implements Insertable<UserCycleSetting> {
  final String userId;
  final bool showOvulationEstimate;
  final bool showFertileWindow;
  final bool reminderEnabled;
  final String? lastSummaryPeriodId;
  final String? lastSuccessfulSyncAt;
  final bool initialSyncCompleted;
  final String updatedAt;
  final String? remoteUpdatedAt;
  final String syncStatus;
  final int version;
  const UserCycleSetting(
      {required this.userId,
      required this.showOvulationEstimate,
      required this.showFertileWindow,
      required this.reminderEnabled,
      this.lastSummaryPeriodId,
      this.lastSuccessfulSyncAt,
      required this.initialSyncCompleted,
      required this.updatedAt,
      this.remoteUpdatedAt,
      required this.syncStatus,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['show_ovulation_estimate'] = Variable<bool>(showOvulationEstimate);
    map['show_fertile_window'] = Variable<bool>(showFertileWindow);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    if (!nullToAbsent || lastSummaryPeriodId != null) {
      map['last_summary_period_id'] = Variable<String>(lastSummaryPeriodId);
    }
    if (!nullToAbsent || lastSuccessfulSyncAt != null) {
      map['last_successful_sync_at'] = Variable<String>(lastSuccessfulSyncAt);
    }
    map['initial_sync_completed'] = Variable<bool>(initialSyncCompleted);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || remoteUpdatedAt != null) {
      map['remote_updated_at'] = Variable<String>(remoteUpdatedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    return map;
  }

  UserCycleSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserCycleSettingsCompanion(
      userId: Value(userId),
      showOvulationEstimate: Value(showOvulationEstimate),
      showFertileWindow: Value(showFertileWindow),
      reminderEnabled: Value(reminderEnabled),
      lastSummaryPeriodId: lastSummaryPeriodId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSummaryPeriodId),
      lastSuccessfulSyncAt: lastSuccessfulSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulSyncAt),
      initialSyncCompleted: Value(initialSyncCompleted),
      updatedAt: Value(updatedAt),
      remoteUpdatedAt: remoteUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUpdatedAt),
      syncStatus: Value(syncStatus),
      version: Value(version),
    );
  }

  factory UserCycleSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserCycleSetting(
      userId: serializer.fromJson<String>(json['userId']),
      showOvulationEstimate:
          serializer.fromJson<bool>(json['showOvulationEstimate']),
      showFertileWindow: serializer.fromJson<bool>(json['showFertileWindow']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      lastSummaryPeriodId:
          serializer.fromJson<String?>(json['lastSummaryPeriodId']),
      lastSuccessfulSyncAt:
          serializer.fromJson<String?>(json['lastSuccessfulSyncAt']),
      initialSyncCompleted:
          serializer.fromJson<bool>(json['initialSyncCompleted']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      remoteUpdatedAt: serializer.fromJson<String?>(json['remoteUpdatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'showOvulationEstimate': serializer.toJson<bool>(showOvulationEstimate),
      'showFertileWindow': serializer.toJson<bool>(showFertileWindow),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'lastSummaryPeriodId': serializer.toJson<String?>(lastSummaryPeriodId),
      'lastSuccessfulSyncAt': serializer.toJson<String?>(lastSuccessfulSyncAt),
      'initialSyncCompleted': serializer.toJson<bool>(initialSyncCompleted),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'remoteUpdatedAt': serializer.toJson<String?>(remoteUpdatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
    };
  }

  UserCycleSetting copyWith(
          {String? userId,
          bool? showOvulationEstimate,
          bool? showFertileWindow,
          bool? reminderEnabled,
          Value<String?> lastSummaryPeriodId = const Value.absent(),
          Value<String?> lastSuccessfulSyncAt = const Value.absent(),
          bool? initialSyncCompleted,
          String? updatedAt,
          Value<String?> remoteUpdatedAt = const Value.absent(),
          String? syncStatus,
          int? version}) =>
      UserCycleSetting(
        userId: userId ?? this.userId,
        showOvulationEstimate:
            showOvulationEstimate ?? this.showOvulationEstimate,
        showFertileWindow: showFertileWindow ?? this.showFertileWindow,
        reminderEnabled: reminderEnabled ?? this.reminderEnabled,
        lastSummaryPeriodId: lastSummaryPeriodId.present
            ? lastSummaryPeriodId.value
            : this.lastSummaryPeriodId,
        lastSuccessfulSyncAt: lastSuccessfulSyncAt.present
            ? lastSuccessfulSyncAt.value
            : this.lastSuccessfulSyncAt,
        initialSyncCompleted: initialSyncCompleted ?? this.initialSyncCompleted,
        updatedAt: updatedAt ?? this.updatedAt,
        remoteUpdatedAt: remoteUpdatedAt.present
            ? remoteUpdatedAt.value
            : this.remoteUpdatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        version: version ?? this.version,
      );
  UserCycleSetting copyWithCompanion(UserCycleSettingsCompanion data) {
    return UserCycleSetting(
      userId: data.userId.present ? data.userId.value : this.userId,
      showOvulationEstimate: data.showOvulationEstimate.present
          ? data.showOvulationEstimate.value
          : this.showOvulationEstimate,
      showFertileWindow: data.showFertileWindow.present
          ? data.showFertileWindow.value
          : this.showFertileWindow,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      lastSummaryPeriodId: data.lastSummaryPeriodId.present
          ? data.lastSummaryPeriodId.value
          : this.lastSummaryPeriodId,
      lastSuccessfulSyncAt: data.lastSuccessfulSyncAt.present
          ? data.lastSuccessfulSyncAt.value
          : this.lastSuccessfulSyncAt,
      initialSyncCompleted: data.initialSyncCompleted.present
          ? data.initialSyncCompleted.value
          : this.initialSyncCompleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserCycleSetting(')
          ..write('userId: $userId, ')
          ..write('showOvulationEstimate: $showOvulationEstimate, ')
          ..write('showFertileWindow: $showFertileWindow, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('lastSummaryPeriodId: $lastSummaryPeriodId, ')
          ..write('lastSuccessfulSyncAt: $lastSuccessfulSyncAt, ')
          ..write('initialSyncCompleted: $initialSyncCompleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      showOvulationEstimate,
      showFertileWindow,
      reminderEnabled,
      lastSummaryPeriodId,
      lastSuccessfulSyncAt,
      initialSyncCompleted,
      updatedAt,
      remoteUpdatedAt,
      syncStatus,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserCycleSetting &&
          other.userId == this.userId &&
          other.showOvulationEstimate == this.showOvulationEstimate &&
          other.showFertileWindow == this.showFertileWindow &&
          other.reminderEnabled == this.reminderEnabled &&
          other.lastSummaryPeriodId == this.lastSummaryPeriodId &&
          other.lastSuccessfulSyncAt == this.lastSuccessfulSyncAt &&
          other.initialSyncCompleted == this.initialSyncCompleted &&
          other.updatedAt == this.updatedAt &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version);
}

class UserCycleSettingsCompanion extends UpdateCompanion<UserCycleSetting> {
  final Value<String> userId;
  final Value<bool> showOvulationEstimate;
  final Value<bool> showFertileWindow;
  final Value<bool> reminderEnabled;
  final Value<String?> lastSummaryPeriodId;
  final Value<String?> lastSuccessfulSyncAt;
  final Value<bool> initialSyncCompleted;
  final Value<String> updatedAt;
  final Value<String?> remoteUpdatedAt;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<int> rowid;
  const UserCycleSettingsCompanion({
    this.userId = const Value.absent(),
    this.showOvulationEstimate = const Value.absent(),
    this.showFertileWindow = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.lastSummaryPeriodId = const Value.absent(),
    this.lastSuccessfulSyncAt = const Value.absent(),
    this.initialSyncCompleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserCycleSettingsCompanion.insert({
    required String userId,
    this.showOvulationEstimate = const Value.absent(),
    this.showFertileWindow = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.lastSummaryPeriodId = const Value.absent(),
    this.lastSuccessfulSyncAt = const Value.absent(),
    this.initialSyncCompleted = const Value.absent(),
    required String updatedAt,
    this.remoteUpdatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        updatedAt = Value(updatedAt);
  static Insertable<UserCycleSetting> custom({
    Expression<String>? userId,
    Expression<bool>? showOvulationEstimate,
    Expression<bool>? showFertileWindow,
    Expression<bool>? reminderEnabled,
    Expression<String>? lastSummaryPeriodId,
    Expression<String>? lastSuccessfulSyncAt,
    Expression<bool>? initialSyncCompleted,
    Expression<String>? updatedAt,
    Expression<String>? remoteUpdatedAt,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (showOvulationEstimate != null)
        'show_ovulation_estimate': showOvulationEstimate,
      if (showFertileWindow != null) 'show_fertile_window': showFertileWindow,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (lastSummaryPeriodId != null)
        'last_summary_period_id': lastSummaryPeriodId,
      if (lastSuccessfulSyncAt != null)
        'last_successful_sync_at': lastSuccessfulSyncAt,
      if (initialSyncCompleted != null)
        'initial_sync_completed': initialSyncCompleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserCycleSettingsCompanion copyWith(
      {Value<String>? userId,
      Value<bool>? showOvulationEstimate,
      Value<bool>? showFertileWindow,
      Value<bool>? reminderEnabled,
      Value<String?>? lastSummaryPeriodId,
      Value<String?>? lastSuccessfulSyncAt,
      Value<bool>? initialSyncCompleted,
      Value<String>? updatedAt,
      Value<String?>? remoteUpdatedAt,
      Value<String>? syncStatus,
      Value<int>? version,
      Value<int>? rowid}) {
    return UserCycleSettingsCompanion(
      userId: userId ?? this.userId,
      showOvulationEstimate:
          showOvulationEstimate ?? this.showOvulationEstimate,
      showFertileWindow: showFertileWindow ?? this.showFertileWindow,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      lastSummaryPeriodId: lastSummaryPeriodId ?? this.lastSummaryPeriodId,
      lastSuccessfulSyncAt: lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt,
      initialSyncCompleted: initialSyncCompleted ?? this.initialSyncCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (showOvulationEstimate.present) {
      map['show_ovulation_estimate'] =
          Variable<bool>(showOvulationEstimate.value);
    }
    if (showFertileWindow.present) {
      map['show_fertile_window'] = Variable<bool>(showFertileWindow.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (lastSummaryPeriodId.present) {
      map['last_summary_period_id'] =
          Variable<String>(lastSummaryPeriodId.value);
    }
    if (lastSuccessfulSyncAt.present) {
      map['last_successful_sync_at'] =
          Variable<String>(lastSuccessfulSyncAt.value);
    }
    if (initialSyncCompleted.present) {
      map['initial_sync_completed'] =
          Variable<bool>(initialSyncCompleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<String>(remoteUpdatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCycleSettingsCompanion(')
          ..write('userId: $userId, ')
          ..write('showOvulationEstimate: $showOvulationEstimate, ')
          ..write('showFertileWindow: $showFertileWindow, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('lastSummaryPeriodId: $lastSummaryPeriodId, ')
          ..write('lastSuccessfulSyncAt: $lastSuccessfulSyncAt, ')
          ..write('initialSyncCompleted: $initialSyncCompleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String? value;
  final String updatedAt;
  const AppSetting({required this.key, this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  AppSetting copyWith(
          {String? key,
          Value<String?> value = const Value.absent(),
          String? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key,
      Value<String?>? value,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attemptCountMeta =
      const VerificationMeta('attemptCount');
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
      'attempt_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        entityType,
        entityId,
        operation,
        payload,
        attemptCount,
        lastError,
        createdAt,
        updatedAt,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
          _attemptCountMeta,
          attemptCount.isAcceptableOrUnknown(
              data['attempt_count']!, _attemptCountMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      attemptCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempt_count'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String? userId;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final int attemptCount;
  final String? lastError;
  final String createdAt;
  final String updatedAt;
  final int version;
  const SyncQueueData(
      {required this.id,
      this.userId,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.payload,
      required this.attemptCount,
      this.lastError,
      required this.createdAt,
      required this.updatedAt,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  SyncQueueData copyWith(
          {String? id,
          Value<String?> userId = const Value.absent(),
          String? entityType,
          String? entityId,
          String? operation,
          String? payload,
          int? attemptCount,
          Value<String?> lastError = const Value.absent(),
          String? createdAt,
          String? updatedAt,
          int? version}) =>
      SyncQueueData(
        id: id ?? this.id,
        userId: userId.present ? userId.value : this.userId,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        payload: payload ?? this.payload,
        attemptCount: attemptCount ?? this.attemptCount,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        version: version ?? this.version,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, entityType, entityId, operation,
      payload, attemptCount, lastError, createdAt, updatedAt, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        operation = Value(operation),
        payload = Value(payload),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<String>? id,
      Value<String?>? userId,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? operation,
      Value<String>? payload,
      Value<int>? attemptCount,
      Value<String?>? lastError,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? version,
      Value<int>? rowid}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PeriodEntriesTable periodEntries = $PeriodEntriesTable(this);
  late final $PredictionsTable predictions = $PredictionsTable(this);
  late final $PeriodDayLogsTable periodDayLogs = $PeriodDayLogsTable(this);
  late final $UserCycleSettingsTable userCycleSettings =
      $UserCycleSettingsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        periodEntries,
        predictions,
        periodDayLogs,
        userCycleSettings,
        appSettings,
        syncQueue
      ];
}

typedef $$PeriodEntriesTableCreateCompanionBuilder = PeriodEntriesCompanion
    Function({
  required String id,
  Value<String?> userId,
  required String startDate,
  Value<String?> endDate,
  Value<int?> cycleLengthDays,
  Value<int?> periodDurationDays,
  Value<String?> predictedStartAtEntry,
  Value<String?> windowStartAtEntry,
  Value<String?> windowEndAtEntry,
  Value<int?> varianceDays,
  Value<String?> classification,
  Value<String?> notes,
  required String createdAt,
  required String updatedAt,
  Value<String?> deletedAt,
  Value<String> syncStatus,
  Value<String?> remoteUpdatedAt,
  Value<int> version,
  Value<String?> predictionConfidenceAtEntry,
  Value<String?> predictionModelVersionAtEntry,
  Value<int?> predictionSampleSizeAtEntry,
  Value<String?> predictionSnapshotAt,
  Value<int> rowid,
});
typedef $$PeriodEntriesTableUpdateCompanionBuilder = PeriodEntriesCompanion
    Function({
  Value<String> id,
  Value<String?> userId,
  Value<String> startDate,
  Value<String?> endDate,
  Value<int?> cycleLengthDays,
  Value<int?> periodDurationDays,
  Value<String?> predictedStartAtEntry,
  Value<String?> windowStartAtEntry,
  Value<String?> windowEndAtEntry,
  Value<int?> varianceDays,
  Value<String?> classification,
  Value<String?> notes,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String?> deletedAt,
  Value<String> syncStatus,
  Value<String?> remoteUpdatedAt,
  Value<int> version,
  Value<String?> predictionConfidenceAtEntry,
  Value<String?> predictionModelVersionAtEntry,
  Value<int?> predictionSampleSizeAtEntry,
  Value<String?> predictionSnapshotAt,
  Value<int> rowid,
});

class $$PeriodEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodEntriesTable> {
  $$PeriodEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cycleLengthDays => $composableBuilder(
      column: $table.cycleLengthDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get periodDurationDays => $composableBuilder(
      column: $table.periodDurationDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get predictedStartAtEntry => $composableBuilder(
      column: $table.predictedStartAtEntry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get windowStartAtEntry => $composableBuilder(
      column: $table.windowStartAtEntry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get windowEndAtEntry => $composableBuilder(
      column: $table.windowEndAtEntry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get varianceDays => $composableBuilder(
      column: $table.varianceDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classification => $composableBuilder(
      column: $table.classification,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get predictionConfidenceAtEntry => $composableBuilder(
      column: $table.predictionConfidenceAtEntry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get predictionModelVersionAtEntry => $composableBuilder(
      column: $table.predictionModelVersionAtEntry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get predictionSampleSizeAtEntry => $composableBuilder(
      column: $table.predictionSampleSizeAtEntry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get predictionSnapshotAt => $composableBuilder(
      column: $table.predictionSnapshotAt,
      builder: (column) => ColumnFilters(column));
}

class $$PeriodEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodEntriesTable> {
  $$PeriodEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cycleLengthDays => $composableBuilder(
      column: $table.cycleLengthDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get periodDurationDays => $composableBuilder(
      column: $table.periodDurationDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get predictedStartAtEntry => $composableBuilder(
      column: $table.predictedStartAtEntry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get windowStartAtEntry => $composableBuilder(
      column: $table.windowStartAtEntry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get windowEndAtEntry => $composableBuilder(
      column: $table.windowEndAtEntry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get varianceDays => $composableBuilder(
      column: $table.varianceDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classification => $composableBuilder(
      column: $table.classification,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get predictionConfidenceAtEntry => $composableBuilder(
      column: $table.predictionConfidenceAtEntry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get predictionModelVersionAtEntry =>
      $composableBuilder(
          column: $table.predictionModelVersionAtEntry,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get predictionSampleSizeAtEntry => $composableBuilder(
      column: $table.predictionSampleSizeAtEntry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get predictionSnapshotAt => $composableBuilder(
      column: $table.predictionSnapshotAt,
      builder: (column) => ColumnOrderings(column));
}

class $$PeriodEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodEntriesTable> {
  $$PeriodEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get cycleLengthDays => $composableBuilder(
      column: $table.cycleLengthDays, builder: (column) => column);

  GeneratedColumn<int> get periodDurationDays => $composableBuilder(
      column: $table.periodDurationDays, builder: (column) => column);

  GeneratedColumn<String> get predictedStartAtEntry => $composableBuilder(
      column: $table.predictedStartAtEntry, builder: (column) => column);

  GeneratedColumn<String> get windowStartAtEntry => $composableBuilder(
      column: $table.windowStartAtEntry, builder: (column) => column);

  GeneratedColumn<String> get windowEndAtEntry => $composableBuilder(
      column: $table.windowEndAtEntry, builder: (column) => column);

  GeneratedColumn<int> get varianceDays => $composableBuilder(
      column: $table.varianceDays, builder: (column) => column);

  GeneratedColumn<String> get classification => $composableBuilder(
      column: $table.classification, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<String> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get predictionConfidenceAtEntry => $composableBuilder(
      column: $table.predictionConfidenceAtEntry, builder: (column) => column);

  GeneratedColumn<String> get predictionModelVersionAtEntry =>
      $composableBuilder(
          column: $table.predictionModelVersionAtEntry,
          builder: (column) => column);

  GeneratedColumn<int> get predictionSampleSizeAtEntry => $composableBuilder(
      column: $table.predictionSampleSizeAtEntry, builder: (column) => column);

  GeneratedColumn<String> get predictionSnapshotAt => $composableBuilder(
      column: $table.predictionSnapshotAt, builder: (column) => column);
}

class $$PeriodEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeriodEntriesTable,
    PeriodEntry,
    $$PeriodEntriesTableFilterComposer,
    $$PeriodEntriesTableOrderingComposer,
    $$PeriodEntriesTableAnnotationComposer,
    $$PeriodEntriesTableCreateCompanionBuilder,
    $$PeriodEntriesTableUpdateCompanionBuilder,
    (
      PeriodEntry,
      BaseReferences<_$AppDatabase, $PeriodEntriesTable, PeriodEntry>
    ),
    PeriodEntry,
    PrefetchHooks Function()> {
  $$PeriodEntriesTableTableManager(_$AppDatabase db, $PeriodEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> startDate = const Value.absent(),
            Value<String?> endDate = const Value.absent(),
            Value<int?> cycleLengthDays = const Value.absent(),
            Value<int?> periodDurationDays = const Value.absent(),
            Value<String?> predictedStartAtEntry = const Value.absent(),
            Value<String?> windowStartAtEntry = const Value.absent(),
            Value<String?> windowEndAtEntry = const Value.absent(),
            Value<int?> varianceDays = const Value.absent(),
            Value<String?> classification = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<String?> remoteUpdatedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<String?> predictionConfidenceAtEntry = const Value.absent(),
            Value<String?> predictionModelVersionAtEntry = const Value.absent(),
            Value<int?> predictionSampleSizeAtEntry = const Value.absent(),
            Value<String?> predictionSnapshotAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PeriodEntriesCompanion(
            id: id,
            userId: userId,
            startDate: startDate,
            endDate: endDate,
            cycleLengthDays: cycleLengthDays,
            periodDurationDays: periodDurationDays,
            predictedStartAtEntry: predictedStartAtEntry,
            windowStartAtEntry: windowStartAtEntry,
            windowEndAtEntry: windowEndAtEntry,
            varianceDays: varianceDays,
            classification: classification,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            remoteUpdatedAt: remoteUpdatedAt,
            version: version,
            predictionConfidenceAtEntry: predictionConfidenceAtEntry,
            predictionModelVersionAtEntry: predictionModelVersionAtEntry,
            predictionSampleSizeAtEntry: predictionSampleSizeAtEntry,
            predictionSnapshotAt: predictionSnapshotAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> userId = const Value.absent(),
            required String startDate,
            Value<String?> endDate = const Value.absent(),
            Value<int?> cycleLengthDays = const Value.absent(),
            Value<int?> periodDurationDays = const Value.absent(),
            Value<String?> predictedStartAtEntry = const Value.absent(),
            Value<String?> windowStartAtEntry = const Value.absent(),
            Value<String?> windowEndAtEntry = const Value.absent(),
            Value<int?> varianceDays = const Value.absent(),
            Value<String?> classification = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<String?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<String?> remoteUpdatedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<String?> predictionConfidenceAtEntry = const Value.absent(),
            Value<String?> predictionModelVersionAtEntry = const Value.absent(),
            Value<int?> predictionSampleSizeAtEntry = const Value.absent(),
            Value<String?> predictionSnapshotAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PeriodEntriesCompanion.insert(
            id: id,
            userId: userId,
            startDate: startDate,
            endDate: endDate,
            cycleLengthDays: cycleLengthDays,
            periodDurationDays: periodDurationDays,
            predictedStartAtEntry: predictedStartAtEntry,
            windowStartAtEntry: windowStartAtEntry,
            windowEndAtEntry: windowEndAtEntry,
            varianceDays: varianceDays,
            classification: classification,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            remoteUpdatedAt: remoteUpdatedAt,
            version: version,
            predictionConfidenceAtEntry: predictionConfidenceAtEntry,
            predictionModelVersionAtEntry: predictionModelVersionAtEntry,
            predictionSampleSizeAtEntry: predictionSampleSizeAtEntry,
            predictionSnapshotAt: predictionSnapshotAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PeriodEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeriodEntriesTable,
    PeriodEntry,
    $$PeriodEntriesTableFilterComposer,
    $$PeriodEntriesTableOrderingComposer,
    $$PeriodEntriesTableAnnotationComposer,
    $$PeriodEntriesTableCreateCompanionBuilder,
    $$PeriodEntriesTableUpdateCompanionBuilder,
    (
      PeriodEntry,
      BaseReferences<_$AppDatabase, $PeriodEntriesTable, PeriodEntry>
    ),
    PeriodEntry,
    PrefetchHooks Function()>;
typedef $$PredictionsTableCreateCompanionBuilder = PredictionsCompanion
    Function({
  required String id,
  Value<String?> userId,
  required String generatedAt,
  required String predictedStart,
  required String windowStart,
  required String windowEnd,
  required int baselineCycleDays,
  required int variabilityDays,
  required String confidence,
  required int basedOnCycles,
  required String modelVersion,
  Value<int> rowid,
});
typedef $$PredictionsTableUpdateCompanionBuilder = PredictionsCompanion
    Function({
  Value<String> id,
  Value<String?> userId,
  Value<String> generatedAt,
  Value<String> predictedStart,
  Value<String> windowStart,
  Value<String> windowEnd,
  Value<int> baselineCycleDays,
  Value<int> variabilityDays,
  Value<String> confidence,
  Value<int> basedOnCycles,
  Value<String> modelVersion,
  Value<int> rowid,
});

class $$PredictionsTableFilterComposer
    extends Composer<_$AppDatabase, $PredictionsTable> {
  $$PredictionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get predictedStart => $composableBuilder(
      column: $table.predictedStart,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get windowStart => $composableBuilder(
      column: $table.windowStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get windowEnd => $composableBuilder(
      column: $table.windowEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get baselineCycleDays => $composableBuilder(
      column: $table.baselineCycleDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get variabilityDays => $composableBuilder(
      column: $table.variabilityDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get basedOnCycles => $composableBuilder(
      column: $table.basedOnCycles, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelVersion => $composableBuilder(
      column: $table.modelVersion, builder: (column) => ColumnFilters(column));
}

class $$PredictionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PredictionsTable> {
  $$PredictionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get predictedStart => $composableBuilder(
      column: $table.predictedStart,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get windowStart => $composableBuilder(
      column: $table.windowStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get windowEnd => $composableBuilder(
      column: $table.windowEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get baselineCycleDays => $composableBuilder(
      column: $table.baselineCycleDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get variabilityDays => $composableBuilder(
      column: $table.variabilityDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get basedOnCycles => $composableBuilder(
      column: $table.basedOnCycles,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelVersion => $composableBuilder(
      column: $table.modelVersion,
      builder: (column) => ColumnOrderings(column));
}

class $$PredictionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PredictionsTable> {
  $$PredictionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => column);

  GeneratedColumn<String> get predictedStart => $composableBuilder(
      column: $table.predictedStart, builder: (column) => column);

  GeneratedColumn<String> get windowStart => $composableBuilder(
      column: $table.windowStart, builder: (column) => column);

  GeneratedColumn<String> get windowEnd =>
      $composableBuilder(column: $table.windowEnd, builder: (column) => column);

  GeneratedColumn<int> get baselineCycleDays => $composableBuilder(
      column: $table.baselineCycleDays, builder: (column) => column);

  GeneratedColumn<int> get variabilityDays => $composableBuilder(
      column: $table.variabilityDays, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<int> get basedOnCycles => $composableBuilder(
      column: $table.basedOnCycles, builder: (column) => column);

  GeneratedColumn<String> get modelVersion => $composableBuilder(
      column: $table.modelVersion, builder: (column) => column);
}

class $$PredictionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PredictionsTable,
    Prediction,
    $$PredictionsTableFilterComposer,
    $$PredictionsTableOrderingComposer,
    $$PredictionsTableAnnotationComposer,
    $$PredictionsTableCreateCompanionBuilder,
    $$PredictionsTableUpdateCompanionBuilder,
    (Prediction, BaseReferences<_$AppDatabase, $PredictionsTable, Prediction>),
    Prediction,
    PrefetchHooks Function()> {
  $$PredictionsTableTableManager(_$AppDatabase db, $PredictionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PredictionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PredictionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PredictionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> generatedAt = const Value.absent(),
            Value<String> predictedStart = const Value.absent(),
            Value<String> windowStart = const Value.absent(),
            Value<String> windowEnd = const Value.absent(),
            Value<int> baselineCycleDays = const Value.absent(),
            Value<int> variabilityDays = const Value.absent(),
            Value<String> confidence = const Value.absent(),
            Value<int> basedOnCycles = const Value.absent(),
            Value<String> modelVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PredictionsCompanion(
            id: id,
            userId: userId,
            generatedAt: generatedAt,
            predictedStart: predictedStart,
            windowStart: windowStart,
            windowEnd: windowEnd,
            baselineCycleDays: baselineCycleDays,
            variabilityDays: variabilityDays,
            confidence: confidence,
            basedOnCycles: basedOnCycles,
            modelVersion: modelVersion,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> userId = const Value.absent(),
            required String generatedAt,
            required String predictedStart,
            required String windowStart,
            required String windowEnd,
            required int baselineCycleDays,
            required int variabilityDays,
            required String confidence,
            required int basedOnCycles,
            required String modelVersion,
            Value<int> rowid = const Value.absent(),
          }) =>
              PredictionsCompanion.insert(
            id: id,
            userId: userId,
            generatedAt: generatedAt,
            predictedStart: predictedStart,
            windowStart: windowStart,
            windowEnd: windowEnd,
            baselineCycleDays: baselineCycleDays,
            variabilityDays: variabilityDays,
            confidence: confidence,
            basedOnCycles: basedOnCycles,
            modelVersion: modelVersion,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PredictionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PredictionsTable,
    Prediction,
    $$PredictionsTableFilterComposer,
    $$PredictionsTableOrderingComposer,
    $$PredictionsTableAnnotationComposer,
    $$PredictionsTableCreateCompanionBuilder,
    $$PredictionsTableUpdateCompanionBuilder,
    (Prediction, BaseReferences<_$AppDatabase, $PredictionsTable, Prediction>),
    Prediction,
    PrefetchHooks Function()>;
typedef $$PeriodDayLogsTableCreateCompanionBuilder = PeriodDayLogsCompanion
    Function({
  required String id,
  Value<String?> userId,
  required String periodEntryId,
  required String logDate,
  required String flow,
  required String createdAt,
  required String updatedAt,
  Value<String?> deletedAt,
  Value<String> syncStatus,
  Value<String?> remoteUpdatedAt,
  Value<int> version,
  Value<int> rowid,
});
typedef $$PeriodDayLogsTableUpdateCompanionBuilder = PeriodDayLogsCompanion
    Function({
  Value<String> id,
  Value<String?> userId,
  Value<String> periodEntryId,
  Value<String> logDate,
  Value<String> flow,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<String?> deletedAt,
  Value<String> syncStatus,
  Value<String?> remoteUpdatedAt,
  Value<int> version,
  Value<int> rowid,
});

class $$PeriodDayLogsTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodDayLogsTable> {
  $$PeriodDayLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get periodEntryId => $composableBuilder(
      column: $table.periodEntryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logDate => $composableBuilder(
      column: $table.logDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flow => $composableBuilder(
      column: $table.flow, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$PeriodDayLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodDayLogsTable> {
  $$PeriodDayLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get periodEntryId => $composableBuilder(
      column: $table.periodEntryId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logDate => $composableBuilder(
      column: $table.logDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flow => $composableBuilder(
      column: $table.flow, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$PeriodDayLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodDayLogsTable> {
  $$PeriodDayLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get periodEntryId => $composableBuilder(
      column: $table.periodEntryId, builder: (column) => column);

  GeneratedColumn<String> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<String> get flow =>
      $composableBuilder(column: $table.flow, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<String> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$PeriodDayLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeriodDayLogsTable,
    PeriodDayLog,
    $$PeriodDayLogsTableFilterComposer,
    $$PeriodDayLogsTableOrderingComposer,
    $$PeriodDayLogsTableAnnotationComposer,
    $$PeriodDayLogsTableCreateCompanionBuilder,
    $$PeriodDayLogsTableUpdateCompanionBuilder,
    (
      PeriodDayLog,
      BaseReferences<_$AppDatabase, $PeriodDayLogsTable, PeriodDayLog>
    ),
    PeriodDayLog,
    PrefetchHooks Function()> {
  $$PeriodDayLogsTableTableManager(_$AppDatabase db, $PeriodDayLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodDayLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodDayLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodDayLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> periodEntryId = const Value.absent(),
            Value<String> logDate = const Value.absent(),
            Value<String> flow = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<String?> remoteUpdatedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PeriodDayLogsCompanion(
            id: id,
            userId: userId,
            periodEntryId: periodEntryId,
            logDate: logDate,
            flow: flow,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            remoteUpdatedAt: remoteUpdatedAt,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> userId = const Value.absent(),
            required String periodEntryId,
            required String logDate,
            required String flow,
            required String createdAt,
            required String updatedAt,
            Value<String?> deletedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<String?> remoteUpdatedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PeriodDayLogsCompanion.insert(
            id: id,
            userId: userId,
            periodEntryId: periodEntryId,
            logDate: logDate,
            flow: flow,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncStatus: syncStatus,
            remoteUpdatedAt: remoteUpdatedAt,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PeriodDayLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeriodDayLogsTable,
    PeriodDayLog,
    $$PeriodDayLogsTableFilterComposer,
    $$PeriodDayLogsTableOrderingComposer,
    $$PeriodDayLogsTableAnnotationComposer,
    $$PeriodDayLogsTableCreateCompanionBuilder,
    $$PeriodDayLogsTableUpdateCompanionBuilder,
    (
      PeriodDayLog,
      BaseReferences<_$AppDatabase, $PeriodDayLogsTable, PeriodDayLog>
    ),
    PeriodDayLog,
    PrefetchHooks Function()>;
typedef $$UserCycleSettingsTableCreateCompanionBuilder
    = UserCycleSettingsCompanion Function({
  required String userId,
  Value<bool> showOvulationEstimate,
  Value<bool> showFertileWindow,
  Value<bool> reminderEnabled,
  Value<String?> lastSummaryPeriodId,
  Value<String?> lastSuccessfulSyncAt,
  Value<bool> initialSyncCompleted,
  required String updatedAt,
  Value<String?> remoteUpdatedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});
typedef $$UserCycleSettingsTableUpdateCompanionBuilder
    = UserCycleSettingsCompanion Function({
  Value<String> userId,
  Value<bool> showOvulationEstimate,
  Value<bool> showFertileWindow,
  Value<bool> reminderEnabled,
  Value<String?> lastSummaryPeriodId,
  Value<String?> lastSuccessfulSyncAt,
  Value<bool> initialSyncCompleted,
  Value<String> updatedAt,
  Value<String?> remoteUpdatedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});

class $$UserCycleSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserCycleSettingsTable> {
  $$UserCycleSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showOvulationEstimate => $composableBuilder(
      column: $table.showOvulationEstimate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showFertileWindow => $composableBuilder(
      column: $table.showFertileWindow,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastSummaryPeriodId => $composableBuilder(
      column: $table.lastSummaryPeriodId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastSuccessfulSyncAt => $composableBuilder(
      column: $table.lastSuccessfulSyncAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get initialSyncCompleted => $composableBuilder(
      column: $table.initialSyncCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$UserCycleSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserCycleSettingsTable> {
  $$UserCycleSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showOvulationEstimate => $composableBuilder(
      column: $table.showOvulationEstimate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showFertileWindow => $composableBuilder(
      column: $table.showFertileWindow,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastSummaryPeriodId => $composableBuilder(
      column: $table.lastSummaryPeriodId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastSuccessfulSyncAt => $composableBuilder(
      column: $table.lastSuccessfulSyncAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get initialSyncCompleted => $composableBuilder(
      column: $table.initialSyncCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$UserCycleSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserCycleSettingsTable> {
  $$UserCycleSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get showOvulationEstimate => $composableBuilder(
      column: $table.showOvulationEstimate, builder: (column) => column);

  GeneratedColumn<bool> get showFertileWindow => $composableBuilder(
      column: $table.showFertileWindow, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled, builder: (column) => column);

  GeneratedColumn<String> get lastSummaryPeriodId => $composableBuilder(
      column: $table.lastSummaryPeriodId, builder: (column) => column);

  GeneratedColumn<String> get lastSuccessfulSyncAt => $composableBuilder(
      column: $table.lastSuccessfulSyncAt, builder: (column) => column);

  GeneratedColumn<bool> get initialSyncCompleted => $composableBuilder(
      column: $table.initialSyncCompleted, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$UserCycleSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserCycleSettingsTable,
    UserCycleSetting,
    $$UserCycleSettingsTableFilterComposer,
    $$UserCycleSettingsTableOrderingComposer,
    $$UserCycleSettingsTableAnnotationComposer,
    $$UserCycleSettingsTableCreateCompanionBuilder,
    $$UserCycleSettingsTableUpdateCompanionBuilder,
    (
      UserCycleSetting,
      BaseReferences<_$AppDatabase, $UserCycleSettingsTable, UserCycleSetting>
    ),
    UserCycleSetting,
    PrefetchHooks Function()> {
  $$UserCycleSettingsTableTableManager(
      _$AppDatabase db, $UserCycleSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserCycleSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserCycleSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserCycleSettingsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<bool> showOvulationEstimate = const Value.absent(),
            Value<bool> showFertileWindow = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<String?> lastSummaryPeriodId = const Value.absent(),
            Value<String?> lastSuccessfulSyncAt = const Value.absent(),
            Value<bool> initialSyncCompleted = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<String?> remoteUpdatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserCycleSettingsCompanion(
            userId: userId,
            showOvulationEstimate: showOvulationEstimate,
            showFertileWindow: showFertileWindow,
            reminderEnabled: reminderEnabled,
            lastSummaryPeriodId: lastSummaryPeriodId,
            lastSuccessfulSyncAt: lastSuccessfulSyncAt,
            initialSyncCompleted: initialSyncCompleted,
            updatedAt: updatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            Value<bool> showOvulationEstimate = const Value.absent(),
            Value<bool> showFertileWindow = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<String?> lastSummaryPeriodId = const Value.absent(),
            Value<String?> lastSuccessfulSyncAt = const Value.absent(),
            Value<bool> initialSyncCompleted = const Value.absent(),
            required String updatedAt,
            Value<String?> remoteUpdatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserCycleSettingsCompanion.insert(
            userId: userId,
            showOvulationEstimate: showOvulationEstimate,
            showFertileWindow: showFertileWindow,
            reminderEnabled: reminderEnabled,
            lastSummaryPeriodId: lastSummaryPeriodId,
            lastSuccessfulSyncAt: lastSuccessfulSyncAt,
            initialSyncCompleted: initialSyncCompleted,
            updatedAt: updatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserCycleSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserCycleSettingsTable,
    UserCycleSetting,
    $$UserCycleSettingsTableFilterComposer,
    $$UserCycleSettingsTableOrderingComposer,
    $$UserCycleSettingsTableAnnotationComposer,
    $$UserCycleSettingsTableCreateCompanionBuilder,
    $$UserCycleSettingsTableUpdateCompanionBuilder,
    (
      UserCycleSetting,
      BaseReferences<_$AppDatabase, $UserCycleSettingsTable, UserCycleSetting>
    ),
    UserCycleSetting,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  Value<String?> value,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String?> value,
  Value<String> updatedAt,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            Value<String?> value = const Value.absent(),
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String id,
  Value<String?> userId,
  required String entityType,
  required String entityId,
  required String operation,
  required String payload,
  Value<int> attemptCount,
  Value<String?> lastError,
  required String createdAt,
  required String updatedAt,
  Value<int> version,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<String> payload,
  Value<int> attemptCount,
  Value<String?> lastError,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<int> version,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<int> attemptCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            userId: userId,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            attemptCount: attemptCount,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> userId = const Value.absent(),
            required String entityType,
            required String entityId,
            required String operation,
            required String payload,
            Value<int> attemptCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            userId: userId,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            attemptCount: attemptCount,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PeriodEntriesTableTableManager get periodEntries =>
      $$PeriodEntriesTableTableManager(_db, _db.periodEntries);
  $$PredictionsTableTableManager get predictions =>
      $$PredictionsTableTableManager(_db, _db.predictions);
  $$PeriodDayLogsTableTableManager get periodDayLogs =>
      $$PeriodDayLogsTableTableManager(_db, _db.periodDayLogs);
  $$UserCycleSettingsTableTableManager get userCycleSettings =>
      $$UserCycleSettingsTableTableManager(_db, _db.userCycleSettings);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
