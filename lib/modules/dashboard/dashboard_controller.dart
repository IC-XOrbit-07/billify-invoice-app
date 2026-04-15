import 'package:get/get.dart';
import 'package:billify/data/services/invoice_service.dart';
import 'package:billify/data/services/client_service.dart';

class DashboardController extends GetxController {
  final InvoiceService _invoiceService = InvoiceService();
  final ClientService _clientService = ClientService();

  final totalInvoices = 0.obs;
  final totalClients = 0.obs;
  final totalRevenue = 0.0.obs;
  final paidRevenue = 0.0.obs;
  final unpaidRevenue = 0.0.obs;
  final paidCount = 0.obs;
  final unpaidCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshStats();
  }

  void refreshStats() {
    totalInvoices.value = _invoiceService.invoiceCount;
    totalClients.value = _clientService.clientCount;
    totalRevenue.value = _invoiceService.totalRevenue;
    paidRevenue.value = _invoiceService.paidRevenue;
    unpaidRevenue.value = _invoiceService.unpaidRevenue;
    paidCount.value = _invoiceService.paidCount;
    unpaidCount.value = _invoiceService.unpaidCount;
  }
}
