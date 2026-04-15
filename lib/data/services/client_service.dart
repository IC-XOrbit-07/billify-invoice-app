import 'package:hive/hive.dart';
import 'package:billify/core/constants/app_constants.dart';
import 'package:billify/data/models/client_model.dart';

class ClientService {
  Box<ClientModel> get _box => Hive.box<ClientModel>(AppConstants.clientBox);

  List<ClientModel> getAllClients() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  ClientModel? getClient(String id) {
    try {
      return _box.values.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addClient(ClientModel client) async {
    await _box.put(client.id, client);
  }

  Future<void> updateClient(ClientModel client) async {
    await _box.put(client.id, client);
  }

  Future<void> deleteClient(String id) async {
    await _box.delete(id);
  }

  int get clientCount => _box.length;
}
