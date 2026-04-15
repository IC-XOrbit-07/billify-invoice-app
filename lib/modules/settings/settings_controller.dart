import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:billify/data/services/settings_service.dart';

class SettingsController extends GetxController {
  final SettingsService _settingsService = SettingsService();

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController gstController;
  late TextEditingController taxRateController;

  @override
  void onInit() {
    super.onInit();
    nameController =
        TextEditingController(text: _settingsService.businessName);
    addressController =
        TextEditingController(text: _settingsService.businessAddress);
    phoneController =
        TextEditingController(text: _settingsService.businessPhone);
    emailController =
        TextEditingController(text: _settingsService.businessEmail);
    gstController =
        TextEditingController(text: _settingsService.businessGst);
    taxRateController = TextEditingController(
        text: _settingsService.defaultTaxRate.toString());
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    gstController.dispose();
    taxRateController.dispose();
    super.onClose();
  }

  void saveSettings() {
    _settingsService.businessName = nameController.text.trim();
    _settingsService.businessAddress = addressController.text.trim();
    _settingsService.businessPhone = phoneController.text.trim();
    _settingsService.businessEmail = emailController.text.trim();
    _settingsService.businessGst = gstController.text.trim();
    final taxRate = double.tryParse(taxRateController.text.trim());
    if (taxRate != null) {
      _settingsService.defaultTaxRate = taxRate;
    }
    Get.snackbar('Saved', 'Settings saved successfully',
        snackPosition: SnackPosition.BOTTOM);
  }
}
