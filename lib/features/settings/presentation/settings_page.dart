import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import 'widgets/settings_sections.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncSnapshot = ref.watch(syncSnapshotProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CycleCareAppBar(title: 'Pengaturan'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final children = <Widget>[
            CycleCareSyncBanner(snapshot: syncSnapshot),
            const SizedBox(height: CycleCareSpacing.sm),
            const CycleVisibilitySection(),
            const SizedBox(height: CycleCareSpacing.md),
            const ReminderSection(),
            const SizedBox(height: CycleCareSpacing.md),
            const SecuritySection(),
            const SizedBox(height: CycleCareSpacing.md),
            const CloudSyncSection(),
            const SizedBox(height: CycleCareSpacing.md),
            BackupSection(
              onBackupTap: () => context.push('/backup'),
            ),
            const SizedBox(height: CycleCareSpacing.md),
            const AccountSection(),
            const SizedBox(height: CycleCareSpacing.md),
            const DangerZoneSection(),
            const SizedBox(height: CycleCareSpacing.lg),
            const MedicalDisclaimer(),
            const SizedBox(height: CycleCareSpacing.xl),
          ];
          final body = ListView(
            padding: const EdgeInsets.fromLTRB(
              CycleCareSpacing.page,
              CycleCareSpacing.md,
              CycleCareSpacing.page,
              CycleCareSpacing.lg,
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
