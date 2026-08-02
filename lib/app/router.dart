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
import 'design/cycle_care_design.dart';
import 'providers.dart';
import 'widgets.dart';

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

  static const double largeScreenMinWidth = 840;

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > largeScreenMinWidth) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: CycleCareBackground(
                child: SafeArea(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(CycleCareSpacing.sm),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.90),
                            borderRadius: CycleCareRadius.cardBorder,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x120F172A),
                                blurRadius: 24,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: NavigationRail(
                            selectedIndex: navigationShell.currentIndex,
                            onDestinationSelected: navigationShell.goBranch,
                            groupAlignment: -0.65,
                            minWidth: 96,
                            labelType: NavigationRailLabelType.all,
                            leading: Padding(
                              padding: const EdgeInsets.only(
                                top: CycleCareSpacing.md,
                                bottom: CycleCareSpacing.xl,
                              ),
                              child: Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CycleCareColors.period,
                                      Color(0xFF8B5CF6),
                                    ],
                                  ),
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
                            ),
                            destinations: _railDestinations,
                          ),
                        ),
                      ),
                      const SizedBox(width: CycleCareSpacing.xs),
                      Expanded(child: navigationShell),
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: navigationShell,
            bottomNavigationBar: SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(
                CycleCareSpacing.sm,
                CycleCareSpacing.xs,
                CycleCareSpacing.sm,
                CycleCareSpacing.sm,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.96),
                  borderRadius: CycleCareRadius.cardBorder,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x160F172A),
                      blurRadius: 28,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: CycleCareRadius.cardBorder,
                  child: NavigationBar(
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: navigationShell.goBranch,
                    destinations: _barDestinations,
                  ),
                ),
              ),
            ),
          );
        },
      );

  static const _barDestinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Beranda',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      selectedIcon: Icon(Icons.calendar_month),
      label: 'Kalender',
    ),
    NavigationDestination(icon: Icon(Icons.history), label: 'Riwayat'),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Pengaturan',
    ),
  ];

  static const _railDestinations = [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: Text('Beranda'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.calendar_month_outlined),
      selectedIcon: Icon(Icons.calendar_month),
      label: Text('Kalender'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.history),
      label: Text('Riwayat'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: Text('Pengaturan'),
    ),
  ];
}
