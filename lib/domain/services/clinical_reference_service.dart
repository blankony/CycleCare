import '../entities/cycle_insights.dart';
import '../entities/enums.dart';

abstract final class AdultCycleReference {
  static const minimumCycleDays = 24;
  static const maximumCycleDays = 38;
  static const maximumBleedingDays = 8;
  static const methodology = 'Referensi umum siklus menstruasi dewasa';
  static const reviewedAt = '1 Agustus 2026';
}

class ClinicalReferenceService {
  const ClinicalReferenceService();

  AdultReferenceResult compare({
    int? cycleLengthDays,
    int? bleedingDurationDays,
  }) =>
      AdultReferenceResult(
        cycleLength: _cycle(cycleLengthDays),
        bleedingDuration: _duration(bleedingDurationDays),
      );

  ReferenceComparison _cycle(int? days) {
    if (days == null) return ReferenceComparison.insufficientData;
    return days >= AdultCycleReference.minimumCycleDays &&
            days <= AdultCycleReference.maximumCycleDays
        ? ReferenceComparison.withinRange
        : ReferenceComparison.outsideRange;
  }

  ReferenceComparison _duration(int? days) {
    if (days == null) return ReferenceComparison.insufficientData;
    return days <= AdultCycleReference.maximumBleedingDays
        ? ReferenceComparison.withinRange
        : ReferenceComparison.outsideRange;
  }
}
