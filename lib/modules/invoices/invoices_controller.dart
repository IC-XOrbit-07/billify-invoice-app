import 'package:get/get.dart';
import 'package:billify/data/models/invoice_model.dart';
import 'package:billify/data/services/invoice_service.dart';
import 'package:billify/data/services/client_service.dart';

class InvoicesController extends GetxController {
  final InvoiceService _invoiceService = InvoiceService();
  final ClientService _clientService = ClientService();
  final invoices = <InvoiceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
  }

  void loadInvoices() {
    invoices.value = _invoiceService.getAllInvoices();
  }

  String getClientName(String clientId) {
    final client = _clientService.getClient(clientId);
    return client?.name ?? 'Unknown Client';
  }

  Future<void> deleteInvoice(String id) async {
    await _invoiceService.deleteInvoice(id);
    loadInvoices();
  }

  Future<void> togglePaidStatus(InvoiceModel invoice) async {
    final updated = invoice.copyWith(isPaid: !invoice.isPaid);
    await _invoiceService.updateInvoice(updated);
    loadInvoices();
  }
}
