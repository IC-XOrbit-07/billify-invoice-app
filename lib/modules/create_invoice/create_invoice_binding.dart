import 'package:get/get.dart';
import 'package:billify/modules/create_invoice/create_invoice_controller.dart';

class CreateInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateInvoiceController>(() => CreateInvoiceController());
  }
}
