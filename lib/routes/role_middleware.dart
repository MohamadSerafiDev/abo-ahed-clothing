import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:abo_abed_clothing/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Middleware that redirects users based on their role after login.
class RoleMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final storage = Get.find<StorageService>();
    final role = storage.getRole();

    if (!storage.isLoggedIn()) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    switch (role) {
      case 'Admin':
        return const RouteSettings(name: Routes.ADMIN_HOME);
      case 'Courier':
        return const RouteSettings(name: Routes.COURIER_HOME);
      case 'Customer':
        return const RouteSettings(name: Routes.MAINHOME);
      default:
        return const RouteSettings(name: Routes.LOGIN);
    }
  }
}

/// Helper to get the initial route based on role.
String getHomeRouteForRole(StorageService storage) {
  if (!storage.isLoggedIn()) return Routes.LOGIN;

  switch (storage.getRole()) {
    case 'Admin':
      return Routes.ADMIN_HOME;
    case 'Courier':
      return Routes.COURIER_HOME;
    case 'Customer':
      return Routes.MAINHOME;
    default:
      return Routes.LOGIN;
  }
}
