import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

void main() {
  group('ArticleModel', () {
    const tModel = ArticleModel(
      id: 1,
      author: 'John Doe',
      title: 'Test Title',
      description: 'Test Description',
      url: 'https://example.com/article',
      urlToImage: 'https://example.com/image.jpg',
      publishedAt: '2026-03-25',
      content: 'Full article content',
    );

    test('extends ArticleEntity', () {
      expect(tModel, isA<ArticleEntity>());
    });

    group('fromJson', () {
      test('creates model from JSON with all fields', () {
        final json = {
          'author': 'Jane Doe',
          'title': 'JSON Title',
          'description': 'JSON Desc',
          'url': 'https://example.com',
          'urlToImage': 'https://example.com/img.jpg',
          'publishedAt': '2026-03-25',
          'content': 'JSON content',
        };

        final model = ArticleModel.fromJson(json);

        expect(model.author, equals('Jane Doe'));
        expect(model.title, equals('JSON Title'));
        expect(model.description, equals('JSON Desc'));
        expect(model.url, equals('https://example.com'));
        expect(model.urlToImage, equals('https://example.com/img.jpg'));
        expect(model.publishedAt, equals('2026-03-25'));
        expect(model.content, equals('JSON content'));
      });

      test('handles missing fields with empty string defaults', () {
        final json = <String, dynamic>{};

        final model = ArticleModel.fromJson(json);

        expect(model.author, equals(''));
        expect(model.title, equals(''));
        expect(model.description, equals(''));
        expect(model.url, equals(''));
        expect(model.publishedAt, equals(''));
        expect(model.content, equals(''));
      });

      test('uses default image when urlToImage is null', () {
        final json = <String, dynamic>{'urlToImage': null};

        final model = ArticleModel.fromJson(json);

        expect(model.urlToImage, contains('placehold'));
      });

      test('uses default image when urlToImage is empty string', () {
        final json = <String, dynamic>{'urlToImage': ''};

        final model = ArticleModel.fromJson(json);

        expect(model.urlToImage, contains('placehold'));
      });
    });

    group('fromRawData', () {
      test('is an alias for fromJson', () {
        final json = {
          'author': 'Alias Author',
          'title': 'Alias Title',
          'description': 'Alias Desc',
          'url': 'https://alias.com',
          'urlToImage': 'https://alias.com/img.jpg',
          'publishedAt': '2026-01-01',
          'content': 'Alias content',
        };

        final fromJson = ArticleModel.fromJson(json);
        final fromRawData = ArticleModel.fromRawData(json);

        expect(fromRawData, equals(fromJson));
      });
    });

    group('fromEntity', () {
      test('creates model from entity with all fields preserved', () {
        const entity = ArticleEntity(
          id: 42,
          author: 'Entity Author',
          title: 'Entity Title',
          description: 'Entity Desc',
          url: 'https://entity.com',
          urlToImage: 'https://entity.com/img.jpg',
          publishedAt: '2026-02-15',
          content: 'Entity content',
        );

        final model = ArticleModel.fromEntity(entity);

        expect(model, isA<ArticleModel>());
        expect(model.id, equals(42));
        expect(model.author, equals('Entity Author'));
        expect(model.title, equals('Entity Title'));
        expect(model.description, equals('Entity Desc'));
        expect(model.url, equals('https://entity.com'));
        expect(model.urlToImage, equals('https://entity.com/img.jpg'));
        expect(model.publishedAt, equals('2026-02-15'));
        expect(model.content, equals('Entity content'));
      });
    });

    group('toEntity', () {
      test('converts model to entity with all fields preserved', () {
        final entity = tModel.toEntity();

        expect(entity, isA<ArticleEntity>());
        expect(entity, isNot(isA<ArticleModel>()));
        expect(entity.id, equals(1));
        expect(entity.author, equals('John Doe'));
        expect(entity.title, equals('Test Title'));
        expect(entity.description, equals('Test Description'));
        expect(entity.url, equals('https://example.com/article'));
        expect(entity.urlToImage, equals('https://example.com/image.jpg'));
        expect(entity.publishedAt, equals('2026-03-25'));
        expect(entity.content, equals('Full article content'));
      });
    });
  });
}
