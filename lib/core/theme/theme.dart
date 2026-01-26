import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Clay/Neumorphic Theme (2026 Aesthetic)
class AppTheme {
  // ============================================
  // VITAMIN PALETTE
  // ============================================
  static const Color backgroundColor = Color(0xFFF0F2F5); // Cloud Grey (Matte)
  static const Color primaryAccent = Color(0xFF5D5FEF); // Electric Indigo
  static const Color secondaryAccent = Color(0xFFFF6B6B); // Coral Pink
  static const Color successColor = Color(0xFF4ECDC4); // Soft Mint
  static const Color warningColor = Color(0xFFFFD166); // Sunshine Yellow
  static const Color darkText = Color(0xFF2D3436); // Anthracite
  static const Color lightText = Color(0xFFA6ABBD); // Stone Grey

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryAccent,
        primary: primaryAccent,
        secondary: secondaryAccent,
        surface: backgroundColor, // Matte surface
        background: backgroundColor,
      ),

      // Typography (Poppins - Clean & Geometric)
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w800, // ExtraBold
          color: darkText,
          fontSize: 32,
        ),
        displayMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          color: darkText,
          fontSize: 28,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: darkText,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          color: lightText,
          fontSize: 14,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: primaryAccent,
        size: 28,
      ),
    );
  }
}
