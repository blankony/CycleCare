import 'package:flutter_test/flutter_test.dart';

import 'package:cycle_care/app/auth_session_controller.dart';
import 'package:cycle_care/app/router.dart';
import 'package:cycle_care/domain/entities/sync_state.dart';

void main() {
  test('restoring session stays on session screen', () {
    expect(
      resolveAppRedirect(
        authStatus: AuthSessionStatus.restoring,
        hasUser: false,
        syncStatus: SyncGateStatus.initialRequired,
        location: '/dashboard',
      ),
      '/session',
    );
  });

  test('logged out users cannot open protected routes', () {
    expect(
      resolveAppRedirect(
        authStatus: AuthSessionStatus.unauthenticated,
        hasUser: false,
        syncStatus: SyncGateStatus.ready,
        location: '/history',
      ),
      '/login',
    );
  });

  test('authenticated users complete sync before tracker access', () {
    expect(
      resolveAppRedirect(
        authStatus: AuthSessionStatus.authenticated,
        hasUser: true,
        syncStatus: SyncGateStatus.failed,
        location: '/dashboard',
      ),
      '/sync',
    );
  });

  test('ready authenticated users leave public routes', () {
    expect(
      resolveAppRedirect(
        authStatus: AuthSessionStatus.authenticated,
        hasUser: true,
        syncStatus: SyncGateStatus.ready,
        location: '/login',
      ),
      '/dashboard',
    );
  });

  test('previously initialized users may open tracker offline', () {
    expect(
      resolveAppRedirect(
        authStatus: AuthSessionStatus.authenticated,
        hasUser: true,
        syncStatus: SyncGateStatus.offlineReady,
        location: '/calendar',
      ),
      isNull,
    );
  });
}
