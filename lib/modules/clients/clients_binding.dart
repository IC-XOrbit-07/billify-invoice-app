import 'package:get/get.dart';
import 'package:billify/modules/clients/clients_controller.dart';

class ClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientsController>(() => ClientsController());
  }
}
