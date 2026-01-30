import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. Define the specific colors from your brand palette
class AppLightTheme {
  // Primary Brand Colors (Gold)
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldDark = Color(0xFFB8860B);

  // Backgrounds
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF8F8F8);

  // Typography Colors
  static const Color textHeadline = Color(0xFF121212); // Almost Black
  static const Color textBody = Color(0xFF757575); // Medium Grey
  static const Color silverAccent = Color(0xFF8E8E93); // For Metadata/Prices

  // UI Elements
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color usedTagSilver = Color(0xFFC0C0C0);
}

// 2. The Light Theme Definition
ThemeData get lightTheme {
  // Base text theme derived from Montserrat
  final baseTextTheme = GoogleFonts.montserratTextTheme();

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // --- Color Scheme ---
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppLightTheme.goldPrimary,
      onPrimary: Colors.white, // Text on Gold buttons
      secondary: AppLightTheme.silverAccent,
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: AppLightTheme.surfaceGrey,
      onSurface: AppLightTheme.textHeadline,
    ),

    // --- Backgrounds ---
    scaffoldBackgroundColor: AppLightTheme.backgroundWhite,

    // --- App Bar Theme ---
    appBarTheme: const AppBarTheme(
      backgroundColor: AppLightTheme.backgroundWhite,
      foregroundColor: AppLightTheme.textHeadline, // Icons/Text color
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppLightTheme.goldPrimary),
      shape: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
    ),

    // --- Card Theme (Product Cards) ---
    cardTheme: CardThemeData(
      color: AppLightTheme.surfaceGrey,
      elevation: 0,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppLightTheme.dividerColor),
      ),
    ),

    // --- Button Themes ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppLightTheme.goldPrimary,
        foregroundColor: Colors.white, // Text color
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),

    // --- Bottom Navigation Bar ---
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppLightTheme.backgroundWhite,
      selectedItemColor: AppLightTheme.goldPrimary,
      unselectedItemColor: AppLightTheme.textBody,
      showUnselectedLabels: true,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // --- Input Decoration (Login/Signup Fields) ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppLightTheme.surfaceGrey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppLightTheme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppLightTheme.goldPrimary),
      ),
      hintStyle: GoogleFonts.montserrat(color: AppLightTheme.textBody),
    ),

    // --- Typography Configuration ---
    textTheme: baseTextTheme.copyWith(
      // Headlines (Dark & Bold)
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        color: AppLightTheme.textHeadline,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        color: AppLightTheme.textHeadline,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        color: AppLightTheme.textHeadline,
        fontWeight: FontWeight.w600,
      ),

      // Body Text (Greyish)
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: AppLightTheme.textHeadline, // Main reading text
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: AppLightTheme.textBody, // Descriptions
      ),

      // Captions / Metadata (Silver)
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        color: AppLightTheme.silverAccent,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    ),

    // --- Divider Theme ---
    dividerTheme: const DividerThemeData(
      color: AppLightTheme.dividerColor,
      thickness: 1,
      space: 1,
    ),
  );
}
