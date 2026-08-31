import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../app/widgets/cycle_care_settings_group.dart';
import '../../../../core/date/date_only.dart';
import '../../../../domain/entities/sync_state.dart';
import '../../../../l10n/app_localizations.dart';

class CycleVisibilitySection extends ConsumerWidget {
  const CycleVisibilitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cycleSettings = ref.watch(userCycleSettingsProvider).valueOrNull;
    final showOvulation = cycleSettings?.showOvulationEstimate ?? false;
    final showFertile = cycleSettings?.showFertileWindow ?? false;
    return CycleCareSectionGroup(
      title: l10n.settingsCycleDisplay,
      children: [
        CycleCareSettingsTile(
          icon: Icons.water_drop_outlined,
          title: l10n.settingsOvulationEstimate,
          trailing: Switch.adaptive(
            key: const ValueKey('settings.ovulation.switch'),
            value: showOvulation,
            onChanged: (value) =>
                _setFertilityVisibility(context, ref, value, showFertile),
          ),
        ),
        CycleCareSettingsTile(
          icon: Icons.eco_outlined,
          title: l10n.settingsFertileWindow,
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
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsUpdateFailed(error.toString()))),
      );
    }
  }
}

class ReminderSection extends ConsumerWidget {
  const ReminderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings =
        ref.watch(settingsProvider).valueOrNull ?? const <String, String?>{};
    final reminderEnabled = settings['reminder_enabled'] == 'true';
    return CycleCareSectionGroup(
      title: l10n.settingsReminders,
      children: [
        CycleCareSettingsTile(
          icon: Icons.notifications_active_outlined,
          title: l10n.settingsReminderPeriod,
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
    final l10n = AppLocalizations.of(context);
    final settings =
        ref.watch(settingsProvider).valueOrNull ?? const <String, String?>{};
    final biometricEnabled = settings['biometric_enabled'] == 'true';
    return CycleCareSectionGroup(
      title: l10n.settingsSecurity,
      children: [
        CycleCareSettingsTile(
          icon: Icons.fingerprint,
          title: l10n.settingsBiometricLock,
          trailing: Switch.adaptive(
            key: const ValueKey('settings.biometric.switch'),
            value: biometricEnabled,
            onChanged: (value) => _toggleBiometric(context, ref, value),
          ),
        ),
        CycleCareSettingsTile(
          icon: Icons.lock_open_outlined,
          title: l10n.settingsTestAuth,
          onTap: () => Navigator.of(context).pushNamed('/lock'),
        ),
      ],
    );
  }

  Future<void> _toggleBiometric(
      BuildContext context, WidgetRef ref, bool value) async {
    final l10n = AppLocalizations.of(context);
    final security = ref.read(securityServiceProvider);
    final available = await security.isAvailable();
    if (!context.mounted) return;
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.settingsBiometricNotSupported)));
      return;
    }
    if (value) {
      final authenticated = await security.authenticate();
      if (!context.mounted) return;
      if (!authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.settingsBiometricCancelled)));
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
    final l10n = AppLocalizations.of(context);
    final syncSnapshot = ref.watch(syncSnapshotProvider);
    final authUser = ref.watch(authSessionProvider).user;
    final last = syncSnapshot.lastSuccessfulSyncAt;
    final locale = l10n.localeName.startsWith('id') ? 'id_ID' : 'en';
    return CycleCareSectionGroup(
      title: l10n.settingsCloudSync,
      children: [
        CycleCareSettingsTile(
          icon: Icons.cloud_outlined,
          title: l10n.settingsActiveAccount,
          subtitle: authUser?.email ?? l10n.settingsSupabaseAccount,
        ),
        CycleCareSettingsTile(
          icon: Icons.sync,
          title: syncSnapshot.status == SyncGateStatus.failed
              ? l10n.settingsRetrySync
              : l10n.settingsSyncNow,
          onTap: () => ref.read(syncControllerProvider).synchronizeNow(),
        ),
        CycleCareSettingsTile(
          icon: Icons.schedule,
          title: l10n.settingsLastSync,
          subtitle: last == null
              ? l10n.settingsNeverSynced
              : DateFormat('d MMM yyyy, HH:mm', locale).format(last.toLocal()),
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
    final l10n = AppLocalizations.of(context);
    return CycleCareSectionGroup(
      title: l10n.settingsBackupRestore,
      children: [
        CycleCareSettingsTile(
          icon: Icons.backup_outlined,
          title: l10n.settingsManageBackup,
          trailing: const Icon(Icons.chevron_right),
          onTap: onBackupTap,
        ),
        CycleCareSettingsTile(
          icon: Icons.delete_sweep_outlined,
          title: l10n.settingsArchivedNotes,
          onTap: () => _showDeleted(context, ref),
        ),
      ],
    );
  }

  Future<void> _showDeleted(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final deleted = await ref.read(deletedPeriodsProvider.future);
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: deleted.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.settingsNoArchived),
              )
            : ListView(
                shrinkWrap: true,
                children: deleted
                    .map((record) => ListTile(
                          title: Text(DateOnly.display(record.startDate, l10n.localeName)),
                          trailing: TextButton(
                            onPressed: () async {
                              await ref
                                  .read(periodActionsProvider.notifier)
                                  .restore(record.id);
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: Text(l10n.commonRestore),
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
    final l10n = AppLocalizations.of(context);
    return CycleCareSectionGroup(
      title: l10n.settingsAccount,
      children: [
        CycleCareSettingsTile(
          icon: Icons.logout,
          title: l10n.settingsSignOut,
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(l10n.settingsSignOutTitle),
                content: Text(l10n.settingsSignOutMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.commonCancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n.commonCancel == 'Cancel' ? 'Sign out' : 'Keluar'),
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
          title: l10n.settingsDeleteCloud,
          destructive: true,
          onTap: () => _deleteAccount(context, ref),
        ),
      ],
    );
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final first = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsDeleteCloudTitle),
        content: Text(l10n.settingsDeleteCloudMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonContinue),
          ),
        ],
      ),
    );
    if (first != true || !context.mounted) return;
    final second = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsDeleteCloudConfirmTitle),
        content: Text(l10n.settingsDeleteCloudConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.settingsDeleteCloudAction),
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
    final l10n = AppLocalizations.of(context);
    return CycleCareSectionGroup(
      title: l10n.settingsDangerZone,
      children: [
        CycleCareSettingsTile(
          icon: Icons.delete_forever_outlined,
          title: l10n.settingsDeleteLocal,
          destructive: true,
          onTap: () => _deleteAll(context, ref),
        ),
      ],
    );
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final first = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsDeleteLocalTitle),
        content: Text(l10n.settingsDeleteLocalMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonContinue),
          ),
        ],
      ),
    );
    if (first != true || !context.mounted) return;
    final second = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsDeleteLocalConfirmTitle),
        content: Text(l10n.settingsDeleteLocalConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.settingsDeleteLocalAction),
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
            SnackBar(content: Text(l10n.settingsLocalDeleted)));
      }
    }
  }
}
