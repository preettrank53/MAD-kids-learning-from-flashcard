import 'package:flutter_test/flutter_test.dart';
import 'package:kids_learning_flashcards/models/flashcard_model.dart';
import 'package:kids_learning_flashcards/services/srs_service.dart';

void main() {
  group('Flashcard Model Tests', () {
    test('Flashcard serialization (toMap/fromMap) works correctly', () {
      final card = Flashcard(
        id: 1,
        title: 'Apple',
        category: 'Food',
        colorValue: 0xFFFF0000,
        easeFactor: 2.6,
        interval: 3,
        repetitions: 2,
        dueDate: DateTime(2025, 1, 1),
      );

      final map = card.toMap();
      final newCard = Flashcard.fromMap(map);

      expect(newCard.id, card.id);
      expect(newCard.title, card.title);
      expect(newCard.easeFactor, card.easeFactor);
      expect(newCard.dueDate?.day, 1); // Basic check for date persistence
    });

    test('copyWith creates a valid modified copy', () {
      final card = Flashcard(
        title: 'Original',
        category: 'Test',
        colorValue: 0xFF000000,
      );

      final modified = card.copyWith(title: 'Modified', repetitions: 5);

      expect(modified.title, 'Modified');
      expect(modified.category, 'Test'); // Should remain unchanged
      expect(modified.repetitions, 5);
      expect(card.title, 'Original'); // Original should be immutable
    });
  });

  group('SRS Service (SuperMemo-2) Tests', () {
    final srsService = SrsService();
    final defaultCard = Flashcard(
      title: 'Test',
      category: 'Test',
      colorValue: 0xFF000000,
    );

    test('Correct answer (Quality 5) increases repetitions and interval', () {
      final processedCard = SrsService.processReview(defaultCard, 5);

      expect(processedCard.repetitions, 1);
      expect(processedCard.interval, 1);
      expect(processedCard.easeFactor, greaterThan(2.5)); // Ease factor increases
    });

    test('Incorrect answer (Quality 0) resets repetitions', () {
      final learnedCard = defaultCard.copyWith(repetitions: 5, interval: 10, easeFactor: 2.8);
      final processedCard = SrsService.processReview(learnedCard, 0);

      expect(processedCard.repetitions, 0);
      expect(processedCard.interval, 1);
      // Ease factor remains unchanged on failure (per implementation)
      expect(processedCard.easeFactor, 2.8); 
      expect(processedCard.easeFactor, greaterThanOrEqualTo(1.3));
    });

    test('Second repetition sets interval to 6', () {
      // Simulate card that has been reviewed once
      final cardOnce = defaultCard.copyWith(repetitions: 1, interval: 1);
      final processedCard = SrsService.processReview(cardOnce, 4);

      expect(processedCard.repetitions, 2);
      expect(processedCard.interval, 6); // Hardcoded rule in SM-2
    });
  });
}
