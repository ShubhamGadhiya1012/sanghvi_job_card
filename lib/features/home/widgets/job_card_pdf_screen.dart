import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sanghvi_job_card/features/job_card_entry/models/job_card_dm.dart';
import 'package:sanghvi_job_card/utils/dialogs/app_dialogs.dart';
import 'package:path_provider/path_provider.dart';

class JobCardPdfScreen {
  static Future<void> generateJobCardPdf({required JobCardDm jobCard}) async {
    try {
      final pdf = pw.Document();

      final borderColor = PdfColors.grey600;
      final textColor = PdfColors.black;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildRow(
                  label: 'JOB CARD NO.',
                  value: jobCard.invno,
                  borderColor: borderColor,
                  textColor: textColor,
                  isBold: true,
                  colspan: 3,
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: _buildCell(
                        label: 'PARTY NAME',
                        value: jobCard.pName,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'DATE',
                        value: _formatDate(jobCard.date),
                        borderColor: borderColor,
                        textColor: textColor,
                        isCenter: true,
                      ),
                    ),
                  ],
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: _buildCell(
                        label: 'P.O.NO.',
                        value: jobCard.poNo,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'DATE',
                        value: _formatDate(jobCard.poDate),
                        borderColor: borderColor,
                        textColor: textColor,
                        isCenter: true,
                      ),
                    ),
                  ],
                ),

                _buildRow(
                  label: 'BRAND',
                  value: jobCard.iName,
                  borderColor: borderColor,
                  textColor: textColor,
                  isCenter: true,
                ),

                _buildRow(
                  label: 'TAPE DIMENSION',
                  value: _getItemDetail(jobCard, 'tapeDimension'),
                  borderColor: borderColor,
                  textColor: textColor,
                  isCenter: true,
                ),

                _buildRow(
                  label: 'WEIGHT PER 10 NOS.',
                  value: _getItemDetail(jobCard, 'weightPer10Nos'),
                  borderColor: borderColor,
                  textColor: textColor,
                  isCenter: true,
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildCell(
                        label: 'REEL COLOR',
                        value: _getItemDetail(jobCard, 'reelColour'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'REEL TYPE',
                        value: _getItemDetail(jobCard, 'reelType'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                _buildRow(
                  label: 'OUTER COLOR',
                  value: _getItemDetail(jobCard, 'outerColour'),
                  borderColor: borderColor,
                  textColor: textColor,
                  isCenter: true,
                ),

                _buildRow(
                  label: 'MRP ON REEL',
                  value: _getItemDetail(jobCard, 'mrp'),
                  borderColor: borderColor,
                  textColor: textColor,
                  isCenter: true,
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildCell(
                        label: 'REEL PRINT COLOR',
                        value: _getItemDetail(jobCard, 'reelPrintColour'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'OUTER PRINT COLOR',
                        value: _getItemDetail(jobCard, 'outerPrintColour'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildCell(
                        label: 'ORDERED QUANTITY',
                        value: jobCard.orderQty,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'PRODUCTION',
                        value: jobCard.productionQty,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildCell(
                        label: '10 NOS. PACKING',
                        value: _getItemDetail(jobCard, 'nos10Packing'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'INNER BOX LABEL',
                        value: _getItemDetail(jobCard, 'innerBoxLabel'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildCell(
                        label: 'INNER BOX QUANTITY',
                        value: _getItemDetail(jobCard, 'innerBoxQty'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'INNER BOX COLOR',
                        value: _getItemDetail(jobCard, 'innerBoxColour'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildCell(
                        label: 'MASTER BOX QUANTITY',
                        value: _getItemDetail(jobCard, 'masterBoxType'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'MASTERBOX COLOR',
                        value: _getItemDetail(jobCard, 'masterBoxColour'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildCell(
                        label: 'MASTER BOX LABEL',
                        value: _getItemDetail(jobCard, 'masterBoxLabel'),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'EXTRA PRINTED REEL(KG)',
                        value: jobCard.extraPrintedReel,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildCell(
                        label: 'EXTRA INNER BOX',
                        value: jobCard.extraInnerBox,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'EXTRA OUTER BOX',
                        value: jobCard.extraOuterBox,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      child: _buildCell(
                        label: 'EXTRA TAPE NOS.',
                        value: jobCard.extraTapeNos,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    pw.Expanded(
                      child: _buildCell(
                        label: 'EXTRA OUTER',
                        value: jobCard.extraOuter,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                _buildRow(
                  label: '10 NOS. PACKING',
                  value: jobCard.nos10Packing,
                  borderColor: borderColor,
                  textColor: textColor,
                ),

                _buildRow(
                  label: 'NOTE',
                  value: jobCard.remark,
                  borderColor: borderColor,
                  textColor: textColor,
                  isCenter: true,
                ),

                _buildRow(
                  label: 'JOBCARD CHECKED BY - 1 )',
                  value: jobCard.checked1,
                  borderColor: borderColor,
                  textColor: textColor,
                ),

                _buildRow(
                  label: 'JOBCARD CHECKED BY - 2 )',
                  value: jobCard.checked2,
                  borderColor: borderColor,
                  textColor: textColor,
                ),
              ],
            );
          },
        ),
      );

      await _savePdf(pdf, jobCard.invno);
    } catch (e) {
      print(e.toString());
      showErrorSnackbar('Error', 'Failed to generate PDF: $e');
    }
  }

  static pw.Widget _buildRow({
    required String label,
    required String value,
    required PdfColor borderColor,
    required PdfColor textColor,
    bool isBold = false,
    bool isCenter = false,
    int colspan = 1,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: borderColor, width: 0.5),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                label,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: colspan,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(6),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: borderColor, width: 0.5),
                ),
              ),
              child: pw.Text(
                value,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: isBold
                      ? pw.FontWeight.bold
                      : pw.FontWeight.normal,
                  color: textColor,
                ),
                textAlign: isCenter ? pw.TextAlign.center : pw.TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCell({
    required String label,
    required String value,
    required PdfColor borderColor,
    required PdfColor textColor,
    bool isCenter = false,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: borderColor, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: borderColor, width: 0.5),
              ),
            ),
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 10, color: textColor),
              textAlign: isCenter ? pw.TextAlign.center : pw.TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(String date) {
    if (date.isEmpty) return '';
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
      return date;
    } catch (e) {
      return date;
    }
  }

  static String _getItemDetail(JobCardDm jobCard, String field) {
    return '';
  }

  static Future<void> _savePdf(pw.Document pdf, String invno) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();

    // Sanitize the invno by replacing invalid characters
    final sanitizedInvno = invno.replaceAll('/', '_').replaceAll('\\', '_');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/Job_Card_${sanitizedInvno}_$timestamp.pdf');
    await file.writeAsBytes(bytes);
    await OpenFilex.open(file.path);
  }
}
