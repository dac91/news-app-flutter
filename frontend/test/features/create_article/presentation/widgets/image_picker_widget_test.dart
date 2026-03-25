import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/widgets/image_picker_widget.dart';

void main() {
  group('ImagePickerWidget', () {
    testWidgets('shows placeholder when no image is selected', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImagePickerWidget(
            isUploading: false,
            onTap: () {},
          ),
        ),
      ));

      expect(find.text('Tap to add thumbnail image'), findsOneWidget);
      expect(find.text('JPG, PNG • Max 5 MB'), findsOneWidget);
      expect(find.byIcon(Icons.add_photo_alternate_outlined), findsOneWidget);
    });

    testWidgets('shows uploading indicator when isUploading is true',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImagePickerWidget(
            isUploading: true,
            onTap: () {},
          ),
        ),
      ));

      expect(find.text('Uploading image...'), findsOneWidget);
      expect(find.text('Tap to add thumbnail image'), findsNothing);
    });

    testWidgets('shows uploaded badge when uploadedImageUrl is set',
        (tester) async {
      // Image.network returns 400 in test, but the widget's errorBuilder
      // handles it gracefully. The badge and overlay text are still rendered
      // because they sit above the image in the Stack.
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImagePickerWidget(
            uploadedImageUrl: 'https://example.com/image.jpg',
            isUploading: false,
            onTap: () {},
          ),
        ),
      ));

      await tester.pump();

      expect(find.text('Uploaded'), findsOneWidget);
      expect(find.text('Tap to change image'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped and not uploading', (tester) async {
      var tapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImagePickerWidget(
            isUploading: false,
            onTap: () => tapped = true,
          ),
        ),
      ));

      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, true);
    });

    testWidgets('does not call onTap when uploading', (tester) async {
      var tapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImagePickerWidget(
            isUploading: true,
            onTap: () => tapped = true,
          ),
        ),
      ));

      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, false);
    });

    testWidgets('shows change overlay when selectedImage is set',
        (tester) async {
      // Create a temporary file for testing
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/test_image.jpg');
      tempFile.writeAsBytesSync([0xFF, 0xD8, 0xFF]); // minimal JPEG header

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImagePickerWidget(
            selectedImage: tempFile,
            isUploading: false,
            onTap: () {},
          ),
        ),
      ));

      expect(find.text('Tap to change image'), findsOneWidget);
      expect(find.text('Tap to add thumbnail image'), findsNothing);

      // Clean up
      tempFile.deleteSync();
    });

    testWidgets('has correct container height of 200', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImagePickerWidget(
            isUploading: false,
            onTap: () {},
          ),
        ),
      ));

      // Verify the rendered size of the ImagePickerWidget.
      // Height = 200 (container) + 16 (bottom padding).
      final size = tester.getSize(find.byType(ImagePickerWidget));
      expect(size.height, 216);
    });
  });
}
