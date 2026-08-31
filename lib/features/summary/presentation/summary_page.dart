import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../domain/entities/cycle_insights.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/summary_sections.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({required this.periodId, super.key});

  final String periodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(endOfCycleSummaryProvider(periodId));
    final action = ref.watch(periodActionsProvider);

    return Scaffold(
      appBar: CycleCareAppBar(title: l10n.historyPersonalStats),
      body: CycleCareBackground(
        child: summary.when(
          loading: () => CycleCareLoadingState(
            message: l10n.historyPreparing,
            cardCount: 4,
          ),
          error: (_, __) => CycleCareErrorState(
            message: l10n.historyLoadFailed,
            onRetry: () => ref.invalidate(
              endOfCycleSummaryProvider(periodId),
            ),
          ),
          data: (value) => value == null
              ? EmptyState(
                  icon: Icons.article_outlined,
                  title: l10n.historyEmptyTitle,
                  message: l10n.historyEmptyMessage,
                  action: OutlinedButton.icon(
                    onPressed: () => context.go('/history'),
                    icon: const Icon(Icons.history_rounded),
                    label: Text(l10n.commonBackToHistory),
                  ),
                )
              : CycleSummaryContent(
                  value: value,
                  isArchiving: action.isLoading,
                  onEdit: () => context.push(
                    '/add-period',
                    extra: value.period,
                  ),
                  onArchive: () => _archive(context, ref, value),
                ),
        ),
      ),
    );
  }

  Future<void> _archive(
    BuildContext context,
    WidgetRef ref,
    EndOfCycleSummary value,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.historyArchiveTitle),
        content: Text(l10n.historyArchiveMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.historyArchiveAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await ref.read(periodActionsProvider.notifier).delete(value.period.id);
    if (!context.mounted) return;

    final result = ref.read(periodActionsProvider);
    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.periodFormSaveFailed)),
      );
      return;
    }

    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/history');
    }
  }
}
