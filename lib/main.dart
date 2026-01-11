import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

/// Main entry point of the Kids Learning Flashcards App
/// 
/// This file initializes the Flutter application and applies the custom theme.
void main() {
  // Ensures Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Run the app
  runApp(const KidsLearningApp());
}

/// Root widget of the application
class KidsLearningApp extends StatelessWidget {
  const KidsLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ========================================================================
      // APP CONFIGURATION
      // ========================================================================
      title: 'Kids Learning Flashcards',
      
      // Remove debug banner in top-right corner
      debugShowCheckedModeBanner: false,
      
      // ========================================================================
      // THEME CONFIGURATION
      // Applies the custom theme we defined in theme.dart
      // ========================================================================
      theme: AppTheme.lightTheme,
      
      // ========================================================================
      // NAMED ROUTES - Cleaner navigation management
      // ========================================================================
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
