import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/get_community_articles_usecase.dart';

class MockCreateArticleRepository extends Mock
    implements CreateArticleRepository {}

void main() {
  late GetCommunityArticlesUseCase useCase;
  late MockCreateArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockCreateArticleRepository();
    useCase = GetCommunityArticlesUseCase(mockRepository);
  });

  final tArticles = [
    FirebaseArticleEntity(
      id: 'doc-1',
      title: 'Community Article One',
      description: 'Desc 1',
      content: 'Content 1',
      author: 'Alice',
      thumbnailUrl: 'https://example.com/1.jpg',
      ownerUid: 'uid-alice',
      createdAt: DateTime(2026, 3, 25),
    ),
    FirebaseArticleEntity(
      id: 'doc-2',
      title: 'Community Article Two',
      description: 'Desc 2',
      content: 'Content 2',
      author: 'Bob',
      thumbnailUrl: 'https://example.com/2.jpg',
      ownerUid: 'uid-bob',
      createdAt: DateTime(2026, 3, 24),
    ),
  ];

  group('GetCommunityArticlesUseCase', () {
    test('returns DataSuccess with list of all community articles', () async {
      when(() => mockRepository.getAllArticles())
          .thenAnswer((_) async => DataSuccess(tArticles));

      final result = await useCase();

      expect(result, isA<DataSuccess<List<FirebaseArticleEntity>>>());
      expect(result.data!.length, 2);
      expect(result.data!.first.title, 'Community Article One');
      verify(() => mockRepository.getAllArticles()).called(1);
    });

    test('returns DataSuccess with empty list when no articles exist',
        () async {
      when(() => mockRepository.getAllArticles())
          .thenAnswer((_) async => const DataSuccess([]));

      final result = await useCase();

      expect(result, isA<DataSuccess<List<FirebaseArticleEntity>>>());
      expect(result.data, isEmpty);
    });

    test('returns DataFailed on repository error', () async {
      const tException = AppException(
        message: 'Firestore error',
        statusCode: 500,
        identifier: 'getAllArticles',
      );
      when(() => mockRepository.getAllArticles())
          .thenAnswer((_) async => const DataFailed(tException));

      final result = await useCase();

      expect(result, isA<DataFailed<List<FirebaseArticleEntity>>>());
      expect(result.error!.message, 'Firestore error');
    });
  });
}
