import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cycle_care/app/app.dart';
import 'package:cycle_care/app/providers.dart';
import 'package:cycle_care/domain/entities/period_record.dart';
import 'package:cycle_care/domain/entities/prediction.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activePeriodsProvider
              .overrideWith((ref) => Stream.value(const <PeriodRecord>[])),
          predictionProvider
              .overrideWith((ref) => Stream.value(null as CyclePrediction?)),
          settingsProvider
              .overrideWith((ref) => Stream.value(const <String, String?>{})),
        ],
        child: const CycleCareApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('dashboard empty state and confirmation render', (tester) async {
    await pumpApp(tester);
    expect(find.text('Belum ada catatan'), findsOneWidget);
    await tester.tap(find.text('Period mulai hari ini'));
    await tester.pump();
    expect(find.text('Catat period?'), findsOneWidget);
  });

  testWidgets('bottom navigation opens settings safely without cloud',
      (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Pengaturan'));
    await tester.pump();
    expect(find.text('Cloud backup'), findsOneWidget);
    expect(
        find.text('Tidak tersedia tanpa konfigurasi Supabase'), findsOneWidget);
  });
}
