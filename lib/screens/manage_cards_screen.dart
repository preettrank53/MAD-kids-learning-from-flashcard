import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/db_helper.dart';
import '../models/flashcard_model.dart';

/// Manage Cards Screen
/// 
/// This screen demonstrates "List Views", "Cards", and "Alerts/Dialogs" (Lab 7).
/// It allows users to view all cards in a list and delete them with confirmation.
class ManageCardsScreen extends StatefulWidget {
  const ManageCardsScreen({super.key});

  @override
  State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  // Theme Constants (Playful Pastel Theme)
  final Color softOrange = const Color(0xFFFF9F1C);
  final Color mintGreen = const Color(0xFF2EC4B6);
  final Color skyBlue = const Color(0xFFCBF3F0);
  final Color darkText = const Color(0xFF2D3436);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Manage Cards',
          style: GoogleFonts.fredoka(color: darkText, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      // Step 4 Requirement: ListView.builder
      body: FutureBuilder<List<Flashcard>>(
        future: DatabaseHelper.instance.getFlashcards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: softOrange));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.style_outlined, size: 80, color: Colors.grey.shade300),
                   const SizedBox(height: 16),
                   Text(
                     "No cards yet!",
                     style: GoogleFonts.fredoka(fontSize: 24, color: Colors.grey.shade400),
                   ),
                ],
              ),
            );
          }

          final flashcards = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: flashcards.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final card = flashcards[index];
              
              // Step 4 Requirement: Card with high elevation and rounded corners
              return Card(
                elevation: 4,
                shadowColor: mintGreen.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    // Leading: CircleAvatar with pastel background
                    leading: CircleAvatar(
                      backgroundColor: softOrange.withOpacity(0.2),
                      radius: 24,
                      child: Icon(Icons.star_rounded, color: softOrange),
                    ),
                    
                    // Title: Bold Fredoka font
                    title: Text(
                      card.title,
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),
                    
                    // Subtitle: Category
                    subtitle: Text(
                      card.category,
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Trailing: Delete icon button
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                      onPressed: () => _confirmDelete(card),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Step 6 Requirement: Interactive Feedback (Dialog + SnackBar)
  void _confirmDelete(Flashcard card) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            "Delete Card?", 
            style: GoogleFonts.fredoka(color: darkText),
          ),
          content: Text(
            "Are you sure you want to delete '${card.title}'? This cannot be undone.",
            style: GoogleFonts.nunito(color: Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text("Cancel", style: TextStyle(color:  Colors.grey.shade600, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () async {
                // 1. Delete Item
                await DatabaseHelper.instance.deleteFlashcard(card.id!);
                
                if (mounted) {
                  Navigator.pop(context); // Close Dialog
                  
                  // 2. Refresh UI (rebuild FutureBuilder)
                  setState(() {});
                  
                  // 3. Show SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text("Card deleted successfully!"),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: mintGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Yes, Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
