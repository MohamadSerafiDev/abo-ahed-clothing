import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int? maxQuantity;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.maxQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppLightTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppLightTheme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton(
            icon: Icons.remove,
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          Text(
            quantity.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppLightTheme.textHeadline,
            ),
          ),
          _buildActionButton(
            icon: Icons.add,
            onPressed: (maxQuantity == null || quantity < maxQuantity!)
                ? () => onChanged(quantity + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: onPressed != null
            ? AppLightTheme.goldPrimary
            : AppLightTheme.silverAccent,
      ),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      padding: EdgeInsets.zero,
    );
  }
}
