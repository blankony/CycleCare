import '../entities/cycle_insights.dart';
import '../entities/enums.dart';
import '../entities/prediction.dart';

class FutureCycleProjectionService {
  const FutureCycleProjectionService();

  List<FutureCycleProjection> project(
    CyclePrediction? prediction, {
    int count = 6,
  }) {
    if (prediction?.ready != true) return const [];
    final baseline = prediction!.baselineCycleDays!;
    final variability = prediction.variabilityDays!;
    return List.generate(count, (index) {
      final sequence = index + 1;
      final center =
          prediction.predictedStart!.add(Duration(days: baseline * index));
      final uncertainty = variability * sequence;
      return FutureCycleProjection(
        sequence: sequence,
        predictedStart: center,
        windowStart: center.subtract(Duration(days: uncertainty)),
        windowEnd: center.add(Duration(days: uncertainty)),
        certainty: sequence == 1
            ? ProjectionCertainty.active
            : sequence <= 3
                ? ProjectionCertainty.reduced
                : ProjectionCertainty.low,
        confidence:
            sequence == 1 ? prediction.confidence! : PredictionConfidence.low,
      );
    });
  }
}
