import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flashcard_model.dart'; 
import '../database/db_helper.dart'; 
import '../widgets/clay_card.dart';
import '../core/theme/theme.dart';
import 'study_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Accessing the singleton instance of the database helper
  final DatabaseHelper _dbHelper = DatabaseHelper.instance; 
  Map<String, List<Flashcard>> categories = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshFlashcards();
  }

  Future<void> _refreshFlashcards() async {
    setState(() => isLoading = true);
    try {
      final data = await _dbHelper.getFlashcards();
      Map<String, List<Flashcard>> grouped = {};
      for (var f in data) {
        if (!grouped.containsKey(f.category)) {
          grouped[f.category] = [];
        }
        grouped[f.category]!.add(f);
      }
      setState(() {
        categories = grouped;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading flashcards: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        bottom: false, // Let content flow behind floating nav
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. GREETING CARD
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Leo!',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          'Ready to learn?',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightText,
                          ),
                        ),
                      ],
                    ),
                    const ClayCard(
                      height: 50,
                      width: 50,
                      borderRadius: 25,
                      color: AppTheme.backgroundColor,
                      child: Icon(Icons.face_rounded, color: AppTheme.primaryAccent),
                    )
                  ],
                ),
              ),

              // 2. BENTO GRID - Daily Goals & Progress
              SizedBox(
                height: 240,
                child: Row(
                  children: [
                    // Large "Daily Mission" Tile (Left)
                    Expanded(
                      flex: 4,
                      child: ClayCard(
                        height: double.infinity,
                        color: AppTheme.primaryAccent,
                        borderRadius: 30,
                        child: Stack(
                          children: [
                            Positioned(
                              right: -10,
                              bottom: -10,
                              child: Icon(
                                Icons.rocket_launch_rounded, 
                                size: 100, 
                                color: Colors.white.withOpacity(0.2)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Text('DAILY MISSION', 
                                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                                    ),
                                  ),
                                  
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Space', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                      Text('Explorer', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  
                                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Two Smaller Tiles (Right)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          // Top Right: Progress
                          Expanded(
                            child: ClayCard(
                              width: double.infinity,
                              color: AppTheme.successColor,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 32),
                                    const SizedBox(height: 5),
                                    Text('12/20', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Bottom Right: Streak
                          Expanded(
                            child: ClayCard(
                              width: double.infinity,
                              color: AppTheme.secondaryAccent,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 32),
                                    const SizedBox(height: 5),
                                    Text('3 Day', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3. CATEGORIES Header
              Text(
                'Collections', 
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 20),

              // 4. CATEGORIES Dynamic Grid
              isLoading 
              ? const Center(child: CircularProgressIndicator()) 
              : categories.isEmpty 
                  ? _buildEmptyState()
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        String category = categories.keys.elementAt(index);
                        List<Flashcard> cards = categories[category]!;
                        return _buildCategoryTile(category, cards, index);
                      },
                    ),

              // Extra space for floating nav
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return ClayCard(
      height: 200,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_rounded, size: 50, color: AppTheme.lightText.withOpacity(0.5)),
            const SizedBox(height: 10),
            Text("No flashcards found", style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(String category, List<Flashcard> cards, int index) {
    List<Color> icons = [AppTheme.warningColor, AppTheme.primaryAccent, AppTheme.secondaryAccent, AppTheme.successColor];
    Color iconColor = icons[index % icons.length];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudyScreen(category: category, flashcards: cards),
          ),
        );
      },
      child: ClayCard(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.star_rounded, color: iconColor, size: 30),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppTheme.darkText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${cards.length} Cards',
                    style: GoogleFonts.poppins(
                      color: AppTheme.lightText,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
