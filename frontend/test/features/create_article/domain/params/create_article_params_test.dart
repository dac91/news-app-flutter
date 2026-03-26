import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/create_article_params.dart';

void main() {
  group('CreateArticleParams', () {
    test('supports value equality via Equatable', () {
      const params1 = CreateArticleParams(
        title: 'Title',
        description: 'Desc',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'https://example.com/img.jpg',
        ownerUid: 'uid-123',
      );
      const params2 = CreateArticleParams(
        title: 'Title',
        description: 'Desc',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'https://example.com/img.jpg',
        ownerUid: 'uid-123',
      );

      expect(params1, equals(params2));
    });

    test('params with different fields are not equal', () {
      const params1 = CreateArticleParams(
        title: 'Title A',
        description: 'Desc',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'https://example.com/a.jpg',
        ownerUid: 'uid-1',
      );
      const params2 = CreateArticleParams(
        title: 'Title B',
        description: 'Desc',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'https://example.com/b.jpg',
        ownerUid: 'uid-2',
      );

      expect(params1, isNot(equals(params2)));
    });

    test('category is optional and defaults to null', () {
      const params = CreateArticleParams(
        title: 'Title',
        description: 'Desc',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'https://example.com/img.jpg',
        ownerUid: 'uid-123',
      );

      expect(params.category, isNull);
    });

    test('category is included when provided', () {
      const params = CreateArticleParams(
        title: 'Title',
        description: 'Desc',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'https://example.com/img.jpg',
        ownerUid: 'uid-123',
        category: 'technology',
      );

      expect(params.category, equals('technology'));
    });

    test('props contains all fields including category', () {
      const params = CreateArticleParams(
        title: 'T',
        description: 'D',
        content: 'C',
        author: 'A',
        thumbnailUrl: 'url',
        ownerUid: 'uid',
        category: 'cat',
      );

      expect(params.props, [
        'T',
        'D',
        'C',
        'A',
        'url',
        'uid',
        'cat',
      ]);
    });

    test('params with different ownerUid are not equal', () {
      const params1 = CreateArticleParams(
        title: 'Title',
        description: 'Desc',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'url',
        ownerUid: 'uid-1',
      );
      const params2 = CreateArticleParams(
        title: 'Title',
        description: 'Desc',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'url',
        ownerUid: 'uid-2',
      );

      expect(params1, isNot(equals(params2)));
    });
  });
}
