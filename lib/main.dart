import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/theme.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';

/// Main entry point of the Kids Learning Flashcards App
/// 
/// This file initializes Firebase and the Flutter application.
/// Lab 5: Firebase Authentication Integration
void main() async {
  // Ensures Flutter bindings are initialized before Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with platform-specific options (Lab 5: Firebase Integration)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
