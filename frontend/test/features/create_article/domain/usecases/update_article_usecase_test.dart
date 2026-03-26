import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/update_article_usecase.dart';

class MockCreateArticleRepository extends Mock
    implements CreateArticleRepository {}

class FakeFirebaseArticleEntity extends Fake
    implements FirebaseArticleEntity {}

void main() {
  late UpdateArticleUseCase useCase;
  late MockCreateArticleRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeFirebaseArticleEntity());
  });

  setUp(() {
    mockRepository = MockCreateArticleRepository();
    useCase = UpdateArticleUseCase(mockRepository);
  });

  final tEntity = FirebaseArticleEntity(
    id: 'doc-123',
    title: 'Updated Title',
    description: 'Updated Description',
    content: 'Updated Content',
    author: 'Author',
    thumbnailUrl: 'https://example.com/img.jpg',
    ownerUid: 'uid-123',
    category: 'technology',
    createdAt: DateTime(2026, 3, 20),
  );

  group('UpdateArticleUseCase', () {
    test('returns DataSuccess with updated entity on success', () async {
      when(() => mockRepository.updateArticle(any()))
          .thenAnswer((_) async => DataSuccess(tEntity));

      final result = await useCase(params: tEntity);

      expect(result, isA<DataSuccess<FirebaseArticleEntity>>());
      expect(result.data, equals(tEntity));
      verify(() => mockRepository.updateArticle(any())).called(1);
    });

    test('returns DataFailed with AppException on failure', () async {
      const tException = AppException(
        message: 'Update failed',
        statusCode: 500,
        identifier: 'updateArticle',
      );
      when(() => mockRepository.updateArticle(any()))
          .thenAnswer((_) async => const DataFailed(tException));

      final result = await useCase(params: tEntity);

      expect(result, isA<DataFailed<FirebaseArticleEntity>>());
      expect(result.error!.message, 'Update failed');
    });

    test('throws ArgumentError when params is null', () async {
      expect(
        () => useCase(params: null),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('passes correct entity to repository', () async {
      when(() => mockRepository.updateArticle(any()))
          .thenAnswer((_) async => DataSuccess(tEntity));

      await useCase(params: tEntity);

      final captured = verify(
        () => mockRepository.updateArticle(captureAny()),
      ).captured.single as FirebaseArticleEntity;

      expect(captured.id, 'doc-123');
      expect(captured.title, 'Updated Title');
      expect(captured.ownerUid, 'uid-123');
      expect(captured.category, 'technology');
    });
  });
}
