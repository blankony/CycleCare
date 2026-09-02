class PeriodDayLogRecord {
  const PeriodDayLogRecord({
    required this.id,
    required this.periodEntryId,
    required this.logDate,
    required this.flow,
    required this.createdAt,
    required this.updatedAt,
    this.symptomsCsv,
    this.moodsCsv,
    this.deletedAt,
  });

  final String id;
  final String periodEntryId;
  final DateTime logDate;
  final String flow;
  final String? symptomsCsv;
  final String? moodsCsv;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}

extension PeriodDayLogTags on PeriodDayLogRecord {
  List<String> get symptomTags => symptomsCsv == null || symptomsCsv!.isEmpty ? const [] : symptomsCsv!.split(',');
  List<String> get moodTags => moodsCsv == null || moodsCsv!.isEmpty ? const [] : moodsCsv!.split(',');
}
