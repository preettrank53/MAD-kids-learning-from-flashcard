import 'package:firebase_auth/firebase_auth.dart';

/// Authentication Service - Backend Logic for Firebase Auth
/// 
/// This service handles all Firebase Authentication operations.
/// Lab 5 Step 3: Auth Service Implementation
/// 
/// Features:
/// - User Registration (Email/Password)
/// - User Login (Email/Password)
/// - User Logout
/// - Clean error handling with user-friendly messages
class AuthService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Register a new user with email and password
  /// 
  /// Returns:
  /// - null if registration is successful
  /// - Error message String if registration fails
  /// 
  /// Example:
  /// ```dart
  /// String? error = await AuthService().registerUser(
  ///   email: 'user@example.com',
  ///   password: 'password123',
  /// );
  /// if (error == null) {
  ///   // Registration successful
  /// } else {
  ///   // Show error message
  /// }
  /// ```
  Future<String?> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      // Attempt to create user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Registration successful
      return null;
      
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      switch (e.code) {
        case 'weak-password':
          return 'Password is too weak.';
        
        case 'email-already-in-use':
          return 'Account already exists.';
        
        case 'invalid-email':
          return 'Invalid email address.';
        
        case 'operation-not-allowed':
          return 'Email/Password accounts are not enabled.';
        
        default:
          return 'Registration failed: ${e.message}';
      }
    } catch (e) {
      // Handle any other errors
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Login an existing user with email and password
  /// 
  /// Returns:
  /// - null if login is successful
  /// - Error message String if login fails
  /// 
  /// Example:
  /// ```dart
  /// String? error = await AuthService().loginUser(
  ///   email: 'user@example.com',
  ///   password: 'password123',
  /// );
  /// if (error == null) {
  ///   // Login successful
  /// } else {
  ///   // Show error message
  /// }
  /// ```
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Attempt to sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Login successful
      return null;
      
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for this email.';
        
        case 'wrong-password':
          return 'Wrong password provided.';
        
        case 'invalid-email':
          return 'Invalid email address.';
        
        case 'user-disabled':
          return 'This account has been disabled.';
        
        case 'too-many-requests':
          return 'Too many login attempts. Please try again later.';
        
        case 'invalid-credential':
          return 'Invalid email or password.';
        
        default:
          return 'Login failed: ${e.message}';
      }
    } catch (e) {
      // Handle any other errors
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Logout the currently authenticated user
  /// 
  /// Example:
  /// ```dart
  /// await AuthService().logoutUser();
  /// // User is now logged out
  /// ```
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Silent fail - logout should always succeed
      // In production, you might want to log this error
      print('Logout error: $e');
    }
  }

  /// Get the current authenticated user
  /// 
  /// Returns:
  /// - User object if authenticated
  /// - null if not authenticated
  /// 
  /// Example:
  /// ```dart
  /// User? currentUser = AuthService().getCurrentUser();
  /// if (currentUser != null) {
  ///   print('User email: ${currentUser.email}');
  /// }
  /// ```
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Stream of authentication state changes
  /// 
  /// Useful for listening to login/logout events
  /// 
  /// Example:
  /// ```dart
  /// AuthService().authStateChanges.listen((User? user) {
  ///   if (user == null) {
  ///     // User is signed out
  ///   } else {
  ///     // User is signed in
  ///   }
  /// });
  /// ```
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
