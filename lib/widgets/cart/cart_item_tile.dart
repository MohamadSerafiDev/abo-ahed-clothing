import 'package:flutter/material.dart';
import 'package:abo_abed_clothing/models/cart_model.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/widgets/product/quantity_selector.dart';

/// Cart Item Tile Widget
class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    Key? key,
    required this.item,
    required this.onRemove,
    this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final imageUrl = product.mediaItems
        .where((media) => media.type == 'image')
        .map((media) => media.url)
        .firstOrNull;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppLightTheme.dividerColor, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          _ProductImage(imageUrl: imageUrl),
          const SizedBox(width: 16),
          // Product Details
          Expanded(
            child: _ProductDetails(
              item: item,
              product: product,
              onRemove: onRemove,
              onQuantityChanged: onQuantityChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Product Image Widget
class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 128,
      decoration: BoxDecoration(
        color: AppLightTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(4),
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null
          ? const Icon(
              Icons.image_not_supported_outlined,
              color: AppLightTheme.textBody,
            )
          : null,
    );
  }
}

/// Product Details Widget
class _ProductDetails extends StatelessWidget {
  final CartItemModel item;
  final dynamic product;
  final VoidCallback onRemove;
  final ValueChanged<int>? onQuantityChanged;

  const _ProductDetails({
    Key? key,
    required this.item,
    required this.product,
    required this.onRemove,
    this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name & Remove Button
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.title,
                style: TextStyles.titleLarge(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close),
              iconSize: 20,
              color: AppLightTheme.textBody,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Category Info
        Text(
          product.category,
          style: TextStyles.bodyMedium().copyWith(
            color: AppLightTheme.textBody,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        // Quantity Control & Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Quantity Selector - using existing widget
            QuantitySelector(
              quantity: item.quantity,
              onChanged: onQuantityChanged ?? (_) {},

              maxQuantity: product.stock,
            ),
            // Price
            Text(
              '${item.totalPrice.toInt()} ل س',
              style: TextStyles.titleLarge().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
