import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';

Future<void> downloadInsightsPdf(
  BuildContext context, {
  required List<DateTime> periodDates,
  required List<int> painLevels,
  required List<int> cycleLengths,
  required double? averageCycleLength,
  required double? averagePainLevel,
  required DateTime? lastPeriodDate,
  required DateTime? estimatedNextPeriod,
  required String painTrend,
  required double? bmi,
}) async {
  final status = await Permission.manageExternalStorage.request();
    if (status.isDenied ||  status.isPermanentlyDenied ||  status.isRestricted) 
    {  throw "Please allow storage permission to upload files";  }
  // Request storage permission
  if (!status.isGranted) {
    Fluttertoast.showToast(
      msg: "Storage permission denied",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    return;
  }

  // Create PDF document
  final pdf = pw.Document();

  // Add page with title
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (pw.Context context) {
        return pw.Center(
          child: pw.Text(
            'Health Insights Report',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 24,
            ),
          ),
        );
      },
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Generated on ${DateFormat('MMM d, y').format(DateTime.now())}',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        );
      },
      build: (pw.Context context) {
        return [
          // Summary Section
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            margin: const pw.EdgeInsets.only(bottom: 20),
            decoration: pw.BoxDecoration(
              color: PdfColors.pink100,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Your Cycle Summary',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPdfInfoItem('Last Period', 
                      lastPeriodDate != null 
                        ? DateFormat('MMM d').format(lastPeriodDate)
                        : "N/A"),
                    _buildPdfInfoItem('Next Period', 
                      estimatedNextPeriod != null 
                        ? DateFormat('MMM d').format(estimatedNextPeriod)
                        : "N/A"),
                    _buildPdfInfoItem('Cycle Length', 
                      averageCycleLength != null 
                        ? "${averageCycleLength.toStringAsFixed(1)} days"
                        : "N/A"),
                  ],
                ),
                if (estimatedNextPeriod != null)
                  pw.SizedBox(height: 10),
                if (estimatedNextPeriod != null)
                  pw.Text(
                    "${DateTime.now().difference(estimatedNextPeriod).inDays.abs()} days ${DateTime.now().isAfter(estimatedNextPeriod) ? 'overdue' : 'until next period'}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
              ],
            ),
          ),
          
          // Health Statistics
          pw.Header(level: 1, text: 'Health Statistics'),
          pw.SizedBox(height: 10),
          
          // Create a 2x2 grid of statistics
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildPdfStatBox('Average Pain Level', 
                averagePainLevel != null ? "${averagePainLevel.toStringAsFixed(1)} / 10" : "N/A"),
              _buildPdfStatBox('BMI', bmi != null ? "$bmi" : "N/A"),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildPdfStatBox('Pain Trend', painTrend.isNotEmpty ? painTrend : "N/A"),
              _buildPdfStatBox('Tracked Cycles', "${periodDates.length}"),
            ],
          ),
          pw.SizedBox(height: 20),
          
          // Cycle Data
          pw.Header(level: 1, text: 'Cycle Data'),
          pw.SizedBox(height: 10),
          _buildPdfTable(periodDates, painLevels, cycleLengths),
          
          // Health Recommendations
          pw.SizedBox(height: 20),
          pw.Header(level: 1, text: 'Health Recommendations'),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (averageCycleLength != null && (averageCycleLength < 21 || averageCycleLength > 35))
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Text(
                      "• Your cycle length is outside the normal range (21–35 days). It is recommended to consult a healthcare provider.",
                      style: pw.TextStyle(color: PdfColors.red),
                    ),
                  ),
                pw.Text("• Remember to track your symptoms regularly for better insights."),
                pw.SizedBox(height: 5),
                pw.Text("• Drink plenty of water throughout your cycle."),
                pw.SizedBox(height: 5),
                pw.Text("• Regular exercise may help reduce PMS symptoms."),
                pw.SizedBox(height: 5),
                pw.Text("• Using a heating pad can help relieve menstrual cramps."),
              ],
            ),
          ),
        ];
      },
    ),
  );

  try {
    // Save PDF file
    final String dir;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectory())?.path ?? (await getApplicationDocumentsDirectory()).path;
    } else {
      dir = (await getApplicationDocumentsDirectory()).path;
    }
    
    final String fileName = 'health_insights_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
    final String path = '$dir/$fileName';
    
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
    
    // Show success toast
    Fluttertoast.showToast(
      msg: "PDF saved to $path",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    
    // Open the PDF
    OpenFile.open(path);
    
  } catch (e) {
    // Show error toast
    Fluttertoast.showToast(
      msg: "Error: ${e.toString()}",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

// Helper function to build info items
pw.Widget _buildPdfInfoItem(String label, String value) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(
          fontSize: 10,
          color: PdfColors.grey700,
        ),
      ),
      pw.SizedBox(height: 2),
      pw.Text(
        value,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ],
  );
}

// Helper function to build stat boxes
pw.Widget _buildPdfStatBox(String label, String value) {
  return pw.Container(
    width: 250,
    padding: const pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
      color: PdfColors.purple50,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.purple900,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.purple800,
          ),
        ),
      ],
    ),
  );
}

// Helper function to build table of cycle data
pw.Widget _buildPdfTable(List<DateTime> periodDates, List<int> painLevels, List<int> cycleLengths) {
  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.grey300),
    children: [
      // Table header
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.pink100),
        children: [
          _buildTableCell('Date', isHeader: true),
          _buildTableCell('Pain Level', isHeader: true),
          _buildTableCell('Cycle Length', isHeader: true),
        ],
      ),
      // Table rows
      for (int i = 0; i < periodDates.length; i++)
        pw.TableRow(
          children: [
            _buildTableCell(DateFormat('MMM dd, yyyy').format(periodDates[i])),
            _buildTableCell(i < painLevels.length ? '${painLevels[i]}/10' : 'N/A'),
            _buildTableCell(i > 0 && i-1 < cycleLengths.length ? '${cycleLengths[i-1]} days' : 'N/A'),
          ],
        ),
    ],
  );
}

// Helper function for table cells
pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(8),
    alignment: pw.Alignment.center,
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}