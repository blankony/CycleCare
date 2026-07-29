import 'enums.dart';

class PeriodRecord {
  const PeriodRecord({
    required this.id,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.endDate,
    this.cycleLengthDays,
    this.periodDurationDays,
    this.predictedStartAtEntry,
    this.windowStartAtEntry,
    this.windowEndAtEntry,
    this.varianceDays,
    this.classification,
    this.notes,
    this.deletedAt,
    this.remoteUpdatedAt,
  });

  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final int? cycleLengthDays;
  final int? periodDurationDays;
  final DateTime? predictedStartAtEntry;
  final DateTime? windowStartAtEntry;
  final DateTime? windowEndAtEntry;
  final int? varianceDays;
  final PeriodClassification? classification;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncStatus syncStatus;
  final DateTime? remoteUpdatedAt;

  PeriodRecord copyWith({
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    int? cycleLengthDays,
    int? periodDurationDays,
    DateTime? predictedStartAtEntry,
    DateTime? windowStartAtEntry,
    DateTime? windowEndAtEntry,
    int? varianceDays,
    PeriodClassification? classification,
    String? notes,
    DateTime? deletedAt,
    SyncStatus? syncStatus,
    DateTime? remoteUpdatedAt,
  }) =>
      PeriodRecord(
        id: id,
        startDate: startDate ?? this.startDate,
        endDate: clearEndDate ? null : (endDate ?? this.endDate),
        cycleLengthDays: cycleLengthDays ?? this.cycleLengthDays,
        periodDurationDays: periodDurationDays ?? this.periodDurationDays,
        predictedStartAtEntry:
            predictedStartAtEntry ?? this.predictedStartAtEntry,
        windowStartAtEntry: windowStartAtEntry ?? this.windowStartAtEntry,
        windowEndAtEntry: windowEndAtEntry ?? this.windowEndAtEntry,
        varianceDays: varianceDays ?? this.varianceDays,
        classification: classification ?? this.classification,
        notes: notes ?? this.notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      );
}
