import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/login_screen.dart';
import '../../screens/signup_screen.dart';
import '../../layout/main_shell.dart';
import '../../screens/study_screen.dart';
import '../../screens/quiz_screen.dart';
import '../../models/flashcard_model.dart';

class AppRouter {
  // We use a refresh listener to redirect automatically when auth state changes
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: _GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final path = state.uri.path;
      
      // If not logged in and not on a public page, go to login
      if (!isLoggedIn && path != '/login' && path != '/signup') {
         return '/login';
      }
      
      // If logged in and trying to go to login, go to home
      if (isLoggedIn && (path == '/login' || path == '/signup')) {
        return '/';
      }

      return null;
    },
    
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) => const QuizScreen(),
      ),
      // Dynamic Route for Study Mode
      GoRoute(
        path: '/study',
        builder: (context, state) {
          if (state.extra is Map<String, dynamic>) {
            final extras = state.extra as Map<String, dynamic>;
            return StudyScreen(
              category: extras['category'],
              flashcards: extras['flashcards'],
            );
          }
           return const Scaffold(body: Center(child: Text('Error: Missing Study Data')));
        },
      ),
    ],
  );
}

// Helper for converting Stream to Listenable for GoRouter refresh
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
