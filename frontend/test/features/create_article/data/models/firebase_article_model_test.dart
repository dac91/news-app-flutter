import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/create_article/data/models/firebase_article_model.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';

void main() {
  group('FirebaseArticleModel', () {
    const tModel = FirebaseArticleModel(
      id: 'doc-123',
      title: 'Test Title',
      description: 'Test Description',
      content: 'Test Content',
      author: 'Test Author',
      thumbnailUrl: 'https://example.com/image.jpg',
    );

    test('extends FirebaseArticleEntity', () {
      expect(tModel, isA<FirebaseArticleEntity>());
    });

    group('fromRawData', () {
      test('creates model from Firestore map with all fields', () {
        final data = {
          'title': 'Title',
          'description': 'Desc',
          'content': 'Content',
          'author': 'Author',
          'thumbnailURL': 'https://example.com/img.jpg',
          'createdAt': null,
        };

        final model = FirebaseArticleModel.fromRawData(data, 'doc-456');

        expect(model.id, equals('doc-456'));
        expect(model.title, equals('Title'));
        expect(model.description, equals('Desc'));
        expect(model.content, equals('Content'));
        expect(model.author, equals('Author'));
        expect(model.thumbnailUrl, equals('https://example.com/img.jpg'));
        expect(model.createdAt, isNull);
      });

      test('handles missing fields with empty string defaults', () {
        final data = <String, dynamic>{};

        final model = FirebaseArticleModel.fromRawData(data, 'id');

        expect(model.title, equals(''));
        expect(model.description, equals(''));
        expect(model.content, equals(''));
        expect(model.author, equals(''));
        expect(model.thumbnailUrl, equals(''));
      });
    });

    group('toJson', () {
      test('produces correct map with all fields', () {
        final json = tModel.toJson();

        expect(json['title'], equals('Test Title'));
        expect(json['description'], equals('Test Description'));
        expect(json['content'], equals('Test Content'));
        expect(json['author'], equals('Test Author'));
        expect(json['thumbnailURL'], equals('https://example.com/image.jpg'));
        // createdAt is FieldValue.serverTimestamp() — can't compare directly,
        // but we can verify the key exists
        expect(json.containsKey('createdAt'), isTrue);
      });

      test('does not include id in JSON (Firestore manages document IDs)', () {
        final json = tModel.toJson();
        expect(json.containsKey('id'), isFalse);
      });

      test('contains exactly 6 fields', () {
        final json = tModel.toJson();
        expect(json.keys.length, equals(6));
      });
    });

    group('toEntity', () {
      test('converts model to entity with all fields preserved', () {
        final entity = tModel.toEntity();

        expect(entity, isA<FirebaseArticleEntity>());
        expect(entity.id, equals('doc-123'));
        expect(entity.title, equals('Test Title'));
        expect(entity.description, equals('Test Description'));
        expect(entity.content, equals('Test Content'));
        expect(entity.author, equals('Test Author'));
        expect(entity.thumbnailUrl, equals('https://example.com/image.jpg'));
      });
    });

    group('fromEntity', () {
      test('creates model from entity with all fields preserved', () {
        const entity = FirebaseArticleEntity(
          id: 'entity-id',
          title: 'Entity Title',
          description: 'Entity Desc',
          content: 'Entity Content',
          author: 'Entity Author',
          thumbnailUrl: 'https://example.com/entity.jpg',
        );

        final model = FirebaseArticleModel.fromEntity(entity);

        expect(model, isA<FirebaseArticleModel>());
        expect(model.id, equals('entity-id'));
        expect(model.title, equals('Entity Title'));
        expect(model.description, equals('Entity Desc'));
      });
    });
  });
}
