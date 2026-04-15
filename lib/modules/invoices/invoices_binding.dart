import 'package:get/get.dart';
import 'package:billify/modules/invoices/invoices_controller.dart';

class InvoicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoicesController>(() => InvoicesController());
  }
}
