import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/date/date_only.dart';
import '../entities/cycle_insights.dart';
import '../entities/enums.dart';
import '../entities/period_day_log.dart';
import '../entities/period_record.dart';

class HealthReportService {
  const HealthReportService();

  Future<Uint8List> build({
    required List<PeriodRecord> periods,
    required List<PeriodDayLogRecord> flowLogs,
    required CycleStatistics statistics,
    required String localeCode,
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();
    final cutoff = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: 90));
    final filtered = periods
        .where((p) => p.deletedAt == null && !p.startDate.isBefore(cutoff))
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    final displayPeriods = filtered.isEmpty
        ? (periods.where((p) => p.deletedAt == null).toList()
          ..sort((a, b) => b.startDate.compareTo(a.startDate)))
            .take(6)
            .toList()
        : filtered;

    final isId = localeCode.startsWith('id');
    final doc = pw.Document();
    const deepNavy = PdfColor.fromInt(0xFF03045E);
    const classicBlue = PdfColor.fromInt(0xFF0077B6);
    const iceBlue = PdfColor.fromInt(0xFFCAF0F8);
    const skyBlue = PdfColor.fromInt(0xFF90E0EF);
    const textSecondary = PdfColor.fromInt(0xFF3A5A7A);

    String fmt(DateTime d) => DateOnly.display(d, localeCode);
    String fmtRange(DateTime s, DateTime? e) =>
        e == null ? '${fmt(s)} — ${isId ? 'berlangsung' : 'ongoing'}' : '${fmt(s)} – ${fmt(e)}';

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (ctx) => ctx.pageNumber == 1
            ? pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('CycleCare',
                          style: pw.TextStyle(
                              fontSize: 22,
                              fontWeight: pw.FontWeight.bold,
                              color: deepNavy)),
                      pw.Text(fmt(today),
                          style: const pw.TextStyle(
                              fontSize: 9, color: textSecondary)),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                      isId ? 'Laporan Kesehatan — 3 Bulan Terakhir' : 'Health Report — Last 3 Months',
                      style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: classicBlue)),
                  pw.Text(
                      displayPeriods.isEmpty
                          ? (isId ? 'Tidak ada data pada rentang ini.' : 'No data in this range.')
                          : '${fmt(cutoff)} – ${fmt(today)}',
                      style: const pw.TextStyle(fontSize: 8, color: textSecondary)),
                  pw.SizedBox(height: 8),
                  pw.Divider(color: skyBlue, thickness: 1),
                  pw.SizedBox(height: 8),
                ],
              )
            : pw.SizedBox.shrink(),
        footer: (ctx) => pw.Column(children: [
          pw.Divider(color: skyBlue, thickness: 0.5),
          pw.SizedBox(height: 4),
          pw.Text(
              isId
                  ? 'Prediksi CycleCare adalah perkiraan berdasarkan riwayat yang dicatat, bukan diagnosis medis.'
                  : 'CycleCare predictions are estimates based on your logged history, not a medical diagnosis.',
              style: const pw.TextStyle(fontSize: 7, color: textSecondary)),
          pw.SizedBox(height: 2),
          pw.Text('CycleCare • ${fmt(today)} • ${isId ? 'Hal' : 'Page'} ${ctx.pageNumber}/${ctx.pagesCount}',
              style: const pw.TextStyle(fontSize: 7, color: textSecondary)),
        ]),
        build: (ctx) => [
          _summaryGrid(statistics, isId, deepNavy, classicBlue, iceBlue),
          pw.SizedBox(height: 16),
          pw.Text(isId ? 'Tanggal Period' : 'Period Dates',
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold, color: deepNavy)),
          pw.SizedBox(height: 6),
          displayPeriods.isEmpty
              ? pw.Text(isId ? 'Belum ada catatan period.' : 'No period records yet.',
                  style: const pw.TextStyle(fontSize: 9, color: textSecondary))
              : pw.TableHelper.fromTextArray(
                  headerStyle: pw.TextStyle(
                      fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: deepNavy),
                  cellStyle: const pw.TextStyle(fontSize: 8, color: deepNavy),
                  cellAlignments: {
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                  },
                  headerAlignments: {
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                  },
                  columnWidths: {
                    0: const pw.FixedColumnWidth(28),
                    1: const pw.FlexColumnWidth(3),
                    2: const pw.FixedColumnWidth(52),
                    3: const pw.FixedColumnWidth(52),
                  },
                  headers: [
                    '#',
                    isId ? 'Rentang Tanggal' : 'Date Range',
                    isId ? 'Durasi' : 'Duration',
                    isId ? 'Siklus' : 'Cycle',
                  ],
                  data: [
                    for (var i = 0; i < displayPeriods.length; i++)
                      [
                        '${i + 1}',
                        fmtRange(displayPeriods[i].startDate, displayPeriods[i].endDate),
                        displayPeriods[i].periodDurationDays == null
                            ? '—'
                            : '${displayPeriods[i].periodDurationDays} ${isId ? 'hari' : 'days'}',
                        displayPeriods[i].cycleLengthDays == null
                            ? '—'
                            : '${displayPeriods[i].cycleLengthDays}d',
                      ]
                  ],
                ),
          pw.SizedBox(height: 16),
          pw.Text(isId ? 'Gejala / Flow Tercatat' : 'Logged Symptoms / Flow',
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold, color: deepNavy)),
          pw.SizedBox(height: 6),
          _flowSection(displayPeriods, flowLogs, isId, deepNavy, iceBlue, textSecondary),
          if (displayPeriods.any((p) => p.notes != null && p.notes!.trim().isNotEmpty)) ...[
            pw.SizedBox(height: 16),
            pw.Text(isId ? 'Catatan' : 'Notes',
                style: pw.TextStyle(
                    fontSize: 11, fontWeight: pw.FontWeight.bold, color: deepNavy)),
            pw.SizedBox(height: 6),
            for (final p in displayPeriods.where((e) => e.notes != null && e.notes!.trim().isNotEmpty))
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('• ', style: const pw.TextStyle(fontSize: 8, color: deepNavy)),
                    pw.Expanded(
                      child: pw.Text('${fmt(p.startDate)}: ${p.notes}',
                          style: const pw.TextStyle(fontSize: 8, color: deepNavy)),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
    return doc.save();
  }

  pw.Widget _summaryGrid(CycleStatistics s, bool isId, PdfColor deepNavy,
      PdfColor classicBlue, PdfColor iceBlue) {
    pw.Widget card(String label, String value) => pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
              color: iceBlue, borderRadius: pw.BorderRadius.circular(8)),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(label,
                    style: const pw.TextStyle(
                        fontSize: 7, color: PdfColor.fromInt(0xFF3A5A7A))),
                pw.SizedBox(height: 4),
                pw.Text(value,
                    style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: deepNavy)),
              ]),
        );
    String avgCycle = s.averageCycleLength == null
        ? '—'
        : '${s.averageCycleLength!.toStringAsFixed(1)} ${isId ? 'hari' : 'days'}';
    String avgDuration = s.averagePeriodDuration == null
        ? '—'
        : '${s.averagePeriodDuration!.toStringAsFixed(1)} ${isId ? 'hari' : 'days'}';
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(isId ? 'Ringkasan' : 'Summary',
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold, color: deepNavy)),
          pw.SizedBox(height: 6),
          pw.Row(children: [
            pw.Expanded(child: card(isId ? 'Rata-rata siklus' : 'Avg cycle length', avgCycle)),
            pw.SizedBox(width: 8),
            pw.Expanded(child: card(isId ? 'Rata-rata durasi' : 'Avg period duration', avgDuration)),
          ]),
          pw.SizedBox(height: 8),
          pw.Row(children: [
            pw.Expanded(
                child: card(isId ? 'Total tercatat' : 'Recorded periods', '${s.recordedPeriods}')),
            pw.SizedBox(width: 8),
            pw.Expanded(child: card(isId ? 'Pola' : 'Pattern', s.pattern.label)),
          ]),
        ]);
  }

  pw.Widget _flowSection(
      List<PeriodRecord> periods,
      List<PeriodDayLogRecord> logs,
      bool isId,
      PdfColor deepNavy,
      PdfColor iceBlue,
      PdfColor textSecondary) {
    final ids = periods.map((e) => e.id).toSet();
    final counts = <MenstrualFlow, int>{};
    for (final log in logs.where((l) => l.deletedAt == null && ids.contains(l.periodEntryId))) {
      final f = MenstrualFlowText.fromValue(log.flow);
      if (f != null) counts[f] = (counts[f] ?? 0) + 1;
    }
    if (counts.isEmpty) {
      return pw.Text(isId ? 'Belum ada flow yang dicatat pada rentang ini.' : 'No flow logged in this range.',
          style: const pw.TextStyle(fontSize: 9, color: PdfColor.fromInt(0xFF3A5A7A)));
    }
    return pw.Wrap(spacing: 6, runSpacing: 6, children: [
      for (final e in MenstrualFlow.values.where(counts.containsKey))
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: pw.BoxDecoration(
              color: iceBlue, borderRadius: pw.BorderRadius.circular(20)),
          child: pw.Text('${e.label}: ${counts[e]}',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: deepNavy)),
        ),
    ]);
  }
}
