import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../domain/entities/sync_state.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memulihkan sesi akun...'),
            ],
          ),
        ),
      );
}

class SyncGatePage extends ConsumerWidget {
  const SyncGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(syncSnapshotProvider);
    if (snapshot.status == SyncGateStatus.synchronizing) {
      return const _SyncGateScaffold(
        title: 'Menyinkronkan',
        message: 'Menyiapkan akses aman ke data CycleCare.',
        icon: Icons.cloud_sync,
        iconColor: CycleCareColors.fertileStrong,
      );
    }
    final migration = snapshot.status == SyncGateStatus.migrationRequired;
    final failure = snapshot.status == SyncGateStatus.failed;
    final title = switch (snapshot.status) {
      SyncGateStatus.migrationRequired => 'Data lama ditemukan',
      SyncGateStatus.failed => 'Sinkronisasi belum berhasil',
      SyncGateStatus.authenticationExpired => 'Sesi berakhir',
      _ => snapshot.status.label,
    };
    final message = switch (snapshot.status) {
      SyncGateStatus.migrationRequired =>
        'Data lokal dari versi sebelumnya belum memiliki pemilik akun. Pilih tindakan sebelum data kesehatan dapat dibuka.',
      SyncGateStatus.failed =>
        'Pastikan koneksi tersedia lalu coba lagi. Instalasi baru tidak dapat membuka tracker tanpa sinkronisasi awal.',
      SyncGateStatus.authenticationExpired =>
        'Sesi Supabase berakhir. Masuk kembali untuk melanjutkan sinkronisasi.',
      _ => 'Menyiapkan akses aman ke data CycleCare.',
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
              'Sinkronisasi cloud terakhir: ${DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(snapshot.lastSuccessfulSyncAt!.toLocal())}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
      actions: [
        if (migration) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _resolve(context, ref, attach: true),
              child: const Text('Gunakan data lama untuk akun ini'),
            ),
          ),
          const SizedBox(height: CycleCareSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _resolve(context, ref, attach: false),
              child: const Text('Hapus data lama dari perangkat'),
            ),
          ),
        ] else if (snapshot.status == SyncGateStatus.authenticationExpired) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.go('/login'),
              child: const Text('Masuk kembali'),
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => ref.read(syncControllerProvider).retry(),
              child: Text(failure ? 'Coba lagi' : 'Lanjutkan sinkronisasi'),
            ),
          ),
        ],
        if (failure) ...[
          const SizedBox(height: CycleCareSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Kembali ke masuk'),
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
      'Data periodmu tetap aman tersimpan di perangkat. Sinkronisasi hanya mengirim data ke akun Supabase ini.',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(
        color: colors.textSecondary,
      ),
    );
  }
}
