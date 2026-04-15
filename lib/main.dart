import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:billify/core/themes/app_theme.dart';
import 'package:billify/data/local_db/hive_service.dart';
import 'package:billify/routes/app_routes.dart';
import 'package:billify/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const BillifyApp());
}

class BillifyApp extends StatelessWidget {
  const BillifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Billify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
