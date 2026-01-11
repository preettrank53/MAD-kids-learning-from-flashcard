/// App-wide constants for Kids Learning Flashcards
/// 
/// This file contains configuration values that are used throughout the app.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();
  
  /// App Information
  static const String appName = 'Kids Learning Flashcards';
  static const String appVersion = '1.0.0';
  
  /// Spacing Constants
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  
  /// Border Radius Constants
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  
  /// Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
}
