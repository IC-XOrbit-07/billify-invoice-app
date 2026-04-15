import 'package:hive/hive.dart';
import 'package:billify/core/constants/app_constants.dart';

class SettingsService {
  Box get _box => Hive.box(AppConstants.settingsBox);

  String get businessName =>
      _box.get(AppConstants.businessNameKey, defaultValue: '') as String;
  set businessName(String value) =>
      _box.put(AppConstants.businessNameKey, value);

  String get businessAddress =>
      _box.get(AppConstants.businessAddressKey, defaultValue: '') as String;
  set businessAddress(String value) =>
      _box.put(AppConstants.businessAddressKey, value);

  String get businessPhone =>
      _box.get(AppConstants.businessPhoneKey, defaultValue: '') as String;
  set businessPhone(String value) =>
      _box.put(AppConstants.businessPhoneKey, value);

  String get businessEmail =>
      _box.get(AppConstants.businessEmailKey, defaultValue: '') as String;
  set businessEmail(String value) =>
      _box.put(AppConstants.businessEmailKey, value);

  String get businessGst =>
      _box.get(AppConstants.businessGstKey, defaultValue: '') as String;
  set businessGst(String value) =>
      _box.put(AppConstants.businessGstKey, value);

  double get defaultTaxRate =>
      _box.get(AppConstants.defaultTaxRateKey, defaultValue: 18.0) as double;
  set defaultTaxRate(double value) =>
      _box.put(AppConstants.defaultTaxRateKey, value);

  int get invoiceCounter =>
      _box.get(AppConstants.invoiceCounterKey, defaultValue: 0) as int;
  set invoiceCounter(int value) =>
      _box.put(AppConstants.invoiceCounterKey, value);

  String generateInvoiceNumber() {
    final counter = invoiceCounter + 1;
    invoiceCounter = counter;
    return 'INV-${counter.toString().padLeft(5, '0')}';
  }
}
