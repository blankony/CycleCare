import '../../core/date/date_only.dart';
import '../entities/enums.dart';
import '../entities/prediction.dart';

class ClassificationService {
  const ClassificationService();

  ClassificationResult classify({
    required DateTime actualStart,
    required DateTime? predictedStart,
    required DateTime? windowStart,
    required DateTime? windowEnd,
  }) {
    if (predictedStart == null || windowStart == null || windowEnd == null) {
      return const ClassificationResult(
        classification: PeriodClassification.insufficientData,
        signedVarianceDays: 0,
        absoluteVarianceDays: 0,
      );
    }
    final normalizedActual = DateOnly.normalize(actualStart);
    final signedVarianceDays = DateOnly.differenceInDays(
      normalizedActual,
      DateOnly.normalize(predictedStart),
    );
    final classification =
        normalizedActual.isBefore(DateOnly.normalize(windowStart))
            ? PeriodClassification.early
            : normalizedActual.isAfter(DateOnly.normalize(windowEnd))
                ? PeriodClassification.late
                : PeriodClassification.onWindow;
    return ClassificationResult(
      classification: classification,
      signedVarianceDays: signedVarianceDays,
      absoluteVarianceDays: signedVarianceDays.abs(),
    );
  }
}
