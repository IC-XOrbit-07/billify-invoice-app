import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:billify/data/models/client_model.dart';
import 'package:billify/data/services/client_service.dart';

class ClientsController extends GetxController {
  final ClientService _clientService = ClientService();
  final clients = <ClientModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadClients();
  }

  void loadClients() {
    clients.value = _clientService.getAllClients();
  }

  ClientModel? getClient(String id) {
    return _clientService.getClient(id);
  }

  Future<void> addClient({
    required String name,
    required String email,
    required String phone,
    required String address,
    String gstNumber = '',
  }) async {
    final client = ClientModel(
      id: const Uuid().v4(),
      name: name,
      email: email,
      phone: phone,
      address: address,
      gstNumber: gstNumber,
    );
    await _clientService.addClient(client);
    loadClients();
  }

  Future<void> updateClient({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String address,
    String gstNumber = '',
  }) async {
    final existing = _clientService.getClient(id);
    if (existing == null) return;
    final updated = existing.copyWith(
      name: name,
      email: email,
      phone: phone,
      address: address,
      gstNumber: gstNumber,
    );
    await _clientService.updateClient(updated);
    loadClients();
  }

  Future<void> deleteClient(String id) async {
    await _clientService.deleteClient(id);
    loadClients();
  }
}
