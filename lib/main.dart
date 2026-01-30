import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:abo_abed_clothing/core/localization/app_translations.dart';
import 'package:abo_abed_clothing/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageService().init());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('en', 'US'),
      // Routing
      initialRoute: Routes.INTRO,
      getPages: AppPages.routes,
    );
  }
}
