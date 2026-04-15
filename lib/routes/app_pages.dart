import 'package:get/get.dart';
import 'package:billify/routes/app_routes.dart';
import 'package:billify/modules/splash/splash_screen.dart';
import 'package:billify/modules/dashboard/dashboard_screen.dart';
import 'package:billify/modules/dashboard/dashboard_binding.dart';
import 'package:billify/modules/clients/client_list_screen.dart';
import 'package:billify/modules/clients/add_edit_client_screen.dart';
import 'package:billify/modules/clients/clients_binding.dart';
import 'package:billify/modules/invoices/invoice_list_screen.dart';
import 'package:billify/modules/invoices/invoices_binding.dart';
import 'package:billify/modules/create_invoice/create_invoice_screen.dart';
import 'package:billify/modules/create_invoice/create_invoice_binding.dart';
import 'package:billify/modules/invoice_preview/invoice_preview_screen.dart';
import 'package:billify/modules/invoice_preview/invoice_preview_binding.dart';
import 'package:billify/modules/settings/settings_screen.dart';
import 'package:billify/modules/settings/settings_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.clientList,
      page: () => const ClientListScreen(),
      binding: ClientsBinding(),
    ),
    GetPage(
      name: AppRoutes.addClient,
      page: () => const AddEditClientScreen(),
      binding: ClientsBinding(),
    ),
    GetPage(
      name: AppRoutes.editClient,
      page: () => const AddEditClientScreen(),
      binding: ClientsBinding(),
    ),
    GetPage(
      name: AppRoutes.invoiceList,
      page: () => const InvoiceListScreen(),
      binding: InvoicesBinding(),
    ),
    GetPage(
      name: AppRoutes.createInvoice,
      page: () => const CreateInvoiceScreen(),
      binding: CreateInvoiceBinding(),
    ),
    GetPage(
      name: AppRoutes.invoicePreview,
      page: () => const InvoicePreviewScreen(),
      binding: InvoicePreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
  ];
}
