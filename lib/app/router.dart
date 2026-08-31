import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/app_lock/presentation/lock_page.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/backup/presentation/backup_page.dart';
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
  final auth = ref.read(authSessionProvider);
  final sync = ref.read(syncControllerProvider);

  return GoRouter(
    initialLocation: '/session',
    refreshListenable: Listenable.merge([auth, sync]),
    redirect: (context, state) {
      final currentAuth = ref.read(authSessionProvider);
      final currentSync = ref.read(syncControllerProvider);
      final biometricEnabled =
          ref.read(settingsProvider).valueOrNull?['biometric_enabled'] ==
              'true';
      return resolveAppRedirect(
        authStatus: currentAuth.status,
        hasUser: currentAuth.user != null,
        syncStatus: currentSync.snapshot.status,
        location: state.matchedLocation,
        biometricEnabled: biometricEnabled,
      );
    },
    routes: [
      GoRoute(path: '/session', builder: (_, __) => const SessionPage()),
      GoRoute(
        path: '/login',
        builder: (_, state) => LoginPage(
          registrationComplete:
              state.uri.queryParameters['registered'] == 'true',
        ),
      ),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/sync', builder: (_, __) => const SyncGatePage()),
      GoRoute(path: '/local-data', builder: (_, __) => const SyncGatePage()),
      GoRoute(path: '/lock', builder: (_, __) => const LockPage()),
      GoRoute(path: '/backup', builder: (_, __) => const BackupPage()),
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
  bool biometricEnabled = false,
}) {
  if (authStatus == AuthSessionStatus.restoring) {
    return location == '/session' ? null : '/session';
  }
  final authenticated =
      authStatus == AuthSessionStatus.authenticated && hasUser;
  if (!authenticated) {
    return {'/login', '/register'}.contains(location) ? null : '/login';
  }
  if (syncStatus == SyncGateStatus.migrationRequired) {
    return location == '/local-data' ? null : '/local-data';
  }
  final isBlockingSync = syncStatus == SyncGateStatus.failed ||
      syncStatus == SyncGateStatus.authenticationExpired ||
      syncStatus == SyncGateStatus.initialRequired ||
      syncStatus == SyncGateStatus.synchronizing;
  if (isBlockingSync) return location == '/sync' ? null : '/sync';
  final publicPath = {'/login', '/register', '/session', '/sync', '/local-data'}
      .contains(location);
  if (biometricEnabled && !publicPath && location != '/lock') {
    return '/lock';
  }
  if (publicPath) return '/dashboard';
  if (biometricEnabled && location == '/lock') return null;
  return null;
}

class AppShell extends StatefulWidget {
  const AppShell({required this.navigationShell, super.key});

  static const double largeScreenMinWidth = 900;

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.navigationShell.currentIndex);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex !=
        oldWidget.navigationShell.currentIndex) {
      final target = widget.navigationShell.currentIndex;
      if (_pageController.hasClients) {
        final current = _pageController.page?.round();
        if (current != target) {
          _pageController.animateToPage(
            target,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        _pageController.jumpToPage(target);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (index == widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(index, initialLocation: true);
      return;
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    if (index != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(index);
    }
  }

  Widget _buildPageView() => PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: _onPageChanged,
        children: const [
          _KeepAlivePage(child: DashboardPage()),
          _KeepAlivePage(child: CalendarPage()),
          _KeepAlivePage(child: HistoryPage()),
          _KeepAlivePage(child: SettingsPage()),
        ],
      );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final colors = context.cycleCareColors;
          if (constraints.maxWidth > AppShell.largeScreenMinWidth) {
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
                            color: colors.surfaceTranslucent,
                            borderRadius: CycleCareRadius.cardBorder,
                            border: Border.all(color: colors.divider),
                          ),
                          child: NavigationRail(
                            selectedIndex:
                                widget.navigationShell.currentIndex,
                            onDestinationSelected: _onDestinationSelected,
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
                            ),
                            destinations: _railDestinations,
                          ),
                        ),
                      ),
                      const SizedBox(width: CycleCareSpacing.xs),
                      Expanded(child: _buildPageView()),
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: colors.background,
            body: _buildPageView(),
            bottomNavigationBar: SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(
                CycleCareSpacing.sm,
                CycleCareSpacing.xs,
                CycleCareSpacing.sm,
                CycleCareSpacing.xs,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surfaceTranslucent,
                  borderRadius: CycleCareRadius.cardBorder,
                  border: Border.all(color: colors.divider),
                ),
                child: ClipRRect(
                  borderRadius: CycleCareRadius.cardBorder,
                  child: NavigationBar(
                    selectedIndex: widget.navigationShell.currentIndex,
                    onDestinationSelected: _onDestinationSelected,
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

class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({required this.child});

  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
