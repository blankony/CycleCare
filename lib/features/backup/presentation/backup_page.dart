import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../app/widgets/cycle_care_settings_group.dart';

class BackupPage extends ConsumerWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastSync = ref.watch(syncSnapshotProvider).lastSuccessfulSyncAt;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CycleCareAppBar(title: 'Backup & restore'),
      body: CycleCareBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final body = ListView(
              padding: const EdgeInsets.fromLTRB(
                CycleCareSpacing.page,
                CycleCareSpacing.md,
                CycleCareSpacing.page,
                CycleCareSpacing.xl,
              ),
              children: [
                _BackupSummaryCard(lastSync: lastSync),
                const SizedBox(height: CycleCareSpacing.md),
                CycleCareSectionGroup(
                  title: 'Ekspor catatan',
                  subtitle:
                      'Membuat berkas JSON schema v2 yang dapat dibagikan melalui lembar bagikan sistem.',
                  children: [
                    CycleCareSettingsTile(
                      icon: Icons.file_upload_outlined,
                      title: 'Bagikan backup',
                      subtitle:
                          'Ekspor period, flow harian, prediksi, dan pengaturan sebagai JSON.',
                      onTap: () => _export(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: CycleCareSpacing.md),
                CycleCareSectionGroup(
                  title: 'Pulihkan catatan',
                  subtitle:
                      'Impor dari berkas JSON schema v1 atau v2. Data dapat digabung atau diganti total.',
                  children: [
                    CycleCareSettingsTile(
                      icon: Icons.merge_type_outlined,
                      title: 'Impor tanpa mengganti data',
                      subtitle:
                          'Menambahkan catatan dari backup ke catatan lokal saat ini.',
                      onTap: () => _import(context, ref, replace: false),
                    ),
                    CycleCareSettingsTile(
                      icon: Icons.swap_horiz,
                      title: 'Ganti seluruh data lokal',
                      subtitle:
                          'Menghapus data lokal terlebih dahulu lalu menggantinya dengan isi backup.',
                      destructive: true,
                      onTap: () => _import(context, ref, replace: true),
                    ),
                  ],
                ),
                const SizedBox(height: CycleCareSpacing.md),
                const _BackupNotice(),
                const SizedBox(height: CycleCareSpacing.lg),
                const MedicalDisclaimer(),
              ],
            );
            if (constraints.maxWidth >= 900) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: body,
                ),
              );
            }
            return body;
          },
        ),
      ),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(backupServiceProvider).shareExport();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup siap dibagikan.')));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ekspor backup gagal: $error')));
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref,
      {required bool replace}) async {
    if (replace) {
      final first = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ganti seluruh data lokal?'),
          content: const Text(
              'Data lokal akan dihapus dan diganti dengan isi backup. Tindakan ini tidak dapat dibatalkan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Lanjut'),
            ),
          ],
        ),
      );
      if (first != true) return;
    }
    try {
      await ref
          .read(backupServiceProvider)
          .importFromPicker(replaceExisting: replace);
      await ref.read(recalculationServiceProvider).recalculate();
      await ref.read(syncControllerProvider).synchronizeNow();
      ref.invalidate(activePeriodsProvider);
      ref.invalidate(predictionProvider);
      ref.invalidate(settingsProvider);
      ref.invalidate(userCycleSettingsProvider);
      ref.invalidate(flowLogsProvider);
      ref.invalidate(cycleStatisticsProvider);
      ref.invalidate(cycleInsightsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(replace
              ? 'Data lokal diganti dari backup.'
              : 'Backup digabung ke catatan lokal.')));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Import gagal: $error')));
    }
  }
}

class _BackupSummaryCard extends StatelessWidget {
  const _BackupSummaryCard({required this.lastSync});

  final DateTime? lastSync;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.cycleCareColors;
    return CycleCareCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(CycleCareRadius.pill),
            ),
            child: Icon(Icons.cloud_done_outlined,
                color: theme.colorScheme.primary),
          ),
          const SizedBox(width: CycleCareSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Backup & restore', style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'Berkas JSON tidak dienkripsi dan berisi catatan kesehatan. Simpan di tempat yang aman.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: CycleCareSpacing.sm),
                Text(
                  lastSync == null
                      ? 'Sinkronisasi cloud terakhir: belum pernah berhasil'
                      : 'Sinkronisasi cloud terakhir: ${DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(lastSync!.toLocal())}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackupNotice extends StatelessWidget {
  const _BackupNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.cycleCareColors;
    return CycleCareCard(
      color: colors.surfaceMuted,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 20),
          const SizedBox(width: CycleCareSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Format backup', style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Schema v2 menyertakan period, flow harian, prediksi, catatan, dan pengaturan yang disinkronkan. Schema v1 lama tetap dapat diimpor.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
