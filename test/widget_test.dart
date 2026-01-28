import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_learning_flashcards/widgets/clay_card.dart';

// Simple widget test to verify ClayCard renders
void main() {
  testWidgets('ClayCard renders with child', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ClayCard(
            color: Colors.blue,
            child: Text('Test Child'),
          ),
        ),
      ),
    );

    expect(find.text('Test Child'), findsOneWidget);
    expect(find.byType(ClayCard), findsOneWidget);
  });
}
