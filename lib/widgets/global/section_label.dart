import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:flutter/material.dart';

/// A reusable section label used above form fields and selectors.
class SectionLabel extends StatelessWidget {
  final String label;

  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.bodyMedium(
        isDark: false,
      ).copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
    );
  }
}
