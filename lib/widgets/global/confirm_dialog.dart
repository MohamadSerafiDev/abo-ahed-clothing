import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:flutter/material.dart';

/// A reusable confirmation dialog with customizable title, content, and actions.
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final IconData? icon;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'تأكيد',
    this.cancelText = 'إلغاء',
    this.confirmColor,
    this.icon,
  });

  /// Shows the dialog and returns `true` if confirmed, `false` or `null` if cancelled.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    Color? confirmColor,
    IconData? icon,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = confirmColor ?? Colors.redAccent;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppLightTheme.backgroundWhite,
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyles.titleLarge().copyWith(
                color: AppLightTheme.textHeadline,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        content,
        style: TextStyles.bodyMedium().copyWith(color: AppLightTheme.textBody),
      ),
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            cancelText,
            style: TextStyles.bodyMedium().copyWith(
              color: AppLightTheme.textBody,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmText,
            style: TextStyles.buttonText.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
