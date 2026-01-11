import 'package:flutter/material.dart';
import 'core/theme/theme.dart';

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
      // HOME SCREEN
      // Starts with a placeholder screen to test theme implementation
      // ========================================================================
      home: const PlaceholderScreen(),
    );
  }
}

/// Placeholder Screen for Testing Theme Implementation
/// 
/// This screen demonstrates:
/// - Custom fonts loading correctly (Fredoka from Google Fonts)
/// - Color palette application (Pastel Orange, Mint Green, Soft Blue)
/// - AppBar styling (centered title, no elevation)
/// - Text field styling (rounded corners)
/// - Button styling
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ========================================================================
      // APP BAR - Testing centered title and custom styling
      // ========================================================================
      appBar: AppBar(
        title: const Text('Kids Learning Flashcards'),
        // The theme automatically applies:
        // - Center alignment
        // - Zero elevation (no shadow)
        // - Pastel Orange background
        // - Fredoka font
      ),
      
      // ========================================================================
      // BODY - Testing colors, fonts, and component styles
      // ========================================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==================================================================
            // WELCOME MESSAGE - Testing display text styles
            // ==================================================================
            Text(
              '🎨 Welcome!',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Theme Test Screen',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'If you can see the Fredoka font and colorful theme, everything is working correctly! 🎉',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // ==================================================================
            // COLOR PALETTE SHOWCASE
            // Testing if custom colors are applied correctly
            // ==================================================================
            Text(
              'Color Palette:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
            const SizedBox(height: 16),
            
            // Primary Color - Pastel Orange
            _ColorBox(
              color: Theme.of(context).colorScheme.primary,
              label: 'Primary (Pastel Orange)',
            ),
            
            const SizedBox(height: 12),
            
            // Secondary Color - Mint Green
            _ColorBox(
              color: Theme.of(context).colorScheme.secondary,
              label: 'Secondary (Mint Green)',
            ),
            
            const SizedBox(height: 12),
            
            // Accent Color - Soft Blue
            _ColorBox(
              color: Theme.of(context).colorScheme.tertiary,
              label: 'Accent (Soft Blue)',
            ),
            
            const SizedBox(height: 32),
            
            // ==================================================================
            // TEXT FIELD - Testing InputDecoration theme
            // Should have rounded corners and colorful focus state
            // ==================================================================
            Text(
              'Text Input Style:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                hintText: 'Tap here to test input field',
                prefixIcon: Icon(Icons.person),
              ),
              // Theme automatically applies:
              // - Rounded corners (12px border radius)
              // - Filled background
              // - Pastel Orange border when focused
            ),
            
            const SizedBox(height: 32),
            
            // ==================================================================
            // BUTTONS - Testing button themes
            // ==================================================================
            Text(
              'Button Styles:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
            const SizedBox(height: 16),
            
            // Elevated Button - Primary action button
            ElevatedButton.icon(
              onPressed: () {
                // Show a snackbar to test interaction
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Theme is working perfectly!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Test Elevated Button'),
              // Theme applies: rounded corners, Pastel Orange background
            ),
            
            const SizedBox(height: 12),
            
            // Text Button - Secondary action button
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info),
              label: const Text('Test Text Button'),
              // Theme applies: Pastel Orange text color
            ),
            
            const SizedBox(height: 32),
            
            // ==================================================================
            // CARD - Testing card theme
            // ==================================================================
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📝 Sample Flashcard',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This card uses the custom theme with rounded corners and subtle elevation. Perfect for displaying flashcards!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // ==================================================================
            // FOOTER MESSAGE
            // ==================================================================
            Text(
              '✨ All styles are loaded from theme.dart\n'
              '🎨 Colors: Playful & Bright palette\n'
              '✍️ Font: Fredoka (via Google Fonts)\n'
              '📱 Ready for flashcard features!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      
      // ========================================================================
      // FLOATING ACTION BUTTON - Testing FAB theme
      // ========================================================================
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🚀 Ready to start building flashcards!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.add),
        // Theme applies: Soft Blue background
      ),
    );
  }
}

/// Helper widget to display color boxes in the test screen
class _ColorBox extends StatelessWidget {
  final Color color;
  final String label;
  
  const _ColorBox({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
