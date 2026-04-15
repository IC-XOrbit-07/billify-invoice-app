import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:billify/data/models/invoice_model.dart';
import 'package:billify/data/models/client_model.dart';
import 'package:billify/data/services/invoice_service.dart';
import 'package:billify/data/services/client_service.dart';
import 'package:billify/data/services/settings_service.dart';
import 'package:billify/core/utils/pdf_generator.dart';

class InvoicePreviewController extends GetxController {
  final InvoiceService _invoiceService = InvoiceService();
  final ClientService _clientService = ClientService();
  final SettingsService _settingsService = SettingsService();

  final invoice = Rxn<InvoiceModel>();
  final client = Rxn<ClientModel>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final String? invoiceId = Get.arguments as String?;
    if (invoiceId != null) {
      loadInvoice(invoiceId);
    }
  }

  void loadInvoice(String id) {
    isLoading.value = true;
    invoice.value = _invoiceService.getInvoice(id);
    if (invoice.value != null) {
      client.value = _clientService.getClient(invoice.value!.clientId);
    }
    isLoading.value = false;
  }

  Future<void> togglePaidStatus() async {
    if (invoice.value == null) return;
    final updated = invoice.value!.copyWith(isPaid: !invoice.value!.isPaid);
    await _invoiceService.updateInvoice(updated);
    invoice.value = updated;
  }

  Future<void> deleteInvoice() async {
    if (invoice.value == null) return;
    await _invoiceService.deleteInvoice(invoice.value!.id);
    Get.back();
    Get.snackbar('Deleted', 'Invoice deleted successfully',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> sharePdf() async {
    if (invoice.value == null || client.value == null) return;
    final pdf = await PdfGenerator.generateInvoice(
      invoice: invoice.value!,
      client: client.value!,
      businessName: _settingsService.businessName,
      businessAddress: _settingsService.businessAddress,
      businessPhone: _settingsService.businessPhone,
      businessEmail: _settingsService.businessEmail,
      businessGst: _settingsService.businessGst,
    );
    final bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${invoice.value!.invoiceNumber}.pdf',
    );
  }

  Future<void> printPdf() async {
    if (invoice.value == null || client.value == null) return;
    final pdf = await PdfGenerator.generateInvoice(
      invoice: invoice.value!,
      client: client.value!,
      businessName: _settingsService.businessName,
      businessAddress: _settingsService.businessAddress,
      businessPhone: _settingsService.businessPhone,
      businessEmail: _settingsService.businessEmail,
      businessGst: _settingsService.businessGst,
    );
    final bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (_) => bytes);
  }
}
