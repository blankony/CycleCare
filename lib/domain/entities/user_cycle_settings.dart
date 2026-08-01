class UserCycleSettingsRecord {
  const UserCycleSettingsRecord({
    required this.userId,
    required this.showOvulationEstimate,
    required this.showFertileWindow,
    required this.reminderEnabled,
    required this.initialSyncCompleted,
    required this.updatedAt,
    this.lastSummaryPeriodId,
    this.lastSuccessfulSyncAt,
  });

  final String userId;
  final bool showOvulationEstimate;
  final bool showFertileWindow;
  final bool reminderEnabled;
  final String? lastSummaryPeriodId;
  final DateTime? lastSuccessfulSyncAt;
  final bool initialSyncCompleted;
  final DateTime updatedAt;
}
