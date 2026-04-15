import 'package:hive/hive.dart';
import 'package:billify/core/constants/app_constants.dart';
import 'package:billify/data/models/invoice_model.dart';

class InvoiceService {
  Box<InvoiceModel> get _box =>
      Hive.box<InvoiceModel>(AppConstants.invoiceBox);

  List<InvoiceModel> getAllInvoices() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  InvoiceModel? getInvoice(String id) {
    try {
      return _box.values.firstWhere((inv) => inv.id == id);
    } catch (_) {
      return null;
    }
  }

  List<InvoiceModel> getInvoicesByClient(String clientId) {
    return _box.values.where((inv) => inv.clientId == clientId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addInvoice(InvoiceModel invoice) async {
    await _box.put(invoice.id, invoice);
  }

  Future<void> updateInvoice(InvoiceModel invoice) async {
    await _box.put(invoice.id, invoice);
  }

  Future<void> deleteInvoice(String id) async {
    await _box.delete(id);
  }

  int get invoiceCount => _box.length;

  double get totalRevenue {
    return _box.values.fold(0.0, (sum, inv) => sum + inv.totalAmount);
  }

  double get paidRevenue {
    return _box.values
        .where((inv) => inv.isPaid)
        .fold(0.0, (sum, inv) => sum + inv.totalAmount);
  }

  double get unpaidRevenue {
    return _box.values
        .where((inv) => !inv.isPaid)
        .fold(0.0, (sum, inv) => sum + inv.totalAmount);
  }

  int get paidCount => _box.values.where((inv) => inv.isPaid).length;
  int get unpaidCount => _box.values.where((inv) => !inv.isPaid).length;
}
