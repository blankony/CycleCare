import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../domain/entities/sync_state.dart';
import '../../../l10n/app_localizations.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.loadingPreparingCycle),
            ],
          ),
        ),
      );
  }
}

class SyncGatePage extends ConsumerWidget {
  const SyncGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final snapshot = ref.watch(syncSnapshotProvider);
    final locale = l10n.localeName.startsWith('id') ? 'id_ID' : 'en';
    if (snapshot.status == SyncGateStatus.ready ||
        snapshot.status == SyncGateStatus.offlineReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/dashboard');
      });
      return _SyncGateScaffold(
        title: l10n.statusSynced,
        message: 'Opening tracker...',
        icon: Icons.check_circle_outline,
        iconColor: CycleCareColors.classicBlue,
      );
    }
    if (snapshot.status == SyncGateStatus.synchronizing) {
      return _SyncGateScaffold(
        title: l10n.statusSyncing,
        message: l10n.calendarLoading,
        icon: Icons.cloud_sync,
        iconColor: CycleCareColors.fertileStrong,
      );
    }
    final migration = snapshot.status == SyncGateStatus.migrationRequired;
    final failure = snapshot.status == SyncGateStatus.failed;
    final title = switch (snapshot.status) {
      SyncGateStatus.migrationRequired => 'Legacy data found',
      SyncGateStatus.failed => 'Sync not yet successful',
      SyncGateStatus.authenticationExpired => 'Session expired',
      _ => snapshot.status.label,
    };
    final message = switch (snapshot.status) {
      SyncGateStatus.migrationRequired =>
        'Local data from a previous version has no owner. Choose an action before health data can be opened.',
      SyncGateStatus.failed =>
        'Ensure connection is available and try again. A fresh install cannot open tracker without initial sync.',
      SyncGateStatus.authenticationExpired =>
        'Supabase session expired. Sign in again to continue sync.',
      _ => l10n.calendarLoading,
    };
    final icon = switch (snapshot.status) {
      SyncGateStatus.migrationRequired => Icons.folder_shared_outlined,
      SyncGateStatus.failed => Icons.sync_problem_rounded,
      SyncGateStatus.authenticationExpired => Icons.lock_clock_outlined,
      _ => Icons.cloud_sync,
    };
    final iconColor = switch (snapshot.status) {
      SyncGateStatus.failed => Theme.of(context).colorScheme.error,
      SyncGateStatus.authenticationExpired =>
        Theme.of(context).colorScheme.error,
      _ => Theme.of(context).colorScheme.primary,
    };
    return _SyncGateScaffold(
      title: title,
      message: message,
      icon: icon,
      iconColor: iconColor,
      footer: snapshot.lastSuccessfulSyncAt == null
          ? null
          : Text(
              'Last cloud sync: ${DateFormat('d MMM yyyy, HH:mm', locale).format(snapshot.lastSuccessfulSyncAt!.toLocal())}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
      actions: [
        if (migration) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _resolve(context, ref, attach: true),
              child: const Text('Use legacy data for this account'),
            ),
          ),
          const SizedBox(height: CycleCareSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _resolve(context, ref, attach: false),
              child: const Text('Delete legacy data from device'),
            ),
          ),
        ] else if (snapshot.status == SyncGateStatus.authenticationExpired) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.go('/login'),
              child: Text(l10n.authLoginAction),
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => ref.read(syncControllerProvider).retry(),
              child: Text(failure ? l10n.commonRetry : l10n.commonContinue),
            ),
          ),
        ],
        if (failure) ...[
          const SizedBox(height: CycleCareSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: Text(l10n.authLoginAction),
            ),
          ),
        ],
        if (snapshot.error != null) ...[
          const SizedBox(height: CycleCareSpacing.md),
          Text(
            'Detail: ${snapshot.error.runtimeType}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Future<void> _resolve(BuildContext context, WidgetRef ref,
      {required bool attach}) async {
    await ref
        .read(syncControllerProvider)
        .resolveLegacyData(attachToAccount: attach);
    if (context.mounted && ref.read(syncControllerProvider).isReady) {
      context.go('/dashboard');
    }
  }
}

class _SyncGateScaffold extends StatelessWidget {
  const _SyncGateScaffold({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    this.actions = const <Widget>[],
    this.footer,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final List<Widget> actions;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CycleCareBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final body = Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CycleCareSpacing.lg,
                  vertical: CycleCareSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _GateHeader(),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: iconColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(
                                        CycleCareRadius.card),
                                    border: Border.all(
                                      color: iconColor.withValues(alpha: 0.24),
                                    ),
                                  ),
                                  child: Icon(icon, size: 44, color: iconColor),
                                ),
                              ),
                              const SizedBox(height: CycleCareSpacing.lg),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: CycleCareSpacing.sm),
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          context.cycleCareColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: CycleCareSpacing.lg),
                              ...actions,
                              if (footer != null) ...[
                                const SizedBox(height: CycleCareSpacing.md),
                                footer!,
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    const _GateFooter(),
                  ],
                ),
              );
              if (constraints.maxWidth >= 900) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: body,
                  ),
                );
              }
              return body;
            },
          ),
        ),
      ),
    );
  }
}

class _GateHeader extends StatelessWidget {
  const _GateHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: CycleCareColors.period,
            shape: BoxShape.circle,
          ),
          child: const Text(
            'CC',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: CycleCareSpacing.sm),
        Text('CycleCare', style: theme.textTheme.titleLarge),
      ],
    );
  }
}

class _GateFooter extends StatelessWidget {
  const _GateFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.cycleCareColors;
    return Text(
      'Your period data stays safe on device. Sync only sends data to this Supabase account.',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(
        color: colors.textSecondary,
      ),
    );
  }
}
