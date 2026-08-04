import 'package:cycle_care/app/design/cycle_care_design.dart';
import 'package:cycle_care/app/router.dart';
import 'package:cycle_care/app/theme.dart';
import 'package:cycle_care/app/widgets.dart';
import 'package:cycle_care/features/sync/presentation/sync_gate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('session restoration screen is Indonesian', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SessionPage()));
    expect(find.text('Memulihkan sesi akun...'), findsOneWidget);
  });

  testWidgets('app shell uses bottom navigation at the compact breakpoint',
      (tester) async {
    await _pumpShell(tester, const Size(600, 900));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('app shell uses a navigation rail on large screens',
      (tester) async {
    await _pumpShell(tester, const Size(1000, 700));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.tap(find.text('Kalender'));
    await tester.pumpAndSettle();
    expect(find.text('Calendar content'), findsOneWidget);
  });

  testWidgets('light theme exposes CycleCare semantic colors', (tester) async {
    late Brightness brightness;
    late CycleCareSemanticColors semanticColors;

    await tester.pumpWidget(
      MaterialApp(
        theme: CycleCareTheme.light(),
        home: Builder(
          builder: (context) {
            brightness = Theme.of(context).brightness;
            semanticColors = context.cycleCareColors;
            return const Scaffold(
              body: CycleCareBackground(
                child: Center(
                  child: CycleCareCard(child: Text('CycleCare')),
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(brightness, Brightness.light);
    expect(semanticColors.background, CycleCareColors.background);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dark theme keeps components readable and adaptive',
      (tester) async {
    late ThemeData theme;
    late CycleCareSemanticColors semanticColors;

    await tester.pumpWidget(
      MaterialApp(
        theme: CycleCareTheme.light(),
        darkTheme: CycleCareTheme.dark(),
        themeMode: ThemeMode.dark,
        home: Builder(
          builder: (context) {
            theme = Theme.of(context);
            semanticColors = context.cycleCareColors;
            return const Scaffold(
              body: CycleCareBackground(
                child: SafeArea(
                  child: Column(
                    children: [
                      CycleCareCard(child: Text('Status siklus')),
                      CycleCareStatusChip(
                        label: 'Offline',
                        icon: Icons.cloud_off_outlined,
                        tone: CycleCareStatusTone.warning,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Catatan'),
                      ),
                      FilledButton(onPressed: null, child: Text('Simpan')),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(theme.brightness, Brightness.dark);
    expect(semanticColors.background, CycleCareColors.darkBackground);
    expect(
      theme.filledButtonTheme.style?.minimumSize?.resolve({}),
      const Size(48, 52),
    );
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpShell(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  final router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          _branch('/dashboard', 'Dashboard content'),
          _branch('/calendar', 'Calendar content'),
          _branch('/history', 'History content'),
          _branch('/settings', 'Settings content'),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
}

StatefulShellBranch _branch(String path, String label) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        builder: (context, state) => Scaffold(body: Text(label)),
      ),
    ],
  );
}
