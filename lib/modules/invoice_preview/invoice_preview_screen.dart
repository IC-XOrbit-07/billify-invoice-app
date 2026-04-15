import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:billify/core/themes/app_theme.dart';
import 'package:billify/core/constants/app_constants.dart';
import 'package:billify/data/models/invoice_model.dart';
import 'package:billify/modules/invoice_preview/invoice_preview_controller.dart';

class InvoicePreviewScreen extends GetView<InvoicePreviewController> {
  const InvoicePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: controller.sharePdf,
            tooltip: 'Share PDF',
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: controller.printPdf,
            tooltip: 'Print',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'toggle') {
                controller.togglePaidStatus();
              } else if (value == 'delete') {
                _showDeleteDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle',
                child: Obx(() => Row(
                      children: [
                        Icon(
                          controller.invoice.value?.isPaid == true
                              ? Icons.unpublished_outlined
                              : Icons.check_circle_outline,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(controller.invoice.value?.isPaid == true
                            ? 'Mark Unpaid'
                            : 'Mark Paid'),
                      ],
                    )),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline,
                        size: 18, color: AppTheme.errorColor),
                    SizedBox(width: 8),
                    Text('Delete',
                        style: TextStyle(color: AppTheme.errorColor)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final invoice = controller.invoice.value;
        final client = controller.client.value;
        if (invoice == null || client == null) {
          return const Center(child: Text('Invoice not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.invoiceNumber,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Created: ${dateFormat.format(invoice.createdAt)}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: invoice.isPaid
                              ? AppTheme.successColor.withValues(alpha: 0.1)
                              : AppTheme.warningColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          invoice.isPaid ? 'PAID' : 'UNPAID',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: invoice.isPaid
                                ? AppTheme.successColor
                                : AppTheme.warningColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Client Info
                  const Text(
                    'Bill To',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(client.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  if (client.address.isNotEmpty)
                    Text(client.address,
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 13)),
                  Text(client.email,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13)),
                  Text(client.phone,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13)),
                  if (client.gstNumber.isNotEmpty)
                    Text('GST: ${client.gstNumber}',
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 13)),

                  const SizedBox(height: 8),
                  Text(
                    'Due: ${dateFormat.format(invoice.dueDate)}',
                    style: const TextStyle(
                      color: AppTheme.warningColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(height: 32),

                  // Items Table
                  const Text(
                    'Items',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildItemsTable(invoice),
                  const SizedBox(height: 20),

                  // Totals
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _totalRow('Subtotal',
                            '${AppConstants.currency}${invoice.subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _totalRow('Tax (GST)',
                            '${AppConstants.currency}${invoice.taxAmount.toStringAsFixed(2)}'),
                        const Divider(height: 16),
                        _totalRow(
                          'Total Amount',
                          '${AppConstants.currency}${invoice.totalAmount.toStringAsFixed(2)}',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  if (invoice.notes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(invoice.notes,
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 13)),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.sharePdf,
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share PDF'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.printPdf,
                icon: const Icon(Icons.download_outlined),
                label: const Text('Download'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTable(InvoiceModel invoice) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: AppTheme.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.05),
          ),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Item',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Qty',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Price',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12),
                  textAlign: TextAlign.right),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Tax',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Amount',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12),
                  textAlign: TextAlign.right),
            ),
          ],
        ),
        ...invoice.items.map<TableRow>((item) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(item.name, style: const TextStyle(fontSize: 13)),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('${item.quantity}',
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                    '${AppConstants.currency}${item.unitPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.right),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('${item.taxRate}%',
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                    '${AppConstants.currency}${item.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _totalRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
            )),
        Text(value,
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? AppTheme.primaryColor : AppTheme.textPrimary,
            )),
      ],
    );
  }

  void _showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Invoice'),
        content: const Text('Are you sure you want to delete this invoice?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteInvoice();
            },
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
