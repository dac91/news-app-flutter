import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/widgets/submit_article_button.dart';

void main() {
  group('SubmitArticleButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SubmitArticleButton(onPressed: () {}),
        ),
      ));

      expect(find.text('Publish Article'), findsOneWidget);
    });

    testWidgets('renders custom label', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SubmitArticleButton(
            onPressed: () {},
            label: 'Save Draft',
          ),
        ),
      ));

      expect(find.text('Save Draft'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SubmitArticleButton(onPressed: () => pressed = true),
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, true);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SubmitArticleButton(onPressed: null),
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SubmitArticleButton(
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ));

      expect(find.text('Publishing...'), findsOneWidget);
      expect(find.text('Publish Article'), findsNothing);
    });

    testWidgets('disables button when isLoading is true', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SubmitArticleButton(
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('has full width', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SubmitArticleButton(onPressed: () {}),
          ),
        ),
      ));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, double.infinity);
    });
  });
}
