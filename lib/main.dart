import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'core/theme/theme.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
// import 'screens/dashboard_screen.dart'; // No longer the direct home
import 'screens/main_shell.dart'; // New Main Shell with Navigation

/// Main entry point of the Kids Learning Flashcards App
/// 
/// This file initializes Firebase and the Flutter application.
/// Lab 5: Firebase Authentication Integration with Session Management
/// Lab 6: SQLite Database for Flashcard Storage
void main() async {
  // Ensures Flutter bindings are initialized before Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with platform-specific options (Lab 5: Firebase Integration)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Note: SQLite CRUD operations work on Android/iOS only, not on Web
  // Database operations will be tested through the UI in Phase 3
  
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
      // SESSION MANAGEMENT - Auth State Listener
      // Automatically keeps user logged in across app restarts
      // ========================================================================
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading spinner while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
              body: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            );
          }
          
          // User is logged in - Show Main Shell (with Bottom Navigation)
          if (snapshot.hasData) {
            return const MainShell();
          }
          
          // User is logged out - Show Login Screen
          return const LoginScreen();
        },
      ),
      
      // ========================================================================
      // NAMED ROUTES - For navigation within the app
      // ========================================================================
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const MainShell(),
      },
    );
  }
}
