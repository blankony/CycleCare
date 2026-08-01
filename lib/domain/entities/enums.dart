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

enum MenstrualFlow { spotting, light, medium, heavy }

extension MenstrualFlowText on MenstrualFlow {
  String get value => name.toUpperCase();

  String get label => switch (this) {
        MenstrualFlow.spotting => 'Bercak',
        MenstrualFlow.light => 'Ringan',
        MenstrualFlow.medium => 'Sedang',
        MenstrualFlow.heavy => 'Deras',
      };

  String get indicator => switch (this) {
        MenstrualFlow.spotting => 'B',
        MenstrualFlow.light => 'R',
        MenstrualFlow.medium => 'S',
        MenstrualFlow.heavy => 'D',
      };

  static MenstrualFlow? fromValue(String? value) {
    if (value == null) return null;
    for (final flow in MenstrualFlow.values) {
      if (flow.value == value) return flow;
    }
    return null;
  }
}

enum CyclePattern { insufficientData, consistent, variable, highlyVariable }

extension CyclePatternText on CyclePattern {
  String get label => switch (this) {
        CyclePattern.insufficientData => 'Data belum cukup',
        CyclePattern.consistent => 'Cukup konsisten',
        CyclePattern.variable => 'Bervariasi',
        CyclePattern.highlyVariable => 'Sangat bervariasi',
      };
}

enum ReferenceComparison { insufficientData, withinRange, outsideRange }

extension ReferenceComparisonText on ReferenceComparison {
  String get label => switch (this) {
        ReferenceComparison.insufficientData => 'Data belum cukup',
        ReferenceComparison.withinRange => 'Dalam rentang referensi umum',
        ReferenceComparison.outsideRange => 'Di luar rentang referensi umum',
      };
}

enum ProjectionCertainty { active, reduced, low }
