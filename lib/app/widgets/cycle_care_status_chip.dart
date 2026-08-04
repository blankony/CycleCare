import 'package:flutter/material.dart';

import '../../domain/entities/sync_state.dart';
import '../design/cycle_care_design.dart';

enum CycleCareStatusTone { neutral, success, warning, error, info }

class CycleCareStatusChip extends StatelessWidget {
  const CycleCareStatusChip({
    required this.label,
    required this.icon,
    this.tone = CycleCareStatusTone.neutral,
    super.key,
  });

  final String label;
  final IconData icon;
  final CycleCareStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.cycleCareColors;
    final (background, foreground) = switch (tone) {
      CycleCareStatusTone.success => (
          CycleCareColors.success.withValues(alpha: 0.14),
          CycleCareColors.success,
        ),
      CycleCareStatusTone.warning => (
          CycleCareColors.ovulationSoft.withValues(
            alpha: Theme.of(context).brightness == Brightness.dark ? 0.18 : 1,
          ),
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFFFE082)
              : CycleCareColors.warning,
        ),
      CycleCareStatusTone.error => (
          CycleCareColors.error.withValues(alpha: 0.14),
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFFFB4AB)
              : CycleCareColors.error,
        ),
      CycleCareStatusTone.info => (
          CycleCareColors.fertileSoft.withValues(
            alpha: Theme.of(context).brightness == Brightness.dark ? 0.16 : 1,
          ),
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFC6D2FF)
              : CycleCareColors.fertileStrong,
        ),
      CycleCareStatusTone.neutral => (
          colors.surfaceMuted,
          colors.textSecondary
        ),
    };

    return Semantics(
      label: label,
      child: Container(
        constraints: const BoxConstraints(minHeight: 32),
        padding: const EdgeInsets.symmetric(
          horizontal: CycleCareSpacing.sm,
          vertical: CycleCareSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(CycleCareRadius.pill),
          border: Border.all(color: colors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: foreground),
            const SizedBox(width: CycleCareSpacing.xxs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: foreground,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CycleCareSyncBanner extends StatelessWidget {
  const CycleCareSyncBanner({
    required this.snapshot,
    this.onRetry,
    super.key,
  });

  final SyncGateSnapshot snapshot;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final presentation = _presentation(snapshot);
    if (!presentation.shouldShow) return const SizedBox.shrink();

    final colors = context.cycleCareColors;
    return Semantics(
      container: true,
      liveRegion: true,
      label: '${presentation.title}. ${presentation.message}',
      child: Container(
        padding: const EdgeInsets.all(CycleCareSpacing.md),
        decoration: BoxDecoration(
          color: colors.surfaceMuted,
          borderRadius: CycleCareRadius.mediumBorder,
          border: Border.all(color: colors.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(presentation.icon, color: presentation.color),
            const SizedBox(width: CycleCareSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    presentation.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: CycleCareSpacing.xxs),
                  Text(
                    presentation.message,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (presentation.canRetry && onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: const Text('Coba lagi'),
              ),
          ],
        ),
      ),
    );
  }

  _SyncPresentation _presentation(SyncGateSnapshot snapshot) =>
      switch (snapshot.status) {
        SyncGateStatus.synchronizing => const _SyncPresentation(
            shouldShow: true,
            title: 'Sedang menyinkronkan',
            message: 'Data lokal tetap dapat digunakan selama proses berjalan.',
            icon: Icons.sync_rounded,
            color: CycleCareColors.fertileStrong,
          ),
        SyncGateStatus.offlineReady => _SyncPresentation(
            shouldShow: true,
            title: 'Tersimpan di perangkat',
            message: snapshot.pendingCount > 0
                ? '${snapshot.pendingCount} perubahan menunggu koneksi untuk disinkronkan.'
                : 'Kamu tetap dapat mencatat period saat offline.',
            icon: Icons.cloud_off_outlined,
            color: CycleCareColors.warning,
          ),
        SyncGateStatus.failed => const _SyncPresentation(
            shouldShow: true,
            title: 'Sinkronisasi belum selesai',
            message: 'Data lokalmu tetap tersimpan. Coba lagi saat siap.',
            icon: Icons.sync_problem_rounded,
            color: CycleCareColors.error,
            canRetry: true,
          ),
        _ => const _SyncPresentation.hidden(),
      };
}

class _SyncPresentation {
  const _SyncPresentation({
    required this.shouldShow,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.canRetry = false,
  });

  const _SyncPresentation.hidden()
      : shouldShow = false,
        title = '',
        message = '',
        icon = Icons.sync,
        color = Colors.transparent,
        canRetry = false;

  final bool shouldShow;
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final bool canRetry;
}
