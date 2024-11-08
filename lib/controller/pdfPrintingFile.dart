import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rive/rive.dart';

Future<void> generateAndPrintPdf(BuildContext context, List<Map<String, dynamic>> cartItems) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: Container(
        color: const Color(0xFF357ED4),
        width: double.infinity,
        height: double.infinity,
        child: const RiveAnimation.asset(
          'assets/loader.riv',
          fit: BoxFit.contain,
        ),
      ),
    ),
  );

  await Future.delayed(const Duration(seconds: 5));

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Relatório de Compras',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  ['Nome do Produto', 'Quantidade'],
                  ...cartItems.map((item) => [
                    item['name'] ?? 'N/A',
                    item['quantity'].toString(),
                  ])
                ],
                border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                cellAlignment: pw.Alignment.center,
                cellPadding: const pw.EdgeInsets.all(8),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.green,
                ),
                cellStyle: const pw.TextStyle(
                  color: PdfColors.black,
                ),
                oddRowDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey200,
                ),

              ),
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );

  // Fecha a animação após 5 segundos
  Navigator.of(context).pop();
}
