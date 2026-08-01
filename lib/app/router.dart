import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/app_lock/presentation/lock_page.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/calendar/presentation/calendar_page.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/history/presentation/history_page.dart';
import '../features/period_form/presentation/period_form_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/statistics/presentation/statistics_page.dart';
import '../features/summary/presentation/summary_page.dart';
import '../features/sync/presentation/sync_gate_page.dart';
import '../app/auth_session_controller.dart';
import '../domain/entities/sync_state.dart';
import 'providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authSessionProvider);
  final sync = ref.watch(syncControllerProvider);

  return GoRouter(
    initialLocation: '/session',
    refreshListenable: Listenable.merge([auth, sync]),
    redirect: (context, state) => resolveAppRedirect(
      authStatus: auth.status,
      hasUser: auth.user != null,
      syncStatus: sync.snapshot.status,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(path: '/session', builder: (_, __) => const SessionPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/sync', builder: (_, __) => const SyncGatePage()),
      GoRoute(path: '/local-data', builder: (_, __) => const SyncGatePage()),
      GoRoute(path: '/lock', builder: (_, __) => const LockPage()),
      GoRoute(
        path: '/add-period',
        builder: (context, state) => PeriodFormPage(record: state.extra),
      ),
      GoRoute(
        path: '/statistics',
        builder: (_, __) => const StatisticsPage(),
      ),
      GoRoute(
        path: '/summary/:periodId',
        builder: (_, state) => SummaryPage(
          periodId: state.pathParameters['periodId']!,
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/dashboard', builder: (_, __) => const DashboardPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/calendar', builder: (_, __) => const CalendarPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/settings', builder: (_, __) => const SettingsPage()),
          ]),
        ],
      ),
    ],
  );
});

String? resolveAppRedirect({
  required AuthSessionStatus authStatus,
  required bool hasUser,
  required SyncGateStatus syncStatus,
  required String location,
}) {
  if (authStatus == AuthSessionStatus.restoring) {
    return location == '/session' ? null : '/session';
  }
  final authenticated =
      authStatus == AuthSessionStatus.authenticated && hasUser;
  if (!authenticated) return location == '/login' ? null : '/login';
  if (syncStatus == SyncGateStatus.migrationRequired) {
    return location == '/local-data' ? null : '/local-data';
  }
  final syncReady = syncStatus == SyncGateStatus.ready ||
      syncStatus == SyncGateStatus.offlineReady;
  if (!syncReady) return location == '/sync' ? null : '/sync';
  if ({'/login', '/session', '/sync', '/local-data'}.contains(location)) {
    return '/dashboard';
  }
  return null;
}

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Beranda'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month),
                label: 'Kalender'),
            NavigationDestination(icon: Icon(Icons.history), label: 'Riwayat'),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Pengaturan'),
          ],
        ),
      );
}
