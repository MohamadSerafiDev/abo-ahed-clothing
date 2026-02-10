import 'package:flutter/material.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;

  const CustomFilterChip({
    super.key,
    required this.label,
    this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppLightTheme.goldPrimary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppLightTheme.goldPrimary
                : const Color(0xFFF5F5F5),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppLightTheme.goldPrimary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isActive ? Colors.white : AppLightTheme.textBody,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: isActive ? Colors.white : AppLightTheme.textBody,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
