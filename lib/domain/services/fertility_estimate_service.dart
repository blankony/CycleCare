import '../entities/cycle_insights.dart';
import '../entities/prediction.dart';

class FertilityEstimateService {
  const FertilityEstimateService();

  FertilityEstimate? calculate(CyclePrediction? prediction) {
    if (prediction?.ready != true) return null;
    final ovulationCenter =
        prediction!.predictedStart!.subtract(const Duration(days: 14));
    final earliest = prediction.windowStart!.subtract(const Duration(days: 14));
    final latest = prediction.windowEnd!.subtract(const Duration(days: 14));
    return FertilityEstimate(
      ovulationCenter: ovulationCenter,
      earliestOvulation: earliest,
      latestOvulation: latest,
      fertileWindowStart: earliest.subtract(const Duration(days: 5)),
      fertileWindowEnd: latest.add(const Duration(days: 1)),
      confidence: prediction.confidence!,
    );
  }
}
