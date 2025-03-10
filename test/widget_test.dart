import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maths_quiz/main.dart'; // Update to use your app's main file

void main() {
  testWidgets('Math Quiz Game starts and progresses',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the "Start Game" button exists on the HomeScreen.
    expect(find.text('Start Game'), findsOneWidget);

    // Tap on the "Start Game" button to start the game.
    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle(); // Wait for the animation to finish

    // Verify that the GameScreen is displayed and has the question text.
    expect(find.textContaining('+'),
        findsOneWidget); // Question contains a plus sign.

    // Verify that the answer options are displayed.
    expect(
        find.byType(ElevatedButton), findsNWidgets(3)); // Three answer buttons.

    // Tap on an answer option.
    await tester.tap(find.text('1')); // Assuming '1' is one of the options
    await tester.pumpAndSettle();

    // Check the feedback dialog after the answer is selected.
    expect(find.text('Try Again'),
        findsOneWidget); // Feedback text for incorrect answer.

    // Tap the "Next" button in the dialog to continue.
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle(); // Wait for the next question to load

    // Verify that the level progresses.
    expect(
        find.text('Level 2'), findsOneWidget); // Check if level updated to 2.

    // Optionally: Add more assertions for other widgets and behaviors.
  });

  testWidgets('Test star count update on correct answer',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Start the game
    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();

    // Assume the first answer option is correct
    await tester
        .tap(find.text('10')); // Assuming 10 is correct (check your code)
    await tester.pumpAndSettle();

    // Check if the stars count increased
    expect(find.text('1'),
        findsOneWidget); // Expect to see 1 star after correct answer.
  });

  testWidgets('Test retry after incorrect answer', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Start the game
    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();

    // Tap an incorrect answer (assuming '3' is incorrect)
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    // Verify the feedback dialog with the "Try Again" message
    expect(find.text('Try Again'), findsOneWidget);

    // Tap the "Next" button to retry
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Check that the level didn't increase
    expect(find.text('Level 1'), findsOneWidget); // Should still be at level 1.
  });
}
