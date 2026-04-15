class AppConstants {
  AppConstants._();

  static const String appName = 'Billify';
  static const String appVersion = '1.0.0';
  static const String currency = '₹';

  // Hive box names
  static const String clientBox = 'clients';
  static const String invoiceBox = 'invoices';
  static const String settingsBox = 'settings';

  // Hive type IDs
  static const int clientTypeId = 0;
  static const int invoiceTypeId = 1;
  static const int invoiceItemTypeId = 2;

  // Settings keys
  static const String businessNameKey = 'businessName';
  static const String businessAddressKey = 'businessAddress';
  static const String businessPhoneKey = 'businessPhone';
  static const String businessEmailKey = 'businessEmail';
  static const String businessGstKey = 'businessGst';
  static const String defaultTaxRateKey = 'defaultTaxRate';
  static const String invoiceCounterKey = 'invoiceCounter';
}
