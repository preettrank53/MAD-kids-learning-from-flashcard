import '../models/flashcard_model.dart';
import 'dart:math';

/// Spaced Repetition System Service
/// 
/// Implements the SuperMemo-2 (SM-2) algorithm to optimize learning.
/// 
/// Algorithm Logic:
/// 1. I(1) = 1 day
/// 2. I(2) = 6 days
/// 3. I(n) = I(n-1) * EF
/// 4. EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
/// Where:
/// - I(n) = Inter-repetition interval after n-th repetition (in days)
/// - EF = Ease Factor (easiness of the item, default 2.5)
/// - q = Quality of response (0-5 scale)
class SrsService {
  
  /// Calculates the next state of a flashcard based on the user's response quality.
  /// 
  /// [card]: The current flashcard
  /// [quality]: User rating (0: Total Blackout, 3: Hard, 4: Good, 5: Perfect)
  static Flashcard processReview(Flashcard card, int quality) {
    if (quality < 3) {
      // If the answer was wrong (quality < 3), reset the algorithm
      // But keep the Ease Factor same or slightly reduced? SM-2 says start reps over.
      return card.copyWith(
        repetitions: 0,
        interval: 1, // Review tomorrow
        dueDate: DateTime.now().add(const Duration(days: 1)),
      );
    }
    
    // Calculate new Repetitions
    int newRepetitions = card.repetitions + 1;
    
    // Calculate new Interval
    int newInterval;
    if (newRepetitions == 1) {
      newInterval = 1;
    } else if (newRepetitions == 2) {
      newInterval = 6;
    } else {
      newInterval = (card.interval * card.easeFactor).round();
    }
    
    // Calculate new Ease Factor
    // EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
    double newEaseFactor = card.easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    
    // Ease Factor lower limit is 1.3
    if (newEaseFactor < 1.3) newEaseFactor = 1.3;
    
    // Calculate new Due Date
    DateTime newDueDate = DateTime.now().add(Duration(days: newInterval));
    
    return card.copyWith(
      repetitions: newRepetitions,
      interval: newInterval,
      easeFactor: newEaseFactor,
      dueDate: newDueDate,
    );
  }
}
