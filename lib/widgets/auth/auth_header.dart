import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.isLogin});
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppLightTheme.backgroundWhite,
            shape: BoxShape.circle,
            border: Border.all(color: AppLightTheme.dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppLightTheme.goldPrimary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Center(
                child: Icon(
                  FontAwesomeIcons.gem,
                  color: AppLightTheme.goldPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 600.ms).scale(delay: 0.ms),
        const SizedBox(height: 16),

        Text(
          'store_name'.tr,
          style: TextStyles.headlineMedium(isDark: false).copyWith(
            color: AppLightTheme.goldPrimary,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 32),
        Text(
          isLogin ? 'login_title'.tr : 'create_account_title'.tr,
          style: TextStyles.displayLarge(isDark: false).copyWith(
            color: AppLightTheme.textHeadline,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'create_account_subtitle'.tr,
          style: TextStyles.bodyLarge(
            isDark: false,
          ).copyWith(color: Colors.grey[400], fontWeight: FontWeight.w500),
        ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
        const SizedBox(height: 40),
      ],
    );
  }
}
