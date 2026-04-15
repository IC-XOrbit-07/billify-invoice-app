import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:billify/data/models/client_model.dart';
import 'package:billify/data/models/invoice_model.dart';
import 'package:billify/data/models/invoice_item_model.dart';
import 'package:billify/data/services/client_service.dart';
import 'package:billify/data/services/invoice_service.dart';
import 'package:billify/data/services/settings_service.dart';
import 'package:billify/routes/app_routes.dart';

class CreateInvoiceController extends GetxController {
  final ClientService _clientService = ClientService();
  final InvoiceService _invoiceService = InvoiceService();
  final SettingsService _settingsService = SettingsService();

  final clients = <ClientModel>[].obs;
  final selectedClient = Rxn<ClientModel>();
  final items = <InvoiceItemModel>[].obs;
  final notes = ''.obs;
  final dueDate = DateTime.now().add(const Duration(days: 30)).obs;

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalBeforeTax);
  double get taxAmount =>
      items.fold(0.0, (sum, item) => sum + item.taxAmount);
  double get totalAmount => subtotal + taxAmount;

  @override
  void onInit() {
    super.onInit();
    loadClients();
  }

  void loadClients() {
    clients.value = _clientService.getAllClients();
  }

  void selectClient(ClientModel client) {
    selectedClient.value = client;
  }

  void addItem(InvoiceItemModel item) {
    items.add(item);
  }

  void updateItem(int index, InvoiceItemModel item) {
    items[index] = item;
  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  void setNotes(String value) {
    notes.value = value;
  }

  Future<void> pickDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      dueDate.value = picked;
    }
  }

  Future<void> saveInvoice() async {
    if (selectedClient.value == null) {
      Get.snackbar('Error', 'Please select a client',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100);
      return;
    }
    if (items.isEmpty) {
      Get.snackbar('Error', 'Please add at least one item',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100);
      return;
    }

    final invoice = InvoiceModel(
      id: const Uuid().v4(),
      invoiceNumber: _settingsService.generateInvoiceNumber(),
      clientId: selectedClient.value!.id,
      items: List<InvoiceItemModel>.from(items),
      dueDate: dueDate.value,
      notes: notes.value,
    );

    await _invoiceService.addInvoice(invoice);
    Get.back();
    Get.snackbar('Success', 'Invoice created successfully',
        snackPosition: SnackPosition.BOTTOM);

    // Navigate to preview
    Get.toNamed(AppRoutes.invoicePreview, arguments: invoice.id);
  }
}
