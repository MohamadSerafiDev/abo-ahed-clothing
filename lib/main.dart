import 'dart:developer';
import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:abo_abed_clothing/core/localization/app_translations.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Storage
  final storage = await StorageService().init();
  Get.put(storage);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    // log(storage.isFirstTime().toString());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      translations: AppTranslations(),
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('en', 'US'),
      // Routing
      initialRoute: storage.isFirstTime()
          ? Routes.INTRO
          : storage.isLoggedIn()
          ? Routes.HOME
          : Routes.LOGIN,
      getPages: AppPages.routes,
    );
  }
}
