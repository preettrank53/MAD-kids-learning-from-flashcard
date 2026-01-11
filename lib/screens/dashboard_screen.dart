import 'package:flutter/material.dart';

/// Dashboard Screen - Main Hub for Kids Learning
/// 
/// This screen serves as the central navigation hub where kids can
/// choose different learning categories (flashcards).
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Mock data for learning categories
  final List<Map<String, dynamic>> _categories = const [
    {
      'name': 'Animals',
      'icon': Icons.pets,
      'color': Color(0xFFFF6B6B), // Soft Red
    },
    {
      'name': 'Numbers',
      'icon': Icons.numbers,
      'color': Color(0xFF6FB3E0), // Soft Blue
    },
    {
      'name': 'Shapes',
      'icon': Icons.category,
      'color': Color(0xFF98D8C8), // Mint Green
    },
    {
      'name': 'Fruits',
      'icon': Icons.apple,
      'color': Color(0xFFFFB347), // Pastel Orange
    },
    {
      'name': 'Colors',
      'icon': Icons.palette,
      'color': Color(0xFFB19CD9), // Soft Purple
    },
    {
      'name': 'Alphabet',
      'icon': Icons.abc,
      'color': Color(0xFFFFD93D), // Bright Yellow
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ====================================================================
      // APP BAR - No back button, profile icon on right
      // ====================================================================
      appBar: AppBar(
        title: const Text('Learning Buddy'),
        automaticallyImplyLeading: false, // Remove back arrow
        actions: [
          // Profile icon on the right
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      
      // ====================================================================
      // BODY - Welcome header + Grid of categories
      // ====================================================================
      body: Column(
        children: [
          // ================================================================
          // WELCOME HEADER - Rounded bottom corners
          // ================================================================
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Little Learner! 👋',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'What do you want to learn today?',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ),
          
          // ================================================================
          // GRID VIEW - Learning Categories
          // ================================================================
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              padding: const EdgeInsets.all(20.0),
              children: _categories
                  .map((category) => _buildCategoryCard(
                        context,
                        name: category['name'],
                        icon: category['icon'],
                        color: category['color'],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget to build individual category cards
  /// 
  /// Creates a colorful, elevated card with an icon and category name.
  /// Designed to be attractive and easy to tap for kids.
  Widget _buildCategoryCard(
    BuildContext context, {
    required String name,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 8, // High elevation for prominent shadow
      shadowColor: color.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to flashcard screen for this category
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $name flashcards...'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Category Icon
              Icon(
                icon,
                size: 60,
                color: Colors.white,
              ),
              
              const SizedBox(height: 12),
              
              // Category Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
