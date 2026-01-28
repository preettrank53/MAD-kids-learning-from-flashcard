import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flashcard_model.dart'; 
import '../database/db_helper.dart'; 
import '../widgets/clay_card.dart'; // DepthCard
import '../core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/user_progress_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Consumer<UserProgressService>(
          builder: (context, userProgress, child) {
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.borderColor, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.skyBlue,
                    child: Icon(Icons.face_rounded, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi, Leo!', style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                    Text('Level ${userProgress.totalCoins ~/ 100 + 1} Explorer', style: GoogleFonts.fredoka(fontSize: 12, color: AppTheme.lightText)),
                  ],
                ),
              ],
            );
          }
        ),
        actions: [
          Consumer<UserProgressService>(
            builder: (context, userProgress, child) {
              return Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.sunnyYellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.sunnyYellow, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppTheme.sunnyYellow, size: 20),
                    const SizedBox(width: 4),
                    Text('${userProgress.totalCoins}', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
              );
            }
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: AppTheme.borderColor, height: 2),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Daily Mission (Compact & Colorful)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Consumer<UserProgressService>(
                builder: (context, userProgress, child) {
                  return Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1CB0F6), Color(0xFF82D6FF)], // Blue -> Light Blue
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1CB0F6).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background Deco
                        Positioned(
                          right: -30,
                          bottom: -30,
                          child: Icon(Icons.rocket_launch_rounded, size: 140, color: Colors.white.withOpacity(0.2)),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('DAILY MISSION', style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.local_fire_department_rounded, color: AppTheme.sunnyYellow, size: 24),
                                  const SizedBox(width: 4),
                                  Text('${userProgress.currentStreak} Day Streak!', style: GoogleFonts.fredoka(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                          const Spacer(),
                          Text('Space Explorer', style: GoogleFonts.fredoka(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('Learn 5 new planets!', style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                          const SizedBox(height: 12),
                          // Play Button
                          SizedBox(
                            height: 36,
                            child: ElevatedButton.icon(
                              onPressed: () => context.push('/quiz'),
                              icon: const Icon(Icons.play_arrow_rounded, color: AppTheme.skyBlue, size: 20),
                              label: Text('PLAY NOW', style: GoogleFonts.fredoka(color: AppTheme.skyBlue, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),

          // 2. Collections Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text('Your Collections', style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
            ),
          ),

          // 3. Grid
          SliverPadding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             sliver: isLoading 
              ? const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()))
              : categories.isEmpty
                  ? SliverToBoxAdapter(child: _buildEmptyState())
                  : SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85, // Taller cards to fit big icons
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          String category = categories.keys.elementAt(index);
                          List<Flashcard> cards = categories[category]!;
                          return _buildCategoryTile(category, cards, index);
                        },
                        childCount: categories.length,
                      ),
                    ),
          ),

           // Bottom Padding for scrolling
           const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.category_outlined, size: 60, color: AppTheme.lightText.withOpacity(0.3)),
          const SizedBox(height: 10),
          Text("No decks yet!", style: GoogleFonts.fredoka(color: AppTheme.lightText, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(String category, List<Flashcard> cards, int index) {
    // Pastel Palette
    List<Color> pastelColors = [
      const Color(0xFFDFF9DB), // Light Green
      const Color(0xFFFFF4CC), // Light Yellow
      const Color(0xFFFFD6D6), // Light Red/Pink
      const Color(0xFFD9F2FF), // Light Blue
    ];
    
    // Icon Colors (Darker versions)
    List<Color> iconColors = [
      AppTheme.grassGreen,
      const Color(0xFFFFB000),
      AppTheme.softRed,
      AppTheme.skyBlue,
    ];

    Color cardColor = pastelColors[index % pastelColors.length];
    Color iconColor = iconColors[index % iconColors.length];
    IconData icon = _getCategoryIcon(category);

    return ClayCard(
      color: cardColor,
      depth: 6, // Good depth for 3D feel
      borderRadius: 20,
      onTap: () {
        context.push('/study', extra: {'category': category, 'flashcards': cards});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // White Circle Background for Icon
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ]
            ),
            child: Icon(icon, color: iconColor, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            category,
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppTheme.darkText,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${cards.length} Cards',
            style: GoogleFonts.fredoka(
              color: AppTheme.lightText.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'animals': return Icons.pets_rounded;
      case 'space': return Icons.rocket_launch_rounded;
      case 'fruits': return Icons.apple_rounded; // or nutrition
      case 'numbers': return Icons.looks_one_rounded; // or calculate
      default: return Icons.star_rounded;
    }
  }
}
