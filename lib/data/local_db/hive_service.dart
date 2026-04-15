import 'package:hive_flutter/hive_flutter.dart';
import 'package:billify/core/constants/app_constants.dart';
import 'package:billify/data/models/client_model.dart';
import 'package:billify/data/models/invoice_model.dart';
import 'package:billify/data/models/invoice_item_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ClientModelAdapter());
    Hive.registerAdapter(InvoiceItemModelAdapter());
    Hive.registerAdapter(InvoiceModelAdapter());
    await Hive.openBox<ClientModel>(AppConstants.clientBox);
    await Hive.openBox<InvoiceModel>(AppConstants.invoiceBox);
    await Hive.openBox(AppConstants.settingsBox);
  }
}
