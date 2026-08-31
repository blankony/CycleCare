import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/statistics_sections.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statistics = ref.watch(cycleStatisticsProvider);
    return Scaffold(
      appBar: CycleCareAppBar(title: l10n.historyPersonalStats),
      body: CycleCareBackground(
        child: statistics.when(
          loading: () => CycleCareLoadingState(
            message: l10n.historyPreparing,
            cardCount: 4,
          ),
          error: (_, __) => CycleCareErrorState(
            message: l10n.historyLoadFailed,
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
