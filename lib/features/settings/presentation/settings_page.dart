import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/locale_provider.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../app/widgets/cycle_care_settings_group.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/settings_sections.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final syncSnapshot = ref.watch(syncSnapshotProvider);
    return Scaffold(
      appBar: CycleCareAppBar(title: l10n.settingsTitle),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final localeCode = ref.watch(appLocaleCodeProvider);
          final children = <Widget>[
            CycleCareSyncBanner(snapshot: syncSnapshot),
            const SizedBox(height: CycleCareSpacing.sm),
            const CycleVisibilitySection(),
            const SizedBox(height: CycleCareSpacing.xl),
            const ReminderSection(),
            const SizedBox(height: CycleCareSpacing.xl),
            const SecuritySection(),
            const SizedBox(height: CycleCareSpacing.xl),
            CycleCareSectionGroup(
              title: l10n.sectionLanguage,
              children: [
                CycleCareSettingsTile(
                  icon: Icons.language_rounded,
                  title: l10n.languagePickerTitle,
                  subtitle: localeCode == 'id'
                      ? l10n.languageIndonesian
                      : l10n.languageEnglish,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguagePicker(context, ref),
                ),
              ],
            ),
            const SizedBox(height: CycleCareSpacing.xl),
            const CloudSyncSection(),
            const SizedBox(height: CycleCareSpacing.xl),
            BackupSection(
              onBackupTap: () => context.push('/backup'),
            ),
            const SizedBox(height: CycleCareSpacing.xl),
            const AccountSection(),
            const SizedBox(height: CycleCareSpacing.xl),
            const DangerZoneSection(),
            const SizedBox(height: CycleCareSpacing.xl),
            const MedicalDisclaimer(),
            const SizedBox(height: CycleCareSpacing.xl),
          ];
          final body = ListView(
            padding: const EdgeInsets.fromLTRB(
              CycleCareSpacing.md,
              CycleCareSpacing.md,
              CycleCareSpacing.md,
              96,
            ),
            children: children,
          );
          if (!isWide) return body;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: body,
            ),
          );
        },
      ),
    );
  }
}

Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final current = ref.read(appLocaleCodeProvider);
  final selected = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.languagePickerTitle),
      content: RadioGroup<String>(
        groupValue: current,
        onChanged: (v) {
          if (v != null) Navigator.pop(context, v);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              value: 'en',
              title: Text(l10n.languageEnglish),
            ),
            RadioListTile<String>(
              value: 'id',
              title: Text(l10n.languageIndonesian),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
      ],
    ),
  );
  if (selected != null && selected != current) {
    await ref.read(localeControllerProvider).setLocale(selected);
  }
}
