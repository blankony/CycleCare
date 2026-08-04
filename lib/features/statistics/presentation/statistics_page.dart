import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import 'widgets/statistics_sections.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(cycleStatisticsProvider);
    return Scaffold(
      appBar: const CycleCareAppBar(title: 'Statistik pribadi'),
      body: CycleCareBackground(
        child: statistics.when(
          loading: () => const CycleCareLoadingState(
            message: 'Menghitung statistik pribadimu...',
            cardCount: 4,
          ),
          error: (_, __) => CycleCareErrorState(
            message:
                'Statistik belum dapat dimuat. Data kesehatanmu tetap aman di perangkat.',
            onRetry: () => ref.invalidate(cycleStatisticsProvider),
          ),
          data: (value) => value.cycleLengthSamples < 2
              ? const StatisticsInsufficientState()
              : StatisticsContent(value: value),
        ),
      ),
    );
  }
}
