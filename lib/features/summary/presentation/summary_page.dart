import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../domain/entities/cycle_insights.dart';
import 'widgets/summary_sections.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({required this.periodId, super.key});

  final String periodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(endOfCycleSummaryProvider(periodId));
    final action = ref.watch(periodActionsProvider);

    return Scaffold(
      appBar: const CycleCareAppBar(title: 'Ringkasan siklus'),
      body: CycleCareBackground(
        child: summary.when(
          loading: () => const CycleCareLoadingState(
            message: 'Menyiapkan ringkasan siklusmu...',
            cardCount: 4,
          ),
          error: (_, __) => CycleCareErrorState(
            message:
                'Ringkasan belum dapat dimuat. Data kesehatanmu tetap aman di perangkat.',
            onRetry: () => ref.invalidate(
              endOfCycleSummaryProvider(periodId),
            ),
          ),
          data: (value) => value == null
              ? EmptyState(
                  icon: Icons.article_outlined,
                  title: 'Ringkasan tidak ditemukan',
                  message:
                      'Catatan ini mungkin sudah diarsipkan atau tidak lagi tersedia.',
                  action: OutlinedButton.icon(
                    onPressed: () => context.go('/history'),
                    icon: const Icon(Icons.history_rounded),
                    label: const Text('Kembali ke riwayat'),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Arsipkan catatan?'),
        content: const Text(
          'Catatan tidak dihapus permanen dan dapat dipulihkan dari Pengaturan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Arsipkan'),
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
        const SnackBar(
          content: Text(
            'Catatan belum dapat diarsipkan. Coba lagi tanpa mengubah data lain.',
          ),
        ),
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
