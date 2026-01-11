import 'package:flutter/material.dart';

/// Flashcard Widget
/// 
/// A reusable widget to display a single flashcard.
/// Implement flip animation and card design here.
class FlashcardWidget extends StatelessWidget {
  final String question;
  final String answer;
  
  const FlashcardWidget({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              question,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              answer,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
