import 'package:flutter/material.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';

/// Summary Row Widget - Reusable for displaying label-value pairs
class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const SummaryRow({
    Key? key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              (isBold
                      ? TextStyles.bodyMedium().copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      : TextStyles.bodyMedium())
                  .copyWith(color: AppLightTheme.textBody),
        ),
        Text(
          value,
          style:
              (isBold
                      ? TextStyles.bodyMedium().copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      : TextStyles.bodyMedium())
                  .copyWith(color: valueColor ?? AppLightTheme.textHeadline),
        ),
      ],
    );
  }
}
