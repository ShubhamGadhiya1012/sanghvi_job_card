import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sanghvi_job_card/features/brand_master/models/item_master_dm.dart';
import 'package:sanghvi_job_card/features/home/models/job_card_dm.dart';
import 'package:sanghvi_job_card/utils/dialogs/app_dialogs.dart';

class JobCardPdfScreen {
  static Future<void> generateJobCardPdf({
    required JobCardDm jobCard,
    ItemMasterDm? itemMasterData,
  }) async {
    try {
      final pdf = pw.Document();
      final border = pw.Border.all(width: 0.7, color: PdfColors.grey700);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                /// ---------- HEADER ----------
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(border: border),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'JOB CARD',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Job Card No : ${_v(jobCard.invno)}',
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 10),

                /// ---------- PARTY DETAILS ----------
                _twoColumnRow(
                  leftLabel: 'Party Name',
                  leftValue: _v(jobCard.pName),
                  rightLabel: 'Date',
                  rightValue: _formatDate(jobCard.date),
                  border: border,
                ),

                _twoColumnRow(
                  leftLabel: 'P.O. No',
                  leftValue: _v(jobCard.poNo),
                  rightLabel: 'P.O. Date',
                  rightValue: _formatDate(jobCard.poDate),
                  border: border,
                ),

                _singleRow(
                  label: 'Item Name',
                  value: _v(jobCard.iName),
                  border: border,
                ),

                pw.SizedBox(height: 8),

                /// ---------- PRODUCT DETAILS ----------
                _sectionTitle('PRODUCT DETAILS'),

                _singleRow(
                  label: 'Tape Dimension',
                  value: _v(itemMasterData?.description ?? ''),
                  border: border,
                ),

                _singleRow(
                  label: 'Weight Per 10 Nos',
                  value: _v(itemMasterData?.weightPer10Nos ?? ''),
                  border: border,
                ),

                _twoColumnRow(
                  leftLabel: 'Reel Color',
                  leftValue: _v(itemMasterData?.reelColour ?? ''),
                  rightLabel: 'Reel Type',
                  rightValue: _v(itemMasterData?.reelType ?? ''),
                  border: border,
                ),

                _singleRow(
                  label: 'Outer Color',
                  value: _v(itemMasterData?.outerColour ?? ''),
                  border: border,
                ),

                _singleRow(
                  label: 'MRP On Reel',
                  value: _v(itemMasterData?.mrp ?? ''),
                  border: border,
                ),

                _twoColumnRow(
                  leftLabel: 'Reel Print Color',
                  leftValue: _v(itemMasterData?.reelPrintColour ?? ''),
                  rightLabel: 'Outer Print Color',
                  rightValue: _v(itemMasterData?.outerPrintColour ?? ''),
                  border: border,
                ),

                pw.SizedBox(height: 8),

                /// ---------- QUANTITY DETAILS ----------
                _sectionTitle('QUANTITY DETAILS'),

                _twoColumnRow(
                  leftLabel: 'Ordered Qty',
                  leftValue: _v(jobCard.orderQty),
                  rightLabel: 'Production Qty',
                  rightValue: _v(jobCard.productionQty),
                  border: border,
                ),

                _twoColumnRow(
                  leftLabel: '10 Nos Packing',
                  leftValue: _v(itemMasterData?.nos10Packing ?? ''),
                  rightLabel: 'Inner Box Qty',
                  rightValue: _v(itemMasterData?.innerBoxQty ?? ''),
                  border: border,
                ),

                _twoColumnRow(
                  leftLabel: 'Inner Box Label',
                  leftValue: _v(itemMasterData?.innerBoxLabel ?? ''),
                  rightLabel: 'Inner Box Color',
                  rightValue: _v(itemMasterData?.innerBoxColour ?? ''),
                  border: border,
                ),

                _twoColumnRow(
                  leftLabel: 'Master Box Type',
                  leftValue: _v(itemMasterData?.masterBoxType ?? ''),
                  rightLabel: 'Master Box Color',
                  rightValue: _v(itemMasterData?.masterBoxColour ?? ''),
                  border: border,
                ),

                _singleRow(
                  label: 'Master Box Label',
                  value: _v(itemMasterData?.masterBoxLabel ?? ''),
                  border: border,
                ),

                pw.SizedBox(height: 8),

                /// ---------- EXTRA DETAILS ----------
                _sectionTitle('EXTRA DETAILS'),

                _twoColumnRow(
                  leftLabel: 'Extra Printed Reel (KG)',
                  leftValue: _v(jobCard.extraPrintedReel),
                  rightLabel: 'Extra Inner Box',
                  rightValue: _v(jobCard.extraInnerBox),
                  border: border,
                ),

                _twoColumnRow(
                  leftLabel: 'Extra Outer Box',
                  leftValue: _v(jobCard.extraOuterBox),
                  rightLabel: 'Extra Tape Nos',
                  rightValue: _v(jobCard.extraTapeNos),
                  border: border,
                ),

                _singleRow(
                  label: 'Extra Outer',
                  value: _v(jobCard.extraOuter),
                  border: border,
                ),

                pw.SizedBox(height: 8),

                /// ---------- PACKING DETAILS ----------
                _sectionTitle('PACKING DETAILS'),

                _singleRow(
                  label: 'Nos 10 Packing',
                  value: _v(jobCard.nos10Packing),
                  border: border,
                ),
                pw.SizedBox(height: 8),

                /// ---------- CHECKED DETAILS ----------
                _sectionTitle('CHECKED DETAILS'),

                _twoColumnRow(
                  leftLabel: 'Checked By - 1',
                  leftValue: _v(jobCard.checked1),
                  rightLabel: 'Checked By - 2',
                  rightValue: _v(jobCard.checked2),
                  border: border,
                ),
                pw.SizedBox(height: 8),

                /// ---------- NOTE ----------
                _sectionTitle('NOTE'),

                _singleRow(
                  label: 'Remark',
                  value: _v(jobCard.remark),
                  border: border,
                ),
              ],
            );
          },
        ),
      );

      await _savePdf(pdf, jobCard.invno);
    } catch (e) {
      print(e.toString());
      showErrorSnackbar('Error', 'PDF generation failed: ${e.toString()}');
    }
  }

  // ---------- UI HELPERS ----------

  static pw.Widget _sectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(6),
      color: PdfColors.grey300,
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _singleRow({
    required String label,
    required String value,
    required pw.Border border,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: border),
      child: pw.Row(children: [_cell(label, isBold: true), _cell(value)]),
    );
  }

  static pw.Widget _twoColumnRow({
    required String leftLabel,
    required String leftValue,
    required String rightLabel,
    required String rightValue,
    required pw.Border border,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: border),
      child: pw.Row(
        children: [
          _cell(leftLabel, isBold: true),
          _cell(leftValue),
          _cell(rightLabel, isBold: true),
          _cell(rightValue),
        ],
      ),
    );
  }

  static pw.Widget _cell(String text, {bool isBold = false}) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(
          _v(text),
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // ---------- UTILS ----------

  /// returns '-' if value is null or empty
  static String _v(String? value) {
    if (value == null || value.trim().isEmpty) return '-';
    return value;
  }

  static String _formatDate(String date) {
    if (date.isEmpty) return '-';
    final parts = date.split('-');
    return parts.length == 3 ? '${parts[2]}-${parts[1]}-${parts[0]}' : date;
  }

  static Future<void> _savePdf(pw.Document pdf, String invno) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final safeInv = invno.replaceAll('/', '_');
    final file = File('${dir.path}/JobCard_$safeInv.pdf');
    await file.writeAsBytes(bytes);
    await OpenFilex.open(file.path);
  }
}
