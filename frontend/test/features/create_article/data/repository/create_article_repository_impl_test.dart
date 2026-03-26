import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/data/data_sources/article_data_sources.dart';
import 'package:news_app_clean_architecture/features/create_article/data/models/firebase_article_model.dart';
import 'package:news_app_clean_architecture/features/create_article/data/repository/create_article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';

class MockFirestoreDataSource extends Mock
    implements FirestoreArticleDataSource {}

class MockStorageDataSource extends Mock implements StorageArticleDataSource {}

class FakeFirebaseArticleModel extends Fake
    implements FirebaseArticleModel {}

class FakeFile extends Fake implements File {
  @override
  String get path => '/fake/path/image.jpg';
}

void main() {
  late CreateArticleRepositoryImpl repository;
  late MockFirestoreDataSource mockFirestoreDataSource;
  late MockStorageDataSource mockStorageDataSource;
  late FakeFile fakeFile;

  setUpAll(() {
    registerFallbackValue(FakeFirebaseArticleModel());
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    mockFirestoreDataSource = MockFirestoreDataSource();
    mockStorageDataSource = MockStorageDataSource();
    repository = CreateArticleRepositoryImpl(
      mockFirestoreDataSource,
      mockStorageDataSource,
    );
    fakeFile = FakeFile();
  });

  group('uploadArticleImage', () {
    const tDownloadUrl = 'https://storage.example.com/media/articles/img.jpg';

    test('returns DataSuccess with download URL on success', () async {
      when(() => mockStorageDataSource.uploadImage(any()))
          .thenAnswer((_) async => tDownloadUrl);

      final result = await repository.uploadArticleImage(fakeFile);

      expect(result, isA<DataSuccess<String>>());
      expect(result.data, equals(tDownloadUrl));
      verify(() => mockStorageDataSource.uploadImage(fakeFile)).called(1);
    });

    test('returns DataFailed with AppException when upload throws', () async {
      when(() => mockStorageDataSource.uploadImage(any()))
          .thenThrow(Exception('Network error'));

      final result = await repository.uploadArticleImage(fakeFile);

      expect(result, isA<DataFailed<String>>());
      expect(result.error, isA<AppException>());
      expect(result.error!.identifier, equals('uploadArticleImage'));
    });
  });

  group('createArticle', () {
    const tEntity = FirebaseArticleEntity(
      title: 'Test Title',
      description: 'Test Description',
      content: 'Test Content',
      author: 'Test Author',
      thumbnailUrl: 'https://example.com/image.jpg',
      ownerUid: 'uid-123',
    );

    final tCreatedModel = FirebaseArticleModel(
      id: 'generated-id',
      title: tEntity.title,
      description: tEntity.description,
      content: tEntity.content,
      author: tEntity.author,
      thumbnailUrl: tEntity.thumbnailUrl,
      ownerUid: tEntity.ownerUid,
      createdAt: DateTime(2026, 3, 25),
    );

    test('returns DataSuccess with created entity on success', () async {
      when(() => mockFirestoreDataSource.createArticle(any()))
          .thenAnswer((_) async => tCreatedModel);

      final result = await repository.createArticle(tEntity);

      expect(result, isA<DataSuccess<FirebaseArticleEntity>>());
      expect(result.data!.id, equals('generated-id'));
      expect(result.data!.title, equals('Test Title'));
      expect(result.data!.ownerUid, equals('uid-123'));
      verify(() => mockFirestoreDataSource.createArticle(any())).called(1);
    });

    test('returns DataFailed with AppException when Firestore throws',
        () async {
      when(() => mockFirestoreDataSource.createArticle(any()))
          .thenThrow(Exception('Firestore write failed'));

      final result = await repository.createArticle(tEntity);

      expect(result, isA<DataFailed<FirebaseArticleEntity>>());
      expect(result.error, isA<AppException>());
      expect(result.error!.identifier, equals('createArticle'));
    });

    test('converts entity to model before passing to data source', () async {
      when(() => mockFirestoreDataSource.createArticle(any()))
          .thenAnswer((_) async => tCreatedModel);

      await repository.createArticle(tEntity);

      final captured = verify(
        () => mockFirestoreDataSource.createArticle(captureAny()),
      ).captured.single as FirebaseArticleModel;

      expect(captured.title, equals(tEntity.title));
      expect(captured.description, equals(tEntity.description));
      expect(captured.content, equals(tEntity.content));
      expect(captured.author, equals(tEntity.author));
      expect(captured.thumbnailUrl, equals(tEntity.thumbnailUrl));
      expect(captured.ownerUid, equals(tEntity.ownerUid));
    });
  });

  group('getArticlesByOwner', () {
    final tModels = [
      FirebaseArticleModel(
        id: 'doc-1',
        title: 'Article One',
        description: 'Desc 1',
        content: 'Content 1',
        author: 'John Doe',
        thumbnailUrl: 'https://example.com/1.jpg',
        ownerUid: 'uid-john',
        createdAt: DateTime(2026, 3, 25),
      ),
    ];

    test('returns DataSuccess with list of entities on success', () async {
      when(() => mockFirestoreDataSource.getArticlesByOwner('uid-john'))
          .thenAnswer((_) async => tModels);

      final result = await repository.getArticlesByOwner('uid-john');

      expect(result, isA<DataSuccess<List<FirebaseArticleEntity>>>());
      expect(result.data!.length, 1);
      expect(result.data!.first.title, 'Article One');
      expect(result.data!.first.ownerUid, 'uid-john');
      verify(() => mockFirestoreDataSource.getArticlesByOwner('uid-john'))
          .called(1);
    });

    test('returns DataFailed with AppException when Firestore throws',
        () async {
      when(() => mockFirestoreDataSource.getArticlesByOwner('uid-john'))
          .thenThrow(Exception('Firestore error'));

      final result = await repository.getArticlesByOwner('uid-john');

      expect(result, isA<DataFailed<List<FirebaseArticleEntity>>>());
      expect(result.error, isA<AppException>());
      expect(result.error!.identifier, equals('getArticlesByOwner'));
    });
  });
}
