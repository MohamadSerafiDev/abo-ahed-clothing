import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abo_abed_clothing/models/cart_model.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'summary_row.dart';

/// Cart Summary Widget - Displays checkout summary and total
class CartSummary extends StatelessWidget {
  final CartModel cart;
  final VoidCallback? onCheckout;

  const CartSummary({Key? key, required this.cart, this.onCheckout})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.totalPrice;
    const shipping = 0.0;
    final total = subtotal + shipping;

    return Container(
      decoration: const BoxDecoration(
        color: AppLightTheme.backgroundWhite,
        border: Border(
          top: BorderSide(color: AppLightTheme.dividerColor, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(12, 0, 0, 0),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtotal
          SummaryRow(label: 'المجموع الفرعي', value: '${subtotal.toInt()} ل س'),
          const SizedBox(height: 12),
          // Shipping
          SummaryRow(label: 'الشحن', value: 'مجاني', valueColor: Colors.green),
          const SizedBox(height: 12),
          const Divider(color: AppLightTheme.dividerColor, height: 1),
          const SizedBox(height: 16),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('total'.tr, style: TextStyles.headlineMedium()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${total.toInt()} ل س',
                    style: TextStyles.headlineMedium().copyWith(
                      fontSize: 22,
                      color: AppLightTheme.textHeadline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'شامل الضريبة',
                    style: TextStyles.labelGold.copyWith(
                      color: AppLightTheme.textBody,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppLightTheme.goldPrimary,
                elevation: 4,
                shadowColor: AppLightTheme.goldPrimary.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onCheckout ?? () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.rotate(
                    angle: 3.14159,
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                  Text(
                    'continue_checkout'.tr,
                    style: TextStyles.buttonText.copyWith(fontSize: 14),
                  ),
                  const Opacity(opacity: 0, child: Icon(Icons.arrow_forward)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
