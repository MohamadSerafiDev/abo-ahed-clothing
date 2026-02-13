import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';

/// Coupon Field Widget
class CouponField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onApply;

  const CouponField({Key? key, required this.controller, this.onApply})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'enter_coupon'.tr,
              hintStyle: TextStyles.bodyMedium().copyWith(
                color: AppLightTheme.textBody,
              ),
              filled: true,
              fillColor: AppLightTheme.surfaceGrey,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppLightTheme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppLightTheme.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: AppLightTheme.goldPrimary,
                  width: 1.5,
                ),
              ),
            ),
            style: TextStyles.bodyMedium(),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: onApply ?? () {},
          child: Text('apply'.tr, style: TextStyles.buttonText),
        ),
      ],
    );
  }
}
