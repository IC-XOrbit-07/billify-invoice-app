import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:billify/core/themes/app_theme.dart';
import 'package:billify/core/constants/app_constants.dart';
import 'package:billify/modules/create_invoice/create_invoice_controller.dart';
import 'package:billify/modules/create_invoice/add_items_screen.dart';
import 'package:billify/routes/app_routes.dart';

class CreateInvoiceScreen extends GetView<CreateInvoiceController> {
  const CreateInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Select Client
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Client',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => Get.toNamed(AppRoutes.addClient)
                              ?.then((_) => controller.loadClients()),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('New'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      if (controller.clients.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'No clients found. Add a client first.',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          ),
                        );
                      }
                      return DropdownButtonFormField<String>(
                        initialValue: controller.selectedClient.value?.id,
                        decoration: const InputDecoration(
                          labelText: 'Choose a client',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        items: controller.clients.map((client) {
                          return DropdownMenuItem(
                            value: client.id,
                            child: Text(client.name),
                          );
                        }).toList(),
                        onChanged: (id) {
                          if (id != null) {
                            final client = controller.clients
                                .firstWhere((c) => c.id == id);
                            controller.selectClient(client);
                          }
                        },
                      );
                    }),
                    Obx(() {
                      final client = controller.selectedClient.value;
                      if (client == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(client.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              if (client.email.isNotEmpty)
                                Text(client.email,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.textSecondary)),
                              if (client.phone.isNotEmpty)
                                Text(client.phone,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.textSecondary)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Due Date
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Due Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => InkWell(
                          onTap: () => controller.pickDueDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppTheme.dividerColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    color: AppTheme.textSecondary, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  dateFormat.format(controller.dueDate.value),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_drop_down,
                                    color: AppTheme.textSecondary),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Invoice Items
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Items',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _showAddItemDialog(context),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Item'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      if (controller.items.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(Icons.add_shopping_cart_outlined,
                                    size: 40,
                                    color: AppTheme.textSecondary),
                                SizedBox(height: 8),
                                Text(
                                  'No items added',
                                  style: TextStyle(
                                      color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          ...controller.items.asMap().entries.map((entry) {
                            final i = entry.key;
                            final item = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.w600)),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${item.quantity} × ${AppConstants.currency}${item.unitPrice.toStringAsFixed(2)} • Tax: ${item.taxRate}%',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${AppConstants.currency}${item.totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () => controller.removeItem(i),
                                      child: const Icon(
                                        Icons.remove_circle_outline,
                                        color: AppTheme.errorColor,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const Divider(),
                          _buildTotalRow('Subtotal',
                              '${AppConstants.currency}${controller.subtotal.toStringAsFixed(2)}'),
                          const SizedBox(height: 4),
                          _buildTotalRow('Tax (GST)',
                              '${AppConstants.currency}${controller.taxAmount.toStringAsFixed(2)}'),
                          const Divider(),
                          _buildTotalRow(
                            'Total',
                            '${AppConstants.currency}${controller.totalAmount.toStringAsFixed(2)}',
                            isBold: true,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes (optional)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      onChanged: controller.setNotes,
                      decoration: const InputDecoration(
                        hintText: 'Add any notes for this invoice...',
                        prefixIcon: Icon(Icons.note_outlined),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: controller.saveInvoice,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('Create Invoice'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: isBold ? 16 : 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color:
                    isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
              )),
          Text(value,
              style: TextStyle(
                fontSize: isBold ? 16 : 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: isBold ? AppTheme.primaryColor : AppTheme.textPrimary,
              )),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    Get.to(() => const AddItemsScreen());
  }
}
