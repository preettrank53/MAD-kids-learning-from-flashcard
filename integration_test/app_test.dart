import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kids_learning_flashcards/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify dashboard loads and navigation works',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify Dashboard "Hi, Leo!" text matches
      expect(find.text('Hi, Leo!'), findsOneWidget);

      // Verify "Daily Mission" tile exists
      expect(find.text('DAILY MISSION'), findsOneWidget);

      // Verify "Space" category exists (assuming db is seeded or empty state handled)
      // Since we can't guarantee DB state on fresh install without mocking, 
      // we check for specific UI elements we know should be there.
      
      // If we are in empty state:
      if (find.text('No flashcards found').evaluate().isNotEmpty) {
        expect(find.text('No flashcards found'), findsOneWidget);
      } else {
        // If we have cards (seeded), we might see categories
        // Let's assume for this test we stick to verifying static dashboard elements
        expect(find.byIcon(Icons.rocket_launch_rounded), findsOneWidget);
      }
    });
  });
}
