import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isNew = product.condition.toLowerCase() == 'new';
    final sizeLabel = _formatSize(product.size);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
                product.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppLightTheme.textHeadline,
                  height: 1.3,
                ),
              )
              .animate(delay: 500.ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 12),

          // Price
          Text(
                '${product.price.toStringAsFixed(0)} SYP',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppLightTheme.goldPrimary,
                ),
              )
              .animate(delay: 500.ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 16),

          // Condition & Category Row
          Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isNew
                          ? AppLightTheme.goldPrimary
                          : AppLightTheme.usedTagSilver,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isNew ? 'new'.tr : 'used'.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppLightTheme.textBody,
                    ),
                  ),
                ],
              )
              .animate(delay: 500.ms)
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.9, 0.9)),
          const SizedBox(height: 12),

          if (sizeLabel != null) ...[
            const SizedBox(width: 12),
            Text(
              '${'size'.tr}: $sizeLabel',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppLightTheme.textBody,
              ),
            ),
          ],
          const SizedBox(height: 22),

          // Divider
          const Divider(
            color: AppLightTheme.dividerColor,
          ).animate(delay: 500.ms).fadeIn(),
          const SizedBox(height: 20),

          // Description
          if (product.description != null &&
              product.description!.isNotEmpty) ...[
            Text(
                  'description'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppLightTheme.textHeadline,
                  ),
                )
                .animate(delay: 500.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 8),
            Text(
                  product.description!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppLightTheme.textBody,
                    height: 1.6,
                  ),
                )
                .animate(delay: 500.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  String? _formatSize(String? rawSize) {
    if (rawSize == null || rawSize.isEmpty) return null;

    const sizeMap = {
      'baby': 'Baby',
      'midum': 'Medium',
      'large': 'Large',
      'x_large': 'XL',
      'xx_large': 'XXL',
      'xxx_large': '3XL',
      'xxxx_large': '4XL',
      'xxxxx_large': '5XL',
    };

    return sizeMap[rawSize] ?? rawSize;
  }
}
