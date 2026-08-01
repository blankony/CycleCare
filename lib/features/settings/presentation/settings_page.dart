import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../core/date/date_only.dart';
import '../../../data/local/database.dart';
import '../../../domain/entities/sync_state.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(settingsProvider).valueOrNull ?? const <String, String?>{};
    final currentUser = ref.watch(authSessionProvider).user;
    final sync = ref.watch(syncControllerProvider);
    final syncSnapshot = sync.snapshot;
    final reminderEnabled = settings['reminder_enabled'] == 'true';
    final biometricEnabled = settings['biometric_enabled'] == 'true';
    final cycleSettings = ref.watch(userCycleSettingsProvider).valueOrNull;
    return Scaffold(
      appBar: const CycleCareAppBar(title: 'Pengaturan'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(children: [
              SwitchListTile(
                title: const Text('Tampilkan perkiraan ovulasi'),
                subtitle: const Text(
                    'Perkiraan transparan dari tanggal period berikutnya, bukan pengukuran medis.'),
                value: cycleSettings?.showOvulationEstimate ?? false,
                onChanged: (value) => _setFertilityVisibility(context, ref,
                    value, cycleSettings?.showFertileWindow ?? false),
              ),
              SwitchListTile(
                title: const Text('Tampilkan perkiraan masa subur'),
                subtitle: const Text(
                    'Perkiraan masa subur tidak boleh digunakan sebagai metode kontrasepsi.'),
                value: cycleSettings?.showFertileWindow ?? false,
                onChanged: (value) => _setFertilityVisibility(context, ref,
                    cycleSettings?.showOvulationEstimate ?? false, value),
              ),
              SwitchListTile(
                title: const Text('Pengingat'),
                subtitle: const Text(
                    'Jadwal pengingat lokal setelah izin diberikan.'),
                value: reminderEnabled,
                onChanged: (value) => _setReminder(context, ref, value),
              ),
              SwitchListTile(
                title: const Text('Kunci biometrik'),
                subtitle:
                    const Text('Tidak aktif otomatis pada instalasi baru.'),
                value: biometricEnabled,
                onChanged: (value) => _setBiometric(context, ref, value),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.cloud_outlined),
                title: const Text('Cloud backup'),
                subtitle: Text(
                    'Masuk sebagai ${currentUser?.email ?? 'akun Supabase'}'),
                trailing: Chip(label: Text(syncSnapshot.status.label)),
                onTap: () => _sync(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.sync),
                title: Text(syncSnapshot.status == SyncGateStatus.failed
                    ? 'Coba lagi'
                    : 'Sinkronkan sekarang'),
                subtitle: Text(
                    '${syncSnapshot.pendingCount} perubahan menunggu sinkronisasi'),
                trailing: const Icon(Icons.refresh),
                onTap: () => _sync(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Sinkronisasi terakhir'),
                subtitle: Text(syncSnapshot.lastSuccessfulSyncAt == null
                    ? 'Belum pernah berhasil'
                    : DateFormat('d MMM yyyy, HH:mm', 'id_ID')
                        .format(syncSnapshot.lastSuccessfulSyncAt!.toLocal())),
              ),
              ListTile(
                leading: const Icon(Icons.delete_sweep_outlined),
                title: const Text('Catatan terarsip'),
                onTap: () => _showDeleted(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Keluar dari akun'),
                onTap: () => _logout(context, ref),
              ),
              ListTile(
                leading: Icon(Icons.person_remove_outlined,
                    color: Theme.of(context).colorScheme.error),
                title: const Text('Hapus akun cloud'),
                subtitle: const Text(
                    'Menghapus akun dan seluruh data cloud serta cache lokal.'),
                textColor: Theme.of(context).colorScheme.error,
                onTap: () => _deleteAccount(context, ref),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(children: [
              ListTile(
                  leading: const Icon(Icons.file_upload_outlined),
                  title: const Text('Export data'),
                  onTap: () async {
                    try {
                      await ref.read(backupServiceProvider).shareExport();
                    } catch (_) {
                      if (context.mounted) _comingSoon(context);
                    }
                  }),
              ListTile(
                  leading: const Icon(Icons.file_download_outlined),
                  title: const Text('Import data'),
                  onTap: () => _import(context, ref)),
              ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('App lock'),
                  onTap: () => context.push('/lock')),
            ]),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.delete_forever_outlined),
                title: const Text('Hapus semua data lokal'),
                textColor: Theme.of(context).colorScheme.error,
                iconColor: Theme.of(context).colorScheme.error,
                onTap: () => _deleteAll(context, ref),
              ),
              const ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: Text('Privasi'),
                  subtitle: Text(
                      'Data period disimpan lokal dan disinkronkan hanya ke akun Supabase ini.')),
              const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Tentang CycleCare'),
                  subtitle: Text('Pencatatan pribadi, bukan perangkat medis.')),
            ]),
          ),
          const SizedBox(height: 20),
          const MedicalDisclaimer(),
        ],
      ),
    );
  }

  Future<void> _setReminder(
      BuildContext context, WidgetRef ref, bool enabled) async {
    if (enabled) {
      final granted =
          await ref.read(notificationServiceProvider).requestPermission();
      if (!granted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Izin notifikasi belum diberikan.')));
        }
        return;
      }
    }
    await _setSetting(ref, 'reminder_enabled', '$enabled');
    await ref.read(userCycleSettingsRepositoryProvider).updateReminder(enabled);
    ref.invalidate(userCycleSettingsProvider);
  }

  Future<void> _setFertilityVisibility(
      BuildContext context, WidgetRef ref, bool ovulation, bool fertile) async {
    try {
      await ref
          .read(userCycleSettingsRepositoryProvider)
          .updateFertilityVisibility(
            showOvulationEstimate: ovulation,
            showFertileWindow: fertile,
          );
      ref.invalidate(userCycleSettingsProvider);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pengaturan gagal disimpan: $error')));
      }
    }
  }

  Future<void> _setBiometric(
      BuildContext context, WidgetRef ref, bool enabled) async {
    if (enabled) {
      final available = await ref.read(securityServiceProvider).isAvailable();
      if (!available) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Biometrik tidak tersedia di perangkat ini.')));
        }
        return;
      }
    }
    await ref.read(securityServiceProvider).setEnabled(enabled);
    final saved = await ref.read(securityServiceProvider).isEnabled();
    if (saved == enabled) {
      await _setSetting(ref, 'biometric_enabled', '$enabled');
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Autentikasi dibatalkan.')));
    }
  }

  Future<void> _sync(BuildContext context, WidgetRef ref) async {
    await ref.read(syncControllerProvider).synchronizeNow();
    if (!context.mounted) return;
    final snapshot = ref.read(syncControllerProvider).snapshot;
    final message = snapshot.status == SyncGateStatus.ready
        ? 'Sinkronisasi selesai.'
        : snapshot.status.label;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authRepositoryProvider).signOut();
    if (context.mounted) context.go('/login');
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus akun cloud?'),
        content: const Text(
            'Akun Supabase, data cloud, cache lokal, dan pengingat akan dihapus. Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus akun')),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    final finalConfirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi penghapusan permanen'),
        content: const Text(
            'Data cloud dan akun autentikasi tidak dapat dipulihkan setelah langkah ini.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus permanen')),
        ],
      ),
    );
    if (finalConfirmation != true) return;
    try {
      await ref.read(accountDeletionServiceProvider).deleteAccount();
      if (context.mounted) context.go('/login');
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Penghapusan akun gagal: $error')));
      }
    }
  }

  Future<void> _setSetting(WidgetRef ref, String key, String value) async {
    final database = ref.read(databaseProvider);
    await database.into(database.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(
              key: key,
              value: Value(value),
              updatedAt: DateTime.now().toUtc().toIso8601String()),
        );
    ref.invalidate(settingsProvider);
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
                child: Text('Tidak ada catatan terarsip.'))
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
                              child: const Text('Pulihkan')),
                        ))
                    .toList(),
              ),
      ),
    );
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final replace = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Import backup'),
                content: const Text(
                    'Pilih Ganti untuk menghapus data lokal terlebih dahulu, atau Batal.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Ganti data'))
                ]));
    if (replace != true) return;
    try {
      await ref
          .read(backupServiceProvider)
          .importFromPicker(replaceExisting: true);
      await ref.read(recalculationServiceProvider).recalculate();
      await ref.read(syncControllerProvider).synchronizeNow();
      ref.invalidate(activePeriodsProvider);
      ref.invalidate(predictionProvider);
      ref.invalidate(settingsProvider);
      ref.invalidate(userCycleSettingsProvider);
      ref.invalidate(flowLogsProvider);
      ref.invalidate(cycleStatisticsProvider);
      ref.invalidate(cycleInsightsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup berhasil diimpor.')));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Import gagal: $error')));
      }
    }
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
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Lanjut')),
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
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus semua')),
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

  void _comingSoon(BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tindakan belum dapat dilakukan pada perangkat ini.')));
}
