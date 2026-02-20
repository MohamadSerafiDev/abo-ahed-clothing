import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:flutter/material.dart';

/// A generic chip selector that works for any list of string options.
///
/// Supports both single-select (default) and optional deselect via [allowDeselect].
/// Renders as a [Wrap] of [ChoiceChip]s styled with the app's gold theme.
class ChipSelector extends StatelessWidget {
  /// The list of raw option values.
  final List<String> options;

  /// The currently selected value (or `null` if none).
  final String? selected;

  /// Maps a raw option value to a user-facing label.
  /// Defaults to identity if not provided.
  final String Function(String option)? labelBuilder;

  /// Called when the user taps a chip.
  /// Passes back the option value, or `null` when deselected.
  final ValueChanged<String?> onSelected;

  /// When `true`, tapping the already-selected chip deselects it.
  final bool allowDeselect;

  const ChipSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.labelBuilder,
    this.allowDeselect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected == option;
        return ChoiceChip(
          label: Text(labelBuilder?.call(option) ?? option),
          selected: isSelected,
          selectedColor: AppLightTheme.goldPrimary,
          backgroundColor: AppLightTheme.surfaceGrey,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppLightTheme.textBody,
            fontWeight: FontWeight.w600,
          ),
          onSelected: (_) {
            if (allowDeselect && isSelected) {
              onSelected(null);
            } else {
              onSelected(option);
            }
          },
        );
      }).toList(),
    );
  }
}
