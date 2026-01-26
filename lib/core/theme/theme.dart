import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Playful Pastel Theme (Stitch Style)
class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFFFF9F1C); // Warm Orange
  static const Color secondaryColor = Color(0xFF2EC4B6); // Fresh Mint
  static const Color accentColor = Color(0xFFCBF3F0); // Soft Sky Blue
  static const Color surfaceColor = Color(0xFFFFFFFF); // Cream/White
  static const Color inputFillColor = Color(0xFFF0F4F8); // Light Blue-Grey for inputs
  static const Color darkText = Color(0xFF2D3436); // Dark Grey Text

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: surfaceColor,
      
      // Typography
      textTheme: GoogleFonts.fredokaTextTheme().apply(
        bodyColor: darkText,
        displayColor: darkText,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(color: darkText.withOpacity(0.6)),
        prefixIconColor: primaryColor,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.3);
          }
          return Colors.grey.shade200;
        }),
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withOpacity(0.2),
        thumbColor: primaryColor,
        overlayColor: primaryColor.withOpacity(0.1),
      ),
    );
  }
}
