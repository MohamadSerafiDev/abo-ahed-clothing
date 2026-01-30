import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  // --- Color Definitions (Private) ---
  static const Color _lightTextPrimary = Color(0xFF121212); // Almost Black
  static const Color _darkTextPrimary = Color(0xFFFFFFFF); // Pure White

  static const Color _lightTextSecondary = Color(0xFF757575); // Medium Grey
  static const Color _darkTextSecondary = Color(0xFFC0C0C0); // Metallic Silver

  static const Color _goldBrand = Color(0xFFD4AF37);
  static const Color _whiteConstant = Color(0xFFFFFFFF);

  /// Helper to check brightness and return the correct color
  static Color _resolveColor(bool isDark, Color lightColor, Color darkColor) {
    return isDark ? darkColor : lightColor;
  }

  // --- 1. Display Large (Hero headers, Onboarding) ---
  static TextStyle displayLarge({bool isDark = false}) =>
      GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w700, // Bold
        letterSpacing: -0.5,
        color: _resolveColor(isDark, _lightTextPrimary, _darkTextPrimary),
      );

  // --- 2. Headline Medium (Section titles like "Men", "Women") ---
  static TextStyle headlineMedium({bool isDark = false}) =>
      GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w600, // SemiBold
        letterSpacing: 0,
        color: _resolveColor(isDark, _lightTextPrimary, _darkTextPrimary),
      );

  // --- 3. Title Large (Product names in details) ---
  static TextStyle titleLarge({bool isDark = false}) => GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: 0.15,
    color: _resolveColor(isDark, _lightTextPrimary, _darkTextPrimary),
  );

  // --- 4. Body Large (General body text) ---
  static TextStyle bodyLarge({bool isDark = false}) => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.5,
    color: _resolveColor(isDark, _lightTextSecondary, _darkTextSecondary),
  );

  // --- 5. Body Medium (Small product cards) ---
  static TextStyle bodyMedium({bool isDark = false}) => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.25,
    color: _resolveColor(isDark, _lightTextSecondary, _darkTextSecondary),
  );

  // --- 6. Label Gold (NEW tags, category labels) ---
  // Note: Apply .toUpperCase() to your String when using this style
  static TextStyle labelGold = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 1.5,
    color: _goldBrand, // Always Gold
  );

  // --- 7. Button Text (Main Actions) ---
  // Note: Apply .toUpperCase() to your String when using this style
  static TextStyle buttonText = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: 1.25,
    color: _whiteConstant, // Always White (on gold buttons)
  );

  // --- 8. Price Text (Product prices) ---
  static TextStyle priceText({bool isDark = false}) => GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: 0,
    color: _resolveColor(
      isDark,
      _lightTextPrimary,
      _darkTextSecondary,
    ), // Changes to Silver in Dark mode
  );
}

// Extension to make it easier to use in widgets
extension TypographyUtils on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  TextStyle get displayLarge => TextStyles.displayLarge(isDark: isDarkMode);
  TextStyle get headlineMedium => TextStyles.headlineMedium(isDark: isDarkMode);
  TextStyle get titleLarge => TextStyles.titleLarge(isDark: isDarkMode);
  TextStyle get bodyLarge => TextStyles.bodyLarge(isDark: isDarkMode);
  TextStyle get bodyMedium => TextStyles.bodyMedium(isDark: isDarkMode);
  TextStyle get priceText => TextStyles.priceText(isDark: isDarkMode);

  // Constants that don't change
  TextStyle get labelGold => TextStyles.labelGold;
  TextStyle get buttonText => TextStyles.buttonText;
}
