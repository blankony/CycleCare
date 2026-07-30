import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'router.dart';
import 'theme.dart';

class CycleCareApp extends ConsumerStatefulWidget {
  const CycleCareApp({super.key});

  @override
  ConsumerState<CycleCareApp> createState() => _CycleCareAppState();
}

class _CycleCareAppState extends ConsumerState<CycleCareApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final auth = ref.read(authSessionProvider);
      final sync = ref.read(syncControllerProvider);
      if (auth.isAuthenticated && sync.isReady) {
        sync.synchronizeNow();
      }
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'CycleCare',
        debugShowCheckedModeBanner: false,
        theme: CycleCareTheme.light(),
        routerConfig: ref.watch(routerProvider),
      );
}
