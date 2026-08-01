import 'package:flutter/foundation.dart';

import '../../app/auth_session_controller.dart';
import '../../data/local/database.dart';
import '../entities/sync_state.dart';
import 'period_recalculation_service.dart';
import 'sync_service.dart';

class SyncController extends ChangeNotifier {
  SyncController({
    required this.database,
    required this.authSession,
    required this.syncService,
    required this.recalculationService,
  }) {
    authSession.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  final AppDatabase database;
  final AuthSessionController authSession;
  final SyncService syncService;
  final PeriodRecalculationService recalculationService;

  SyncGateSnapshot snapshot = const SyncGateSnapshot(
    status: SyncGateStatus.initialRequired,
    pendingCount: 0,
  );
  String? _activeUserId;
  bool _busy = false;

  bool get isReady =>
      snapshot.status == SyncGateStatus.ready ||
      snapshot.status == SyncGateStatus.offlineReady;

  void _onAuthChanged() {
    final userId = authSession.user?.id;
    if (userId == null) {
      _activeUserId = null;
      snapshot = const SyncGateSnapshot(
        status: SyncGateStatus.initialRequired,
        pendingCount: 0,
      );
      notifyListeners();
      return;
    }
    if (_activeUserId == userId || _busy) return;
    _activeUserId = userId;
    initializeForUser(userId);
  }

  Future<void> initializeForUser(String userId) async {
    if (_busy) return;
    if (await database.hasUnassignedLocalData()) {
      snapshot = const SyncGateSnapshot(
        status: SyncGateStatus.migrationRequired,
        pendingCount: 0,
      );
      notifyListeners();
      return;
    }
    final wasInitialized = await database.hasCompletedInitialSync(userId);
    await _synchronize(userId, initial: !wasInitialized);
  }

  Future<void> resolveLegacyData({required bool attachToAccount}) async {
    final userId = authSession.user?.id;
    if (userId == null) return;
    if (attachToAccount) {
      await database.claimUnassignedLocalData(userId);
    } else {
      await database.discardUnassignedLocalData();
    }
    await initializeForUser(userId);
  }

  Future<void> retry() async {
    final userId = authSession.user?.id;
    if (userId != null) await initializeForUser(userId);
  }

  Future<void> synchronizeNow() async {
    final userId = authSession.user?.id;
    if (userId == null) return;
    await _synchronize(userId, initial: false);
  }

  Future<void> resetAfterLocalDataDeletion() async {
    final userId = authSession.user?.id;
    if (userId == null) return;
    snapshot = const SyncGateSnapshot(
      status: SyncGateStatus.initialRequired,
      pendingCount: 0,
    );
    notifyListeners();
    await initializeForUser(userId);
  }

  Future<void> _synchronize(String userId, {required bool initial}) async {
    if (_busy) return;
    _busy = true;
    snapshot = SyncGateSnapshot(
      status: SyncGateStatus.synchronizing,
      pendingCount: snapshot.pendingCount,
      lastSuccessfulSyncAt: snapshot.lastSuccessfulSyncAt,
    );
    notifyListeners();
    try {
      final result = await syncService.synchronize();
      if (result.failed > 0) {
        throw StateError('Ada perubahan yang belum tersinkronisasi.');
      }
      await recalculationService.recalculate();
      final now = DateTime.now().toUtc();
      if (initial) {
        await database.markInitialSyncCompleted(userId, now.toIso8601String());
      } else {
        await database.updateLastSuccessfulSync(userId, now.toIso8601String());
      }
      snapshot = SyncGateSnapshot(
        status: SyncGateStatus.ready,
        pendingCount: await database.pendingSyncCount(userId),
        lastSuccessfulSyncAt: now,
      );
      notifyListeners();
    } catch (error) {
      final wasInitialized = await database.hasCompletedInitialSync(userId);
      snapshot = SyncGateSnapshot(
        status: wasInitialized
            ? SyncGateStatus.offlineReady
            : SyncGateStatus.failed,
        pendingCount: await database.pendingSyncCount(userId),
        lastSuccessfulSyncAt: await _lastSync(userId),
        error: error,
      );
      notifyListeners();
    } finally {
      _busy = false;
    }
  }

  Future<DateTime?> _lastSync(String userId) async {
    final value = await database.lastSuccessfulSyncAt(userId);
    return value == null ? null : DateTime.tryParse(value);
  }

  @override
  void dispose() {
    authSession.removeListener(_onAuthChanged);
    super.dispose();
  }
}
