import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';

/// Shared helper functions for order status handling across the app
class OrderHelpers {
  /// Returns the localized label for a given order status
  static String getStatusLabel(String status) {
    final map = {
      'Pending': 'order_status_pending'.tr,
      'Confirmed': 'order_status_confirmed'.tr,
      'PaymentUnderReview': 'order_status_payment_under_review'.tr,
      'Processing': 'order_status_processing'.tr,
      'OnWay': 'order_status_on_way'.tr,
      'Shipped': 'order_status_shipped'.tr,
      'Delivered': 'order_status_delivered'.tr,
      'Cancelled': 'order_status_cancelled'.tr,
    };
    return map[status] ?? status;
  }

  /// Returns the color associated with a given order status
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.blue;
      case 'PaymentUnderReview':
        return Colors.purple;
      case 'Processing':
        return Colors.teal;
      case 'OnWay':
        return Colors.indigo;
      case 'Shipped':
        return Colors.cyan;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return AppLightTheme.textBody;
    }
  }
}
