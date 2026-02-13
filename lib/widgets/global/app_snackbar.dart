import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  /// Show a success snackbar
  static void showSuccess({
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.snackbar(
      title ?? 'success'.tr,
      message,
      backgroundColor: AppLightTheme.goldPrimary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: duration,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  /// Show an error snackbar
  static void showError({
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title ?? 'error'.tr,
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: duration,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  /// Show an info snackbar
  static void showInfo({
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.snackbar(
      title ?? 'info'.tr,
      message,
      backgroundColor: AppLightTheme.silverAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: duration,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }
}
