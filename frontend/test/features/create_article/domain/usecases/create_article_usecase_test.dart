import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/create_article_params.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/create_article_usecase.dart';

class MockCreateArticleRepository extends Mock
    implements CreateArticleRepository {}

class FakeFirebaseArticleEntity extends Fake
    implements FirebaseArticleEntity {}

class FakeFile extends Fake implements File {}

void main() {
  late CreateArticleUseCase useCase;
  late MockCreateArticleRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeFirebaseArticleEntity());
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    mockRepository = MockCreateArticleRepository();
    useCase = CreateArticleUseCase(mockRepository);
  });

  const tParams = CreateArticleParams(
    title: 'Test Title',
    description: 'Test Description',
    content: 'Test Content',
    author: 'Test Author',
    thumbnailUrl: 'https://example.com/image.jpg',
    ownerUid: 'uid-123',
  );

  final tCreatedEntity = FirebaseArticleEntity(
    id: 'generated-id',
    title: tParams.title,
    description: tParams.description,
    content: tParams.content,
    author: tParams.author,
    thumbnailUrl: tParams.thumbnailUrl,
    ownerUid: tParams.ownerUid,
    createdAt: DateTime(2026, 3, 25),
  );

  group('CreateArticleUseCase', () {
    test('returns DataSuccess with created entity on success', () async {
      // Arrange
      when(() => mockRepository.createArticle(any()))
          .thenAnswer((_) async => DataSuccess(tCreatedEntity));

      // Act
      final result = await useCase(params: tParams);

      // Assert
      expect(result, isA<DataSuccess<FirebaseArticleEntity>>());
      expect(result.data, equals(tCreatedEntity));
      expect(result.data!.id, equals('generated-id'));
      verify(() => mockRepository.createArticle(any())).called(1);
    });

    test('returns DataFailed with AppException on failure', () async {
      // Arrange
      const tException = AppException(
        message: 'Failed to create article',
        statusCode: 500,
        identifier: 'createArticle',
      );
      when(() => mockRepository.createArticle(any()))
          .thenAnswer((_) async => const DataFailed(tException));

      // Act
      final result = await useCase(params: tParams);

      // Assert
      expect(result, isA<DataFailed<FirebaseArticleEntity>>());
      expect(result.error, equals(tException));
      expect(result.error!.message, equals('Failed to create article'));
      verify(() => mockRepository.createArticle(any())).called(1);
    });

    test('passes correct entity fields to repository', () async {
      // Arrange
      when(() => mockRepository.createArticle(any()))
          .thenAnswer((_) async => DataSuccess(tCreatedEntity));

      // Act
      await useCase(params: tParams);

      // Assert
      final captured = verify(
        () => mockRepository.createArticle(captureAny()),
      ).captured.single as FirebaseArticleEntity;

      expect(captured.title, equals(tParams.title));
      expect(captured.description, equals(tParams.description));
      expect(captured.content, equals(tParams.content));
      expect(captured.author, equals(tParams.author));
      expect(captured.thumbnailUrl, equals(tParams.thumbnailUrl));
      expect(captured.ownerUid, equals(tParams.ownerUid));
      expect(captured.id, isNull);
      expect(captured.createdAt, isNull);
    });
  });
}
