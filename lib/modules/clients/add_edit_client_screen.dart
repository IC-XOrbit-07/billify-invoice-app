import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:billify/core/themes/app_theme.dart';
import 'package:billify/core/utils/validators.dart';
import 'package:billify/modules/clients/clients_controller.dart';
import 'package:billify/data/models/client_model.dart';

class AddEditClientScreen extends GetView<ClientsController> {
  const AddEditClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? clientId = Get.arguments as String?;
    final isEditing = clientId != null;
    ClientModel? existingClient;
    if (isEditing) {
      existingClient = controller.getClient(clientId);
    }

    final nameController =
        TextEditingController(text: existingClient?.name ?? '');
    final emailController =
        TextEditingController(text: existingClient?.email ?? '');
    final phoneController =
        TextEditingController(text: existingClient?.phone ?? '');
    final addressController =
        TextEditingController(text: existingClient?.address ?? '');
    final gstController =
        TextEditingController(text: existingClient?.gstNumber ?? '');
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Client' : 'Add Client'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Client Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Client Name *',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => Validators.required(v, 'Name'),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: Validators.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone *',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: Validators.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address *',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        validator: (v) => Validators.required(v, 'Address'),
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: gstController,
                        decoration: const InputDecoration(
                          labelText: 'GST Number (optional)',
                          prefixIcon: Icon(Icons.numbers_outlined),
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (isEditing) {
                      controller.updateClient(
                        id: clientId,
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phone: phoneController.text.trim(),
                        address: addressController.text.trim(),
                        gstNumber: gstController.text.trim(),
                      );
                      Get.back();
                      Get.snackbar('Updated', 'Client updated successfully',
                          snackPosition: SnackPosition.BOTTOM);
                    } else {
                      controller.addClient(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phone: phoneController.text.trim(),
                        address: addressController.text.trim(),
                        gstNumber: gstController.text.trim(),
                      );
                      Get.back();
                      Get.snackbar('Added', 'Client added successfully',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(isEditing ? 'Update Client' : 'Add Client'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
