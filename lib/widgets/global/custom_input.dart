import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomInput extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const CustomInput({
    super.key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.icon,
    this.onChanged,
    this.validator,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyles.bodyMedium(
            isDark: false,
          ).copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppLightTheme.surfaceGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppLightTheme.dividerColor),
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword && _obscureText,
            onChanged: widget.onChanged,
            validator: widget.validator,
            style: TextStyles.bodyLarge(
              isDark: false,
            ).copyWith(color: AppLightTheme.textHeadline),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyles.bodyLarge(
                isDark: false,
              ).copyWith(color: Colors.grey[400], fontWeight: FontWeight.w300),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              prefixIcon: widget.icon != null
                  ? Icon(widget.icon, color: Colors.grey[400], size: 20)
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
