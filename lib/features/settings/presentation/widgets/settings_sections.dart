import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../app/widgets/cycle_care_settings_group.dart';
import '../../../../core/date/date_only.dart';
import '../../../../domain/entities/sync_state.dart';

class CycleVisibilitySection extends ConsumerWidget {
  const CycleVisibilitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleSettings = ref.watch(userCycleSettingsProvider).valueOrNull;
    final showOvulation = cycleSettings?.showOvulationEstimate ?? false;
    final showFertile = cycleSettings?.showFertileWindow ?? false;
    return CycleCareSectionGroup(
      title: 'Tampilan siklus',
      children: [
        CycleCareSettingsTile(
          icon: Icons.water_drop_outlined,
          title: 'Perkiraan ovulasi',
          trailing: Switch.adaptive(
            key: const ValueKey('settings.ovulation.switch'),
            value: showOvulation,
            onChanged: (value) =>
                _setFertilityVisibility(context, ref, value, showFertile),
          ),
        ),
        CycleCareSettingsTile(
          icon: Icons.eco_outlined,
          title: 'Masa subur',
          trailing: Switch.adaptive(
            key: const ValueKey('settings.fertile.switch'),
            value: showFertile,
            onChanged: (value) =>
                _setFertilityVisibility(context, ref, showOvulation, value),
          ),
        ),
      ],
    );
  }

  Future<void> _setFertilityVisibility(BuildContext context, WidgetRef ref,
      bool showOvulation, bool showFertile) async {
    try {
      await ref
          .read(userCycleSettingsRepositoryProvider)
          .updateFertilityVisibility(
            showOvulationEstimate: showOvulation,
            showFertileWindow: showFertile,
          );
      ref.invalidate(userCycleSettingsProvider);
      ref.invalidate(cycleInsightsProvider);
      ref.invalidate(predictionProvider);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui preferensi: $error')),
      );
    }
  }
}

class ReminderSection extends ConsumerWidget {
  const ReminderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(settingsProvider).valueOrNull ?? const <String, String?>{};
    final reminderEnabled = settings['reminder_enabled'] == 'true';
    return CycleCareSectionGroup(
      title: 'Pengingat',
      children: [
        CycleCareSettingsTile(
          icon: Icons.notifications_active_outlined,
          title: 'Pengingat period',
          trailing: Switch.adaptive(
            key: const ValueKey('settings.reminder.switch'),
            value: reminderEnabled,
            onChanged: (value) async {
              await ref.read(notificationServiceProvider).requestPermission();
              await ref
                  .read(settingsRepositoryProvider)
                  .set('reminder_enabled', value ? 'true' : 'false');
              ref.invalidate(settingsProvider);
            },
          ),
        ),
      ],
    );
  }
}

class SecuritySection extends ConsumerWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(settingsProvider).valueOrNull ?? const <String, String?>{};
    final biometricEnabled = settings['biometric_enabled'] == 'true';
    return CycleCareSectionGroup(
      title: 'Keamanan',
      children: [
        CycleCareSettingsTile(
          icon: Icons.fingerprint,
          title: 'Kunci biometrik',
          trailing: Switch.adaptive(
            key: const ValueKey('settings.biometric.switch'),
            value: biometricEnabled,
            onChanged: (value) => _toggleBiometric(context, ref, value),
          ),
        ),
        CycleCareSettingsTile(
          icon: Icons.lock_open_outlined,
          title: 'Uji autentikasi perangkat',
          onTap: () => Navigator.of(context).pushNamed('/lock'),
        ),
      ],
    );
  }

  Future<void> _toggleBiometric(
      BuildContext context, WidgetRef ref, bool value) async {
    final security = ref.read(securityServiceProvider);
    final available = await security.isAvailable();
    if (!context.mounted) return;
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Perangkat ini tidak mendukung kunci biometrik.')));
      return;
    }
    if (value) {
      final authenticated = await security.authenticate();
      if (!context.mounted) return;
      if (!authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Autentikasi dibatalkan. Kunci tetap nonaktif.')));
        return;
      }
    }
    await ref
        .read(settingsRepositoryProvider)
        .set('biometric_enabled', value ? 'true' : 'false');
    ref.invalidate(settingsProvider);
  }
}

