import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Theme Configuration for Kids Learning Flashcards App
/// 
/// This file defines the visual appearance of the entire app with a 
/// playful, child-friendly design approach.
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ============================================================================
  // COLOR PALETTE - Playful & Bright for Kids
  // ============================================================================
  
  /// Primary color: Pastel Orange
  /// Chosen because: Orange evokes enthusiasm, creativity, and warmth - 
  /// perfect for encouraging learning. The pastel shade is soft on eyes.
  static const Color primaryColor = Color(0xFFFFB347); // Pastel Orange
  
  /// Secondary color: Mint Green
  /// Chosen because: Green represents growth and harmony, creating a 
  /// calming balance with the energetic orange. Mint is fresh and friendly.
  static const Color secondaryColor = Color(0xFF98D8C8); // Mint Green
  
  /// Accent color: Soft Blue
  /// Chosen because: Blue enhances focus and concentration - important for 
  /// learning activities. The soft tone maintains the playful mood.
  static const Color accentColor = Color(0xFF6FB3E0); // Soft Blue
  
  /// Background color: Warm off-white
  /// Chosen because: Pure white can be harsh; this warm tone is easier on 
  /// children's eyes during extended learning sessions.
  static const Color backgroundColor = Color(0xFFFFF8F0); // Warm Off-White
  
  /// Surface color for cards and containers
  /// Chosen because: Slightly brighter than background to create depth and 
  /// make interactive elements stand out.
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure White
  
  /// Success color: Bright Green
  /// Used for: Correct answers, achievements, positive feedback
  static const Color successColor = Color(0xFF7BC96F);
  
  /// Error color: Soft Red
  /// Used for: Wrong answers, form validation errors
  /// Note: Softer than standard red to avoid intimidating young learners
  static const Color errorColor = Color(0xFFFF6B6B);
  
  /// Text colors
  static const Color textPrimaryColor = Color(0xFF2C3E50); // Dark Blue-Grey
  static const Color textSecondaryColor = Color(0xFF7F8C8D); // Medium Grey

  // ============================================================================
  // TYPOGRAPHY - Rounded & Friendly Fonts
  // ============================================================================
  
  /// Returns the complete theme configuration for light mode
  static ThemeData get lightTheme {
    return ThemeData(
      // Use Material 3 design system for modern UI components
      useMaterial3: true,
      
      // ========================================================================
      // COLOR SCHEME
      // ========================================================================
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,        // Text on primary color
        onSecondary: Colors.white,      // Text on secondary color
        onSurface: textPrimaryColor,    // Text on surface color
        onBackground: textPrimaryColor, // Text on background color
      ),
      
      // ========================================================================
      // SCAFFOLD BACKGROUND
      // ========================================================================
      scaffoldBackgroundColor: backgroundColor,
      
      // ========================================================================
      // TYPOGRAPHY
      // Using 'Fredoka' - a rounded, playful font perfect for kids
      // ========================================================================
      textTheme: GoogleFonts.fredokaTextTheme(
        const TextTheme(
          // Large display text (e.g., welcome messages)
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
          
          // Medium display text (e.g., screen titles)
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
          
          // Small display text
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          
          // Headline text (e.g., card titles)
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          
          // Body text - main content
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimaryColor,
          ),
          
          // Body text - secondary content
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: textSecondaryColor,
          ),
          
          // Label text (e.g., button labels)
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      
      // ========================================================================
      // APP BAR THEME
      // Clean, modern design with centered title and no shadow
      // ========================================================================
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0, // No shadow - creates a flat, modern look
        centerTitle: true, // Centered titles look more balanced for kids
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 24,
        ),
      ),
      
      // ========================================================================
      // CARD THEME
      // Rounded cards with subtle elevation for flashcards
      // ========================================================================
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 4, // Subtle shadow creates depth
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // ========================================================================
      // INPUT DECORATION THEME
      // Rounded text fields with colorful focus states
      // ========================================================================
      inputDecorationTheme: InputDecorationTheme(
        // Filled background for better visibility
        filled: true,
        fillColor: surfaceColor,
        
        // Content padding for comfortable spacing
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        
        // Border when not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide(
            color: textSecondaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        
        // Border when focused (active input)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2, // Thicker border when focused
          ),
        ),
        
        // Border when there's an error
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: errorColor,
            width: 1.5,
          ),
        ),
        
        // Border when focused with an error
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: errorColor,
            width: 2,
          ),
        ),
        
        // Label style (floating label above input)
        labelStyle: GoogleFonts.fredoka(
          fontSize: 14,
          color: textSecondaryColor,
        ),
        
        // Hint text style
        hintStyle: GoogleFonts.fredoka(
          fontSize: 14,
          color: textSecondaryColor.withOpacity(0.6),
        ),
        
        // Error text style
        errorStyle: GoogleFonts.fredoka(
          fontSize: 12,
          color: errorColor,
        ),
      ),
      
      // ========================================================================
      // ELEVATED BUTTON THEME
      // Colorful, rounded buttons that are easy to tap
      // ========================================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.fredoka(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // ========================================================================
      // TEXT BUTTON THEME
      // Flat buttons for secondary actions
      // ========================================================================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: GoogleFonts.fredoka(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // ========================================================================
      // FLOATING ACTION BUTTON THEME
      // Bright, inviting button for primary actions
      // ========================================================================
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
  
  /// Returns a dark theme variant (optional - for future implementation)
  /// Currently returns light theme as kids apps typically use bright themes
  static ThemeData get darkTheme {
    // For now, return light theme
    // You can implement a dark theme later if needed
    return lightTheme;
  }
}
