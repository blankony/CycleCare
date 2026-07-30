import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cycle_care/app/auth_session_controller.dart';
import 'package:cycle_care/data/local/database.dart';
import 'package:cycle_care/data/repositories/auth_repository.dart';
import 'package:cycle_care/data/repositories/sync_repository.dart';
import 'package:cycle_care/domain/entities/sync_state.dart';
import 'package:cycle_care/domain/services/classification_service.dart';
import 'package:cycle_care/domain/services/period_recalculation_service.dart';
import 'package:cycle_care/domain/services/prediction_service.dart';
import 'package:cycle_care/domain/services/sync_controller.dart';
import 'package:cycle_care/domain/services/sync_service.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this.restoreStatus);

  final AuthRestoreStatus restoreStatus;
  final user = const User(
    id: 'user-a',
    appMetadata: {},
    userMetadata: {},
    aud: 'authenticated',
    email: 'user@example.com',
    createdAt: '2026-01-01T00:00:00Z',
  );

  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();

  @override
  User? get currentUser =>
      restoreStatus == AuthRestoreStatus.noSession ? null : user;

  @override
  Future<AuthRestoreStatus> restoreSession() async => restoreStatus;

  @override
  Future<void> signIn(
      {required String email, required String password}) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<AuthRegistrationResult> signUp(
          {required String email, required String password}) async =>
      AuthRegistrationResult.signedIn;
}

class _FakeSyncRepository implements SyncRepository {
  bool shouldFail;

  _FakeSyncRepository({this.shouldFail = false});

  @override
  Future<SyncResult> synchronize() async {
    if (shouldFail) throw StateError('offline');
    return const SyncResult(synced: 0, failed: 0);
  }
}

Future<void> _waitForStatus(
    SyncController controller, SyncGateStatus expected) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    if (controller.snapshot.status == expected) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('Status ${controller.snapshot.status} tidak menjadi $expected.');
}

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase.memory());
  tearDown(() => database.close());

  SyncController createController(_FakeSyncRepository syncRepository) {
    final auth = AuthSessionController(
        _FakeAuthRepository(AuthRestoreStatus.authenticated));
    return SyncController(
      database: database,
      authSession: auth,
      syncService: SyncService(syncRepository),
      recalculationService: PeriodRecalculationService(
        database,
        const PredictionService(),
        const ClassificationService(),
        userId: 'user-a',
      ),
    );
  }

  test('fresh installation completes initial synchronization', () async {
    final controller = createController(_FakeSyncRepository());

    await _waitForStatus(controller, SyncGateStatus.ready);

    expect(await database.hasCompletedInitialSync('user-a'), isTrue);
    controller.dispose();
  });

  test('fresh installation denies offline access and retries', () async {
    final repository = _FakeSyncRepository(shouldFail: true);
    final controller = createController(repository);
    await _waitForStatus(controller, SyncGateStatus.failed);

    repository.shouldFail = false;
    await controller.retry();
    await _waitForStatus(controller, SyncGateStatus.ready);

    controller.dispose();
  });

  test('previously initialized installation allows temporary offline access',
      () async {
    await database.markInitialSyncCompleted(
        'user-a', '2026-01-01T00:00:00Z');
    final controller =
        createController(_FakeSyncRepository(shouldFail: true));

    await _waitForStatus(controller, SyncGateStatus.offlineReady);

    controller.dispose();
  });

  test('expired session does not become authenticated', () async {
    final auth =
        AuthSessionController(_FakeAuthRepository(AuthRestoreStatus.expired));
    for (var attempt = 0; attempt < 20; attempt++) {
      if (auth.status != AuthSessionStatus.restoring) break;
      await Future<void>.delayed(Duration.zero);
    }
    expect(auth.status, AuthSessionStatus.expired);
    expect(auth.isAuthenticated, isFalse);
    auth.dispose();
  });
}
