import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../app/providers.dart';
import '../../../app/widgets.dart';
import '../../../domain/services/health_report_service.dart';
import '../../../l10n/app_localizations.dart';

class HealthReportPreviewPage extends ConsumerWidget {
  const HealthReportPreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final periods = ref.watch(activePeriodsProvider).valueOrNull ?? const [];
    final logs = ref.watch(flowLogsProvider).valueOrNull ?? const [];
    final stats = ref.watch(cycleStatisticsProvider).valueOrNull;
    if (stats == null) {
      return Scaffold(
        appBar: CycleCareAppBar(title: l10n.historyHealthReport),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    const service = HealthReportService();
    return Scaffold(
      appBar: CycleCareAppBar(title: l10n.historyHealthReport),
      body: PdfPreview(
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        pdfFileName: 'CycleCare-Health-Report.pdf',
        allowPrinting: true,
        allowSharing: true,
        actions: const [],
        build: (format) => service.build(
          periods: periods,
          flowLogs: logs,
          statistics: stats,
          localeCode: l10n.localeName,
        ),
      ),
    );
  }
}
