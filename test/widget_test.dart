import 'package:cycle_care/features/sync/presentation/sync_gate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('session restoration screen is Indonesian', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SessionPage()));
    expect(find.text('Memulihkan sesi akun...'), findsOneWidget);
  });
}
