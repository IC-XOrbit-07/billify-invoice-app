import 'package:flutter_test/flutter_test.dart';
import 'package:billify/core/constants/app_constants.dart';

void main() {
  test('AppConstants has correct values', () {
    expect(AppConstants.appName, 'Billify');
    expect(AppConstants.currency, '₹');
    expect(AppConstants.clientBox, 'clients');
    expect(AppConstants.invoiceBox, 'invoices');
  });
}
