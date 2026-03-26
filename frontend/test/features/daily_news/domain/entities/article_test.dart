import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

void main() {
  group('ArticleEntity', () {
    test('supports value equality via Equatable', () {
      const entity1 = ArticleEntity(
        id: 1,
        author: 'John Doe',
        title: 'Test Title',
        description: 'Test Description',
        url: 'https://example.com/article',
        urlToImage: 'https://example.com/image.jpg',
        publishedAt: '2026-03-25',
        content: 'Full article content',
      );
      const entity2 = ArticleEntity(
        id: 1,
        author: 'John Doe',
        title: 'Test Title',
        description: 'Test Description',
        url: 'https://example.com/article',
        urlToImage: 'https://example.com/image.jpg',
        publishedAt: '2026-03-25',
        content: 'Full article content',
      );

      expect(entity1, equals(entity2));
    });

    test('entities with different fields are not equal', () {
      const entity1 = ArticleEntity(id: 1, title: 'Title A');
      const entity2 = ArticleEntity(id: 2, title: 'Title B');

      expect(entity1, isNot(equals(entity2)));
    });

    test('all fields are nullable', () {
      const entity = ArticleEntity();

      expect(entity.id, isNull);
      expect(entity.author, isNull);
      expect(entity.title, isNull);
      expect(entity.description, isNull);
      expect(entity.url, isNull);
      expect(entity.urlToImage, isNull);
      expect(entity.publishedAt, isNull);
      expect(entity.content, isNull);
    });

    test('props contains all fields', () {
      const entity = ArticleEntity(
        id: 42,
        author: 'Author',
        title: 'Title',
        description: 'Desc',
        url: 'https://example.com',
        urlToImage: 'https://example.com/img.jpg',
        publishedAt: '2026-01-01',
        content: 'Content',
      );

      expect(entity.props, [
        42,
        'Author',
        'Title',
        'Desc',
        'https://example.com',
        'https://example.com/img.jpg',
        '2026-01-01',
        'Content',
      ]);
    });

    test('entities with same id but different content are not equal', () {
      const entity1 = ArticleEntity(id: 1, title: 'Title A');
      const entity2 = ArticleEntity(id: 1, title: 'Title B');

      expect(entity1, isNot(equals(entity2)));
    });
  });
}
