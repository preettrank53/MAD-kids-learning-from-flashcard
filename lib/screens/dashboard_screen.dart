import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../database/db_helper.dart';
import '../models/flashcard_model.dart';
import 'add_edit_screen.dart';

/// Dashboard Screen - Main Hub for Kids Learning
/// 
/// This screen serves as the central navigation hub where kids can
/// choose different learning categories (flashcards).
/// Lab 5 Phase 5: Includes logout functionality
/// Lab 6 Phase 3: Display real flashcards from SQLite database
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// Fetch flashcards from database
  Future<List<Flashcard>> _loadFlashcards() async {
    return await DatabaseHelper.instance.getFlashcards();
  }
  
  /// Refresh the flashcard list
  void _refreshFlashcards() {
    setState(() {
      // Calling setState triggers rebuild and re-executes FutureBuilder
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ====================================================================
      // APP BAR - No back button, logout icon on right
      // ====================================================================
      appBar: AppBar(
        title: const Text('Learning Buddy'),
        automaticallyImplyLeading: false, // Remove back arrow
        actions: [
          // Logout button - Automatically handled by StreamBuilder in main.dart
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              // Call logout service - StreamBuilder will auto-navigate to login
              await AuthService().logoutUser();
            },
          ),
          const SizedBox(width: 8),
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
          // GRID VIEW - Learning Categories (RESPONSIVE + DATABASE)
          // Uses FutureBuilder to fetch real flashcards from SQLite
          // ================================================================
          Expanded(
            child: FutureBuilder<List<Flashcard>>(
              future: _loadFlashcards(),
              builder: (context, snapshot) {
                // ============================================================
                // LOADING STATE
                // ============================================================
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
                
                // ============================================================
                // ERROR STATE
                // ============================================================
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading flashcards',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                // ============================================================
                // EMPTY STATE
                // ============================================================
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.library_books_outlined,
                          size: 100,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No flashcards yet!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to create your first flashcard',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                // ============================================================
                // DATA STATE - Display flashcards in responsive grid
                // ============================================================
                List<Flashcard> flashcards = snapshot.data!;
                
                return LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive logic: 3 columns for wide screens, 2 for narrow
                    int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                    
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      padding: const EdgeInsets.all(20.0),
                      itemCount: flashcards.length,
                      itemBuilder: (context, index) {
                        final flashcard = flashcards[index];
                        return _buildFlashcardCard(context, flashcard);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      
      // ====================================================================
      // FLOATING ACTION BUTTON - Navigate to Add Flashcard screen
      // ====================================================================
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add/Edit screen and refresh on return
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditScreen(),
            ),
          ).then((value) {
            // If returned true (flashcard was saved), refresh the list
            if (value == true) {
              _refreshFlashcards();
            }
          });
        },
        tooltip: 'Add Flashcard',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Helper widget to build individual flashcard cards
  /// 
  /// Creates a colorful, elevated card displaying flashcard data from database.
  /// Designed to be attractive and easy to tap for kids.
  Widget _buildFlashcardCard(BuildContext context, Flashcard flashcard) {
    return Card(
      elevation: 8, // High elevation for prominent shadow
      shadowColor: Color(flashcard.colorValue).withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: InkWell(
        onTap: () {
          // Navigate to edit screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditScreen(flashcard: flashcard),
            ),
          ).then((value) {
            // If returned true (flashcard was updated), refresh the list
            if (value == true) {
              _refreshFlashcards();
            }
          });
        },
        onLongPress: () {
          // Show delete confirmation dialog
          _showDeleteDialog(context, flashcard);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(flashcard.colorValue),
                Color(flashcard.colorValue).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flashcard Title
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  flashcard.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  flashcard.category,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Show delete confirmation dialog
  void _showDeleteDialog(BuildContext context, Flashcard flashcard) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Flashcard?'),
          content: Text('Are you sure you want to delete "${flashcard.title}"?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Delete from database
                await DatabaseHelper.instance.deleteFlashcard(flashcard.id!);
                
                if (!mounted) return;
                
                // Close dialog
                Navigator.pop(context);
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🗑️ Flashcard deleted'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
                
                // Refresh list
                _refreshFlashcards();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
