import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/get_articles_by_author_usecase.dart';

class MockCreateArticleRepository extends Mock
    implements CreateArticleRepository {}

void main() {
  late GetArticlesByAuthorUseCase useCase;
  late MockCreateArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockCreateArticleRepository();
    useCase = GetArticlesByAuthorUseCase(mockRepository);
  });

  final tArticles = [
    FirebaseArticleEntity(
      id: 'doc-1',
      title: 'Article One',
      description: 'Desc 1',
      content: 'Content 1',
      author: 'John Doe',
      thumbnailUrl: 'https://example.com/1.jpg',
      ownerUid: 'uid-john',
      createdAt: DateTime(2026, 3, 25),
    ),
    FirebaseArticleEntity(
      id: 'doc-2',
      title: 'Article Two',
      description: 'Desc 2',
      content: 'Content 2',
      author: 'John Doe',
      thumbnailUrl: 'https://example.com/2.jpg',
      ownerUid: 'uid-john',
      createdAt: DateTime(2026, 3, 24),
    ),
  ];

  group('GetArticlesByAuthorUseCase', () {
    test('returns DataSuccess with list of articles on success', () async {
      when(() => mockRepository.getArticlesByOwner('uid-john'))
          .thenAnswer((_) async => DataSuccess(tArticles));

      final result = await useCase(params: 'uid-john');

      expect(result, isA<DataSuccess<List<FirebaseArticleEntity>>>());
      expect(result.data!.length, 2);
      expect(result.data!.first.title, 'Article One');
      verify(() => mockRepository.getArticlesByOwner('uid-john')).called(1);
    });

    test('returns DataSuccess with empty list when owner has no articles',
        () async {
      when(() => mockRepository.getArticlesByOwner('uid-unknown'))
          .thenAnswer((_) async => const DataSuccess([]));

      final result = await useCase(params: 'uid-unknown');

      expect(result, isA<DataSuccess<List<FirebaseArticleEntity>>>());
      expect(result.data, isEmpty);
    });

    test('returns DataFailed on repository error', () async {
      const tException = AppException(
        message: 'Firestore error',
        statusCode: 500,
        identifier: 'getArticlesByOwner',
      );
      when(() => mockRepository.getArticlesByOwner('uid-john'))
          .thenAnswer((_) async => const DataFailed(tException));

      final result = await useCase(params: 'uid-john');

      expect(result, isA<DataFailed<List<FirebaseArticleEntity>>>());
      expect(result.error!.message, 'Firestore error');
    });

    test('throws ArgumentError when params is null', () async {
      expect(
        () => useCase(params: null),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError when params is empty string', () async {
      expect(
        () => useCase(params: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
