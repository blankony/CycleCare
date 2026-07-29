import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class CycleCareApp extends ConsumerWidget {
  const CycleCareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
        title: 'CycleCare',
        debugShowCheckedModeBanner: false,
        theme: CycleCareTheme.light(),
        routerConfig: ref.watch(routerProvider),
      );
}
