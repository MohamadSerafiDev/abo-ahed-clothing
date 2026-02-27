import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Centralized shipping status label and color helpers.
class ShippingHelpers {
  ShippingHelpers._();

  /// Returns the localized label for a shipping status string.
  static String getStatusLabel(String status) {
    final map = {
      'Preparing': 'shipping_preparing'.tr,
      'OnWay': 'shipping_on_way'.tr,
      'Delivered': 'shipping_delivered'.tr,
      'Failed': 'shipping_failed'.tr,
    };
    return map[status] ?? status;
  }

  /// Returns the color associated with a shipping status string.
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Preparing':
        return Colors.orange;
      case 'OnWay':
        return Colors.indigo;
      case 'Delivered':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      default:
        return AppLightTheme.textBody;
    }
  }
}
