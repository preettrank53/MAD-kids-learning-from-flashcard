import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Clean Flat Theme (Professional/Kid-Friendly)
class AppTheme {
  // ============================================
  // CRAYON PALETTE (Flat, Bright, Solid)
  // ============================================
  static const Color backgroundColor = Color(0xFFFAFAFA); // Standard clean white/grey
  static const Color white = Colors.white;

  // Primary: Sky Blue (Duolingo-ish)
  static const Color primaryAccent = Color(0xFF58CC02); // We'll map Green as Primary action or keep Blue?
  // Let's stick to the prompt: Sky Blue, Grass Green, Sunny Yellow, Soft Red.
  
  static const Color skyBlue = Color(0xFF1CB0F6);
  static const Color grassGreen = Color(0xFF58CC02);
  static const Color sunnyYellow = Color(0xFFFFC800);
  static const Color softRed = Color(0xFFFF4B4B);

  // Mapped Semantic Colors
  static const Color primaryColor = skyBlue; // Main Brand Color
  static const Color secondaryColor = sunnyYellow;
  static const Color successColor = grassGreen;
  static const Color errorColor = softRed;
  
  // Neutral Colors (Text/Borders)
  static const Color darkText = Color(0xFF3C3C3C); // Soft Black
  static const Color lightText = Color(0xFF777777); // Grey
  static const Color borderColor = Color(0xFFE5E5E5); // Light Border

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: white,
        background: backgroundColor,
      ),

      // Typography (Fredoka - Rounded & Playful like Khan Kids)
      textTheme: GoogleFonts.fredokaTextTheme().copyWith(
        displayLarge: GoogleFonts.fredoka(
          fontWeight: FontWeight.w700, 
          color: darkText,
          fontSize: 32,
        ),
        displayMedium: GoogleFonts.fredoka(
          fontWeight: FontWeight.w600,
          color: darkText,
          fontSize: 24,
        ),
        bodyLarge: GoogleFonts.fredoka(
          fontWeight: FontWeight.w500,
          color: darkText,
          fontSize: 18,
        ),
        bodyMedium: GoogleFonts.fredoka(
          fontWeight: FontWeight.w400,
          color: lightText,
          fontSize: 16,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: darkText,
        size: 26,
      ),

      // Card Theme (Flat with Border)
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor, width: 2),
        ),
      ),
      
      // Standard Input Decoration used in Settings
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(color: lightText),
      ),
    );
  }
}
