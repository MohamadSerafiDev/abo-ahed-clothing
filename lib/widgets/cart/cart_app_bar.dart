import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';

/// App Bar for Cart Screen
class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int itemCount;

  const CartAppBar({this.itemCount = 0});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'store_name'.tr,
        style: TextStyles.headlineMedium().copyWith(),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Stack(
              children: [
                const Icon(Icons.shopping_bag_outlined),
                if (itemCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppLightTheme.goldPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
