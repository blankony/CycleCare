import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
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
    final controller = ref.watch(syncControllerProvider);
    final snapshot = controller.snapshot;
    if (snapshot.status == SyncGateStatus.synchronizing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final migration = snapshot.status == SyncGateStatus.migrationRequired;
    final failure = snapshot.status == SyncGateStatus.failed;
    final title = migration
        ? 'Data lama ditemukan'
        : failure
            ? 'Sinkronisasi belum berhasil'
            : snapshot.status.label;
    final message = migration
        ? 'Data lokal dari versi sebelumnya belum memiliki pemilik akun. Pilih tindakan sebelum data kesehatan dapat dibuka.'
        : failure
            ? 'Pastikan koneksi tersedia lalu coba lagi. Instalasi baru tidak dapat membuka tracker tanpa sinkronisasi awal.'
            : 'Menyiapkan akses aman ke data CycleCare.';
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(migration ? Icons.folder_shared_outlined : Icons.cloud_sync,
                  size: 56),
              const SizedBox(height: 16),
              Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              if (snapshot.error != null) ...[
                const SizedBox(height: 8),
                Text('Detail: ${snapshot.error.runtimeType}',
                    textAlign: TextAlign.center),
              ],
              const SizedBox(height: 24),
              if (migration) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _resolve(context, ref, attach: true),
                    child: const Text('Gunakan data lama untuk akun ini'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _resolve(context, ref, attach: false),
                    child: const Text('Hapus data lama dari perangkat'),
                  ),
                ),
              ] else ...[
                FilledButton(
                  onPressed: () => ref.read(syncControllerProvider).retry(),
                  child: const Text('Coba lagi'),
                ),
              ],
              const SizedBox(height: 12),
              if (failure)
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Kembali ke masuk'),
                ),
            ],
          ),
        ),
      ),
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
