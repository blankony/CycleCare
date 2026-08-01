class PeriodDayLogRecord {
  const PeriodDayLogRecord({
    required this.id,
    required this.periodEntryId,
    required this.logDate,
    required this.flow,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String periodEntryId;
  final DateTime logDate;
  final String flow;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
