import 'package:get/get.dart';

class Validators {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'phone_required'.tr; // Using your GetX translations
    }

    // Turkey: +90 followed by 10 digits (supports spaces)
    // Syria: +963 or 0 followed by 9 and 8 digits
    final String pattern =
        r'^(\+90\s?[1-9]\d{2}\s?\d{3}\s?\d{2}\s?\d{2})|((?:\+963|0)?9\d{8})$';

    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'invalid_phone_format'.tr;
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName ${'is_required'.tr}';
    }
    return null;
  }
}
