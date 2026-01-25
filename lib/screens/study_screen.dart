import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flashcard_model.dart';

class StudyScreen extends StatefulWidget {
  final String category;
  final List<Flashcard> flashcards;

  const StudyScreen({
    super.key,
    required this.category,
    required this.flashcards,
  });

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextCard() {
    if (_currentIndex < widget.flashcards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevCard() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F9), // Light blueish gray from design
      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // TOP BAR: Close | Category Name | Counter
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.orange),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  
                  // Category Name
                  Column(
                    children: [
                      Text(
                        widget.category.toUpperCase(),
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Progress Dots (simplified)
                      Row(
                        children: List.generate(
                          widget.flashcards.length > 5 ? 5 : widget.flashcards.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: index <= (_currentIndex % 5) ? Colors.orange : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  
                  // Counter Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${widget.flashcards.length}',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // ============================================================
            // FLASHCARD CARD AREA
            // ============================================================
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Use buttons to nav
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                    _isFlipped = false;
                  });
                },
                itemCount: widget.flashcards.length,
                itemBuilder: (context, index) {
                  final card = widget.flashcards[index];
                  return _buildFlashcard(card);
                },
              ),
            ),
            
            // ============================================================
            // BOTTOM CONTROLS: Back | Next
            // ============================================================
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Back Button
                  if (_currentIndex > 0)
                    ElevatedButton(
                      onPressed: _prevCard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 24),
                    )
                  else
                    const SizedBox(width: 80), // Spacer
                    
                  // Next Button
                  if (_currentIndex < widget.flashcards.length - 1)
                    ElevatedButton(
                      onPressed: _nextCard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Next',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 18),
                        ],
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Finish',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashcard(Flashcard card) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isFlipped = !_isFlipped;
          });
        },
        child: Container(
          width: 320,
          height: 480,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Speaker / Audio Icon
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(Icons.volume_up, color: Colors.orange.shade400),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Image/Icon Area
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Color(card.colorValue).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star, // Placeholder icon
                  size: 80,
                  color: Color(card.colorValue),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Title
              Text(
                card.title.toUpperCase(),
                style: GoogleFonts.fredoka(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade800,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                // Just dummy text since model doesn't have subtitle
                'Tap to flip', 
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
