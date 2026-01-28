import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../models/flashcard_model.dart';
import '../database/db_helper.dart';
import '../core/theme/theme.dart';
import '../widgets/clay_card.dart'; // Using FlatCard/DepthCard logic
import '../services/prefs_service.dart';
import '../services/tts_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late ConfettiController _confettiController;
  
  // Game State
  List<Flashcard> allCards = [];
  List<Flashcard> options = [];
  Flashcard? targetCard;
  
  int questionCount = 0; // Current question number
  final int totalQuestions = 10;
  int stars = 0; // Score

  bool isLoading = true;
  bool isAnswered = false; // Block multiple taps
  int correctIndex = -1;
  int wrongIndex = -1;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _loadCards();
    // Initialize TTS
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TtsService>(context, listen: false).init();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    final cards = await DatabaseHelper.instance.getFlashcards();
    if (mounted) {
      setState(() {
        allCards = cards;
        isLoading = false;
      });
      _generateQuestion(); // Start game
    }
  }

  void _generateQuestion() {
    if (questionCount >= totalQuestions) {
      _finishGame();
      return;
    }

    if (allCards.length < 4) return; 

    final random = Random();
    
    // 1. Pick Target
    targetCard = allCards[random.nextInt(allCards.length)];
    
    // 2. Pick 3 Distractors
    List<Flashcard> distractors = [];
    while (distractors.length < 3) {
      Flashcard c = allCards[random.nextInt(allCards.length)];
      if (c.id != targetCard!.id && !distractors.contains(c)) {
        distractors.add(c);
      }
    }

    // 3. Shuffle
    options = [targetCard!, ...distractors];
    options.shuffle();

    // Reset UI State
    setState(() {
      isAnswered = false;
      correctIndex = -1;
      wrongIndex = -1;
      questionCount++;
    });

    _speakQuestion();
  }

  void _speakQuestion() async {
    if (targetCard == null || !mounted) return;
    final tts = Provider.of<TtsService>(context, listen: false);
    await tts.stop(); // Stop previous speech
    await tts.speak("Where is the ${targetCard!.title}?");
  }

  void _handleTap(int index) {
    if (isAnswered) return;

    if (options[index].id == targetCard!.id) {
      // CORRECT
      setState(() {
        isAnswered = true;
        correctIndex = index;
        stars++;
      });
      _confettiController.play();
      
      // Award Logic
      Provider.of<PrefsService>(context, listen: false).addStars(10);
      Provider.of<PrefsService>(context, listen: false).updateStreak();

      // Next Question
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _generateQuestion();
      });

    } else {
      // WRONG (Errorless)
      setState(() {
        wrongIndex = index;
      });
      
      // Clear red after short delay to allow retry
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            wrongIndex = -1; 
          });
        }
      });
    }
  }

  void _finishGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events_rounded, color: AppTheme.sunnyYellow, size: 80),
            const SizedBox(height: 16),
            Text("You Won!", style: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
            const SizedBox(height: 8),
            Text("You got $stars / $totalQuestions stars!", style: GoogleFonts.fredoka(fontSize: 18, color: AppTheme.lightText)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.pop(); // Close Dialog
                    context.pop(); // Go Home
                  }, 
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.skyBlue),
                  child: const Text("Home", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.pop(); // Close Dialog
                    setState(() {
                      questionCount = 0;
                      stars = 0;
                    });
                    _generateQuestion(); // Restart
                  }, 
                   style: ElevatedButton.styleFrom(backgroundColor: AppTheme.grassGreen),
                  child: const Text("Play Again", style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: AppTheme.sunnyYellow),
            const SizedBox(width: 8),
            Text("$stars / $totalQuestions", style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, color: AppTheme.darkText)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppTheme.lightText),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (allCards.length < 4)
             Center(child: Text("Not enough cards!", style: GoogleFonts.fredoka(fontSize: 20)))
          else
            Column(
              children: [
                // Question Area
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.skyBlue.withOpacity(0.1),
                    border: const Border(bottom: BorderSide(color: AppTheme.borderColor, width: 2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text("Where is the...", style: GoogleFonts.fredoka(fontSize: 20, color: AppTheme.lightText)),
                                Text(targetCard!.title, style: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, size: 40, color: AppTheme.skyBlue),
                            onPressed: _speakQuestion,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      itemCount: options.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16, 
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                         Flashcard card = options[index];
                         
                         Color borderColor = AppTheme.borderColor;
                         Color bgColor = Colors.white;

                         if (index == correctIndex) {
                           borderColor = AppTheme.grassGreen;
                           bgColor = AppTheme.grassGreen.withOpacity(0.1);
                         } else if (index == wrongIndex) {
                           borderColor = AppTheme.softRed;
                           bgColor = AppTheme.softRed.withOpacity(0.1);
                         }

                         return GestureDetector(
                           onTap: () => _handleTap(index),
                           child: AnimatedContainer(
                             duration: const Duration(milliseconds: 200),
                             decoration: BoxDecoration(
                               color: bgColor,
                               borderRadius: BorderRadius.circular(20),
                               border: Border.all(color: borderColor, width: 3),
                               boxShadow: [
                                 BoxShadow(color: borderColor.withOpacity(0.2), offset: const Offset(0, 4), blurRadius: 0),
                               ],
                             ),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(_getIconForCategory(card.category), size: 50, color: Color(card.colorValue)),
                                 const SizedBox(height: 12),
                                 Text(card.title, style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w600, color: AppTheme.darkText)),
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

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange],
            ),
          )
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'animals': return Icons.pets_rounded;
      case 'space': return Icons.rocket_launch_rounded;
      case 'fruits': return Icons.apple_rounded; 
      case 'numbers': return Icons.looks_one_rounded;
      default: return Icons.star_rounded;
    }
  }
}
