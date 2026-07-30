enum SyncGateStatus {
  initialRequired,
  migrationRequired,
  synchronizing,
  ready,
  offlineReady,
  failed,
  authenticationExpired,
}

extension SyncGateStatusText on SyncGateStatus {
  String get label => switch (this) {
        SyncGateStatus.initialRequired => 'Sinkronisasi awal diperlukan',
        SyncGateStatus.migrationRequired => 'Data lama perlu dikonfirmasi',
        SyncGateStatus.synchronizing => 'Menyinkronkan',
        SyncGateStatus.ready => 'Tersinkron',
        SyncGateStatus.offlineReady => 'Offline',
        SyncGateStatus.failed => 'Sinkronisasi gagal',
        SyncGateStatus.authenticationExpired => 'Sesi berakhir',
      };
}

class SyncGateSnapshot {
  const SyncGateSnapshot({
    required this.status,
    required this.pendingCount,
    this.lastSuccessfulSyncAt,
    this.error,
  });

  final SyncGateStatus status;
  final int pendingCount;
  final DateTime? lastSuccessfulSyncAt;
  final Object? error;
}
