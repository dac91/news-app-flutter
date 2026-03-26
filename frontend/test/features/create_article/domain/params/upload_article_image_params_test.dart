import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/upload_article_image_params.dart';

void main() {
  group('UploadArticleImageParams', () {
    test('stores imageFile correctly', () {
      final file = File('/tmp/test_image.jpg');
      final params = UploadArticleImageParams(imageFile: file);

      expect(params.imageFile.path, equals('/tmp/test_image.jpg'));
    });

    test('supports value equality based on file path via Equatable', () {
      final params1 = UploadArticleImageParams(
        imageFile: File('/tmp/image.jpg'),
      );
      final params2 = UploadArticleImageParams(
        imageFile: File('/tmp/image.jpg'),
      );

      expect(params1, equals(params2));
    });

    test('params with different file paths are not equal', () {
      final params1 = UploadArticleImageParams(
        imageFile: File('/tmp/image_a.jpg'),
      );
      final params2 = UploadArticleImageParams(
        imageFile: File('/tmp/image_b.jpg'),
      );

      expect(params1, isNot(equals(params2)));
    });

    test('props uses file path for equality', () {
      final file = File('/tmp/test.jpg');
      final params = UploadArticleImageParams(imageFile: file);

      expect(params.props, ['/tmp/test.jpg']);
    });
  });
}
