enum PeriodClassification { early, onWindow, late, insufficientData }

extension PeriodClassificationText on PeriodClassification {
  String get value => switch (this) {
        PeriodClassification.early => 'EARLY',
        PeriodClassification.onWindow => 'ON_WINDOW',
        PeriodClassification.late => 'LATE',
        PeriodClassification.insufficientData => 'INSUFFICIENT_DATA',
      };

  String get label => switch (this) {
        PeriodClassification.early => 'Lebih awal',
        PeriodClassification.onWindow => 'Dalam rentang',
        PeriodClassification.late => 'Setelah rentang',
        PeriodClassification.insufficientData => 'Data belum cukup',
      };

  static PeriodClassification? fromValue(String? value) {
    for (final item in PeriodClassification.values) {
      if (item.value == value) return item;
    }
    return null;
  }
}

enum SyncStatus { pending, synced, failed }

enum PredictionConfidence { low, medium, high }

extension PredictionConfidenceText on PredictionConfidence {
  String get value => name.toUpperCase();

  String get label => switch (this) {
        PredictionConfidence.low => 'Rendah',
        PredictionConfidence.medium => 'Sedang',
        PredictionConfidence.high => 'Tinggi',
      };

  static PredictionConfidence fromValue(String value) =>
      PredictionConfidence.values.firstWhere(
        (item) => item.value == value,
        orElse: () => PredictionConfidence.low,
      );
}

enum SyncOperation { upsert, delete }
