import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../database/db_helper.dart';
// import '../database/mock_db_helper.dart'; // Web testing
import '../models/flashcard_model.dart';
import 'add_edit_screen.dart';
import 'study_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Load categories and their flashcards
  Future<Map<String, List<Flashcard>>> _loadData() async {
    // Switch to MockDatabaseHelper for Web
    final allCards = await DatabaseHelper.instance.getFlashcards();
    // final allCards = await MockDatabaseHelper.instance.getFlashcards();
    
    // Group by category
    Map<String, List<Flashcard>> grouped = {};
    for (var card in allCards) {
      if (!grouped.containsKey(card.category)) {
        grouped[card.category] = [];
      }
      grouped[card.category]!.add(card);
    }
    return grouped;
  }

  void _refreshFlashcards() {
    setState(() {});
  }
  
  // Design colors for specific categories
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'animals': return const Color(0xFFE67E22); // Orange
      case 'numbers': return const Color(0xFF2ECC71); // Green
      case 'fruits': return const Color(0xFF3498DB); // Blue
      case 'shapes': return const Color(0xFF9B59B6); // Purple
      default: return const Color(0xFFFF7675); // Light Red default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Light background
      body: SafeArea(
        child: FutureBuilder<Map<String, List<Flashcard>>>(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final categories = snapshot.data ?? {};
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // ========================================================
                  // HEADER: Greeting + Stars
                  // ========================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Leo! 👋',
                            style: GoogleFonts.fredoka(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3436),
                            ),
                          ),
                          Text(
                            'Ready to play?',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: const Color(0xFF636E72),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.orange, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              '120',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // ========================================================
                  // SECTION TITLE
                  // ========================================================
                  Text(
                    'YOUR MISSIONS',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFB2BEC3),
                      letterSpacing: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // ========================================================
                  // CATEGORY LIST
                  // ========================================================
                  Expanded(
                    child: categories.isEmpty 
                      ? _buildEmptyState() 
                      : ListView.separated(
                          itemCount: categories.length,
                          separatorBuilder: (c, i) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            String category = categories.keys.elementAt(index);
                            List<Flashcard> cards = categories[category]!;
                            return _buildMissionCard(category, cards);
                          },
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      
      // ====================================================================
      // BOTTOM NAVIGATION (Visual Only)
      // ====================================================================
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(24),
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF2D3436), // Dark background
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home_rounded, true),
            _buildNavItem(Icons.menu_book_rounded, false),
            // Floating Action Button integrated in Nav
             GestureDetector(
               onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const AddEditScreen()),
                ).then((val) {
                  if (val == true) _refreshFlashcards();
                });
               },
               child: Container(
                 width: 50, 
                 height: 50,
                 decoration: const BoxDecoration(
                   color: Colors.orange,
                   shape: BoxShape.circle,
                 ),
                 child: const Icon(Icons.add, color: Colors.white),
               ),
             ),
            _buildNavItem(Icons.face_rounded, false),
            _buildNavItem(Icons.settings_rounded, false),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rocket_launch_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "No missions yet!",
            style: GoogleFonts.fredoka(fontSize: 24, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 8),
          Text(
             "Add some flashcards to start.",
             style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(String category, List<Flashcard> cards) {
    Color themeColor = _getCategoryColor(category);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudyScreen(category: category, flashcards: cards),
          ),
        );
      },
      child: Container(
        height: 140, // Fixed height for consistency
        decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1), // Very light tinted background
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Stack(
          children: [
            // Background decor
            Positioned(
              right: -20,
              bottom: -20,
              child: Opacity(
                opacity: 0.1,
                child: Icon(Icons.category, size: 150, color: themeColor),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Icon Box
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.star_rounded, // Generic icon for now
                      size: 40,
                      color: themeColor,
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category,
                          style: GoogleFonts.fredoka(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cards.length} cards', // Dynamic count
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: const Color(0xFF636E72),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Fake Progress Bar
                        Container(
                          height: 8,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.6, // Fake progress
                            child: Container(
                              decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Play Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.play_arrow_rounded, color: themeColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: isActive ? const BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ) : null,
      child: Icon(
        icon, 
        color: isActive ? Colors.white : Colors.grey.shade600,
        size: 28,
      ),
    );
  }
}