class CloudSyncSection extends ConsumerWidget {
  const CloudSyncSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncSnapshot = ref.watch(syncSnapshotProvider);
    final authUser = ref.watch(authSessionProvider).user;
    final last = syncSnapshot.lastSuccessfulSyncAt;
    return CycleCareSectionGroup(
      title: 'Cloud & sinkronisasi',
      children: [
        CycleCareSettingsTile(
          icon: Icons.cloud_outlined,
          title: 'Akun aktif',
          subtitle: authUser?.email ?? 'Akun Supabase',
        ),
        CycleCareSettingsTile(
          icon: Icons.sync,
          title: syncSnapshot.status == SyncGateStatus.failed
              ? 'Coba lagi sinkronisasi'
              : 'Sinkronkan sekarang',
          onTap: () => ref.read(syncControllerProvider).synchronizeNow(),
        ),
        CycleCareSettingsTile(
          icon: Icons.schedule,
          title: 'Sinkronisasi terakhir',
          subtitle: last == null
              ? 'Belum pernah berhasil'
              : DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(last.toLocal()),
        ),
      ],
    );
  }
}

class BackupSection extends ConsumerWidget {
  const BackupSection({required this.onBackupTap, super.key});

  final VoidCallback onBackupTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CycleCareSectionGroup(
      title: 'Backup & restore',
      children: [
        CycleCareSettingsTile(
          icon: Icons.backup_outlined,
          title: 'Kelola backup lokal',
          trailing: const Icon(Icons.chevron_right),
          onTap: onBackupTap,
        ),
        CycleCareSettingsTile(
          icon: Icons.delete_sweep_outlined,
          title: 'Catatan terarsip',
          onTap: () => _showDeleted(context, ref),
        ),
      ],
    );
  }

  Future<void> _showDeleted(BuildContext context, WidgetRef ref) async {
    final deleted = await ref.read(deletedPeriodsProvider.future);
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: deleted.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text('Tidak ada catatan terarsip.'),
              )
            : ListView(
                shrinkWrap: true,
                children: deleted
                    .map((record) => ListTile(
                          title: Text(DateOnly.display(record.startDate)),
                          trailing: TextButton(
                            onPressed: () async {
                              await ref
                                  .read(periodActionsProvider.notifier)
                                  .restore(record.id);
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: const Text('Pulihkan'),
                          ),
                        ))
                    .toList(),
              ),
      ),
    );
  }
}

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CycleCareSectionGroup(
      title: 'Akun',
      children: [
        CycleCareSettingsTile(
          icon: Icons.logout,
          title: 'Keluar dari akun',
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Keluar dari akun?'),
                content: const Text(
                    'Kamu dapat masuk kembali menggunakan akun Supabase yang sama.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Keluar'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go('/login');
            }
          },
        ),
        CycleCareSettingsTile(
          icon: Icons.person_remove_outlined,
          title: 'Hapus akun cloud',
          destructive: true,
          onTap: () => _deleteAccount(context, ref),
        ),
      ],
    );
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final first = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus akun cloud?'),
        content: const Text(
            'Akun Supabase, profil, dan semua data cloud terkait akan dihapus permanen.'),
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
    if (first != true || !context.mounted) return;
    final second = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi terakhir'),
        content: const Text(
            'Tindakan ini tidak dapat dibatalkan. Hapus akun dan data cloud?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus akun'),
          ),
        ],
      ),
    );
    if (second == true) {
      await ref.read(accountDeletionServiceProvider).deleteAccount();
    }
  }
}

class DangerZoneSection extends ConsumerWidget {
  const DangerZoneSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CycleCareSectionGroup(
      title: 'Zona bahaya',
      children: [
        CycleCareSettingsTile(
          icon: Icons.delete_forever_outlined,
          title: 'Hapus semua data lokal',
          destructive: true,
          onTap: () => _deleteAll(context, ref),
        ),
      ],
    );
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final first = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus semua data lokal?'),
        content: const Text(
            'Semua period, prediksi, pengaturan, dan antrean sinkronisasi akan dihapus dari perangkat. Data cloud dapat tersinkron kembali setelah sinkronisasi awal berikutnya. Akun Supabase tidak ikut dihapus.'),
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
    if (first != true || !context.mounted) return;
    final second = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi terakhir'),
        content: const Text('Tindakan ini tidak dapat dibatalkan. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus semua'),
          ),
        ],
      ),
    );
    if (second == true) {
      await ref.read(notificationServiceProvider).cancelAll();
      await ref.read(databaseProvider).deleteAllLocalData();
      await ref.read(syncControllerProvider).resetAfterLocalDataDeletion();
      ref.invalidate(activePeriodsProvider);
      ref.invalidate(predictionProvider);
      ref.invalidate(settingsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data lokal telah dihapus.')));
      }
    }
  }
}
