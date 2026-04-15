import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:billify/data/models/invoice_model.dart';
import 'package:billify/data/models/client_model.dart';

class PdfGenerator {
  static Future<pw.Document> generateInvoice({
    required InvoiceModel invoice,
    required ClientModel client,
    required String businessName,
    required String businessAddress,
    required String businessPhone,
    required String businessEmail,
    required String businessGst,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _buildHeader(businessName),
          pw.SizedBox(height: 20),
          _buildBusinessAndClientInfo(
            businessName: businessName,
            businessAddress: businessAddress,
            businessPhone: businessPhone,
            businessEmail: businessEmail,
            businessGst: businessGst,
            client: client,
          ),
          pw.SizedBox(height: 20),
          _buildInvoiceMeta(invoice, dateFormat),
          pw.SizedBox(height: 20),
          _buildItemsTable(invoice),
          pw.SizedBox(height: 20),
          _buildTotals(invoice),
          pw.SizedBox(height: 40),
          _buildFooter(),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(String businessName) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 16),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 2),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            businessName.isEmpty ? 'INVOICE' : businessName.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromHex('#6C63FF'),
            ),
          ),
          pw.Text(
            'INVOICE',
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey400,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBusinessAndClientInfo({
    required String businessName,
    required String businessAddress,
    required String businessPhone,
    required String businessEmail,
    required String businessGst,
    required ClientModel client,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('From',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#6C63FF'))),
              pw.SizedBox(height: 4),
              if (businessName.isNotEmpty)
                pw.Text(businessName,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              if (businessAddress.isNotEmpty) pw.Text(businessAddress),
              if (businessPhone.isNotEmpty) pw.Text('Phone: $businessPhone'),
              if (businessEmail.isNotEmpty) pw.Text('Email: $businessEmail'),
              if (businessGst.isNotEmpty) pw.Text('GST: $businessGst'),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Bill To',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#6C63FF'))),
              pw.SizedBox(height: 4),
              pw.Text(client.name,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              if (client.address.isNotEmpty) pw.Text(client.address),
              pw.Text('Phone: ${client.phone}'),
              pw.Text('Email: ${client.email}'),
              if (client.gstNumber.isNotEmpty)
                pw.Text('GST: ${client.gstNumber}'),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildInvoiceMeta(
      InvoiceModel invoice, DateFormat dateFormat) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F5F5FA'),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice No',
                  style: const pw.TextStyle(color: PdfColors.grey600)),
              pw.Text(invoice.invoiceNumber,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('Date',
                  style: const pw.TextStyle(color: PdfColors.grey600)),
              pw.Text(dateFormat.format(invoice.createdAt),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Due Date',
                  style: const pw.TextStyle(color: PdfColors.grey600)),
              pw.Text(dateFormat.format(invoice.dueDate),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemsTable(InvoiceModel invoice) {
    final headers = ['#', 'Item', 'Qty', 'Price', 'Tax %', 'Amount'];
    final data = invoice.items.asMap().entries.map((entry) {
      final i = entry.key;
      final item = entry.value;
      final amount = item.quantity * item.unitPrice;
      final taxAmount = amount * (item.taxRate / 100);
      return [
        '${i + 1}',
        item.name,
        '${item.quantity}',
        '\u20B9${item.unitPrice.toStringAsFixed(2)}',
        '${item.taxRate}%',
        '\u20B9${(amount + taxAmount).toStringAsFixed(2)}',
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#6C63FF'),
        borderRadius: const pw.BorderRadius.only(
          topLeft: pw.Radius.circular(8),
          topRight: pw.Radius.circular(8),
        ),
      ),
      headerAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.center,
        5: pw.Alignment.centerRight,
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.center,
        5: pw.Alignment.centerRight,
      },
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      oddRowDecoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F9FAFB'),
      ),
    );
  }

  static pw.Widget _buildTotals(InvoiceModel invoice) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 250,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            _totalRow('Subtotal', '\u20B9${invoice.subtotal.toStringAsFixed(2)}'),
            pw.SizedBox(height: 4),
            _totalRow('Tax (GST)', '\u20B9${invoice.taxAmount.toStringAsFixed(2)}'),
            pw.Divider(color: PdfColors.grey300),
            _totalRow(
              'Total',
              '\u20B9${invoice.totalAmount.toStringAsFixed(2)}',
              isBold: true,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _totalRow(String label, String value,
      {bool isBold = false, double fontSize = 12}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                fontWeight: isBold ? pw.FontWeight.bold : null,
                fontSize: fontSize)),
        pw.Text(value,
            style: pw.TextStyle(
                fontWeight: isBold ? pw.FontWeight.bold : null,
                fontSize: fontSize)),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 16),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'Thank you for your business!',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromHex('#6C63FF'),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Generated with Billify',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}
