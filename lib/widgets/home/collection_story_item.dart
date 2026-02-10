import 'package:flutter/material.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';

class CollectionStoryItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback? onTap;

  const CollectionStoryItem({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppLightTheme.goldPrimary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(icon, color: AppLightTheme.goldPrimary, size: 28),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppLightTheme.textBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
