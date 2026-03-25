import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/widgets/article_text_field.dart';

void main() {
  group('ArticleTextField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    Widget buildTestWidget({
      String label = 'Title',
      String hint = 'Enter title',
      int maxLength = 200,
      int maxLines = 1,
      String? Function(String?)? validator,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Form(
            child: ArticleTextField(
              controller: controller,
              label: label,
              hint: hint,
              maxLength: maxLength,
              maxLines: maxLines,
              validator: validator,
            ),
          ),
        ),
      );
    }

    testWidgets('renders label and hint text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        label: 'Title',
        hint: 'Enter title',
      ));

      expect(find.text('Title'), findsOneWidget);
      // Hint text is shown when field is focused
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(find.text('Enter title'), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextFormField), 'Test article');
      expect(controller.text, 'Test article');
    });

    testWidgets('enforces max length', (tester) async {
      await tester.pumpWidget(buildTestWidget(maxLength: 10));

      await tester.enterText(
          find.byType(TextFormField), 'This is a very long text exceeding max');
      // TextFormField maxLength truncates input
      expect(controller.text.length, lessThanOrEqualTo(10));
    });

    testWidgets('default validator rejects empty input', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: ArticleTextField(
              controller: controller,
              label: 'Title',
              hint: 'Enter title',
              maxLength: 200,
            ),
          ),
        ),
      ));

      // Trigger validation with empty text
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Title is required'), findsOneWidget);
    });

    testWidgets('default validator accepts non-empty input', (tester) async {
      final formKey = GlobalKey<FormState>();
      controller.text = 'Valid input';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: ArticleTextField(
              controller: controller,
              label: 'Title',
              hint: 'Enter title',
              maxLength: 200,
            ),
          ),
        ),
      ));

      final isValid = formKey.currentState!.validate();
      await tester.pump();

      expect(isValid, true);
    });

    testWidgets('custom validator overrides default', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: ArticleTextField(
              controller: controller,
              label: 'Email',
              hint: 'Enter email',
              maxLength: 200,
              validator: (value) =>
                  value != null && value.contains('@') ? null : 'Invalid email',
            ),
          ),
        ),
      ));

      controller.text = 'not-an-email';
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('renders with multiple lines for content fields',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(maxLines: 8));

      // Verify the widget renders without error with maxLines > 1
      expect(find.byType(TextFormField), findsOneWidget);
    });
  });
}
