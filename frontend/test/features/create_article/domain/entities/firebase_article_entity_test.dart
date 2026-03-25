import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';

void main() {
  group('FirebaseArticleEntity', () {
    test('supports value equality via Equatable', () {
      const entity1 = FirebaseArticleEntity(
        id: '1',
        title: 'Test Title',
        description: 'Test Description',
        content: 'Test Content',
        author: 'Test Author',
        thumbnailUrl: 'https://example.com/image.jpg',
      );
      const entity2 = FirebaseArticleEntity(
        id: '1',
        title: 'Test Title',
        description: 'Test Description',
        content: 'Test Content',
        author: 'Test Author',
        thumbnailUrl: 'https://example.com/image.jpg',
      );

      expect(entity1, equals(entity2));
    });

    test('entities with different fields are not equal', () {
      const entity1 = FirebaseArticleEntity(
        id: '1',
        title: 'Title A',
        description: 'Desc',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'https://example.com/a.jpg',
      );
      const entity2 = FirebaseArticleEntity(
        id: '2',
        title: 'Title B',
        description: 'Desc',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'https://example.com/b.jpg',
      );

      expect(entity1, isNot(equals(entity2)));
    });

    test('id and createdAt are nullable', () {
      const entity = FirebaseArticleEntity(
        title: 'Title',
        description: 'Description',
        content: 'Content',
        author: 'Author',
        thumbnailUrl: 'https://example.com/img.jpg',
      );

      expect(entity.id, isNull);
      expect(entity.createdAt, isNull);
    });

    test('props contains all fields', () {
      final now = DateTime(2026, 3, 25);
      final entity = FirebaseArticleEntity(
        id: 'abc',
        title: 'T',
        description: 'D',
        content: 'C',
        author: 'A',
        thumbnailUrl: 'url',
        createdAt: now,
      );

      expect(entity.props, [
        'abc',
        'T',
        'D',
        'C',
        'A',
        'url',
        now,
      ]);
    });
  });
}
