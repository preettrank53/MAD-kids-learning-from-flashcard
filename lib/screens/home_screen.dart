import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../database/db_helper.dart';
import '../models/flashcard_model.dart';
import '../core/theme/theme.dart';
import '../services/prefs_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Map<String, List<Flashcard>> _categories = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    final cards = await _dbHelper.getFlashcards();
    Map<String, List<Flashcard>> grouped = {};
    for (var c in cards) {
      if (!grouped.containsKey(c.category)) grouped[c.category] = [];
      grouped[c.category]!.add(c);
    }
    
    if (mounted) {
      setState(() {
        _categories = grouped;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadStarterAndReload() async {
    // Manually insert starter data using public insert API since we can't touch db_helper code
    // Standard data: Animals, Fruits
    final List<Map<String, dynamic>> starters = [
      {'title': 'Lion', 'category': 'Animals', 'colorValue': 0xFFFF4B4B},
      {'title': 'Elephant', 'category': 'Animals', 'colorValue': 0xFFFF4B4B},
      {'title': 'Apple', 'category': 'Fruits', 'colorValue': 0xFFFF9F43},
      {'title': 'Banana', 'category': 'Fruits', 'colorValue': 0xFFFF9F43},
    ];

    for (var s in starters) {
      // Create model to insert
      final f = Flashcard(
        title: s['title'],
        category: s['category'],
        colorValue: s['colorValue'],
      );
      await _dbHelper.insertFlashcard(f);
    }
    _loadDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Consumer<PrefsService>(
            builder: (context, prefs, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)], // Blue to Light Blue
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              "Hi, ${prefs.childName}!",
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Ready to play?",
                              style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
                            ),
                          ],
                        ),
                        // Stats Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.yellow, size: 24),
                                  Text("${prefs.stars}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Column(
                                children: [
                                  const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 24),
                                  Text("${prefs.streak}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => context.push('/quiz'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD54F), // Yellow
                          foregroundColor: Colors.black87,
                          shape: const StadiumBorder(),
                          elevation: 4,
                        ),
                        child: const Text("Start Quiz", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Grid Content
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _categories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           const Text("No decks found.", style: TextStyle(fontSize: 18, color: Colors.grey)),
                           const SizedBox(height: 16),
                           ElevatedButton(
                             onPressed: _loadStarterAndReload,
                             child: const Text("Tap to Load Starter Packs"),
                           )
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        itemCount: _categories.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (context, index) {
                          String category = _categories.keys.elementAt(index);
                          List<Flashcard> cards = _categories[category]!;
                          return Card(
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: InkWell(
                              onTap: () => context.push('/study', extra: {'category': category, 'flashcards': cards}),
                              borderRadius: BorderRadius.circular(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(category).withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(category),
                                      color: _getCategoryColor(category),
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    category,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  Text(
                                    "${cards.length} Cards",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'animals': return Icons.pets;
      case 'space': return Icons.rocket_launch;
      case 'fruits': return Icons.apple;
      default: return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'animals': return Colors.red;
      case 'space': return Colors.indigo;
      case 'fruits': return Colors.orange;
      case 'numbers': return Colors.green;
      default: return Colors.blue;
    }
  }
}
