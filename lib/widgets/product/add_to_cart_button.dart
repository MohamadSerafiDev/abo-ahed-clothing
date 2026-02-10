import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddToCartButton extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;

  const AddToCartButton({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: product.isInStock ? onAddToCart : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppLightTheme.goldPrimary,
          disabledBackgroundColor: AppLightTheme.dividerColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          product.isInStock ? 'add_to_cart'.tr : 'out_of_stock'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
