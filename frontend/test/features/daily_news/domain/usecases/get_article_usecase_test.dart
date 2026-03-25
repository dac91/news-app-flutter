import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late GetArticleUseCase useCase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = GetArticleUseCase(mockRepository);
  });

  const tArticle = ArticleEntity(
    id: 1,
    author: 'Author',
    title: 'Test Title',
    description: 'Test Description',
    url: 'https://example.com',
    urlToImage: 'https://example.com/image.jpg',
    publishedAt: '2026-03-25',
    content: 'Test Content',
  );

  group('GetArticleUseCase', () {
    test('returns DataSuccess with list of articles on success', () async {
      // Arrange
      when(() => mockRepository.getNewsArticles(
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenAnswer((_) async => const DataSuccess([tArticle]));

      // Act
      final result = await useCase(
        params: const GetArticleParams(category: 'technology', page: 1, pageSize: 20),
      );

      // Assert
      expect(result, isA<DataSuccess<List<ArticleEntity>>>());
      expect(result.data, hasLength(1));
      expect(result.data!.first.title, equals('Test Title'));
    });

    test('returns DataFailed with AppException on failure', () async {
      // Arrange
      const tException = AppException(
        message: 'Network error',
        statusCode: 500,
        identifier: 'getArticles',
      );
      when(() => mockRepository.getNewsArticles(
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenAnswer((_) async => const DataFailed(tException));

      // Act
      final result = await useCase(
        params: const GetArticleParams(category: 'technology'),
      );

      // Assert
      expect(result, isA<DataFailed<List<ArticleEntity>>>());
      expect(result.error!.message, equals('Network error'));
    });

    test('returns DataSuccess with empty list when no articles', () async {
      // Arrange
      when(() => mockRepository.getNewsArticles(
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenAnswer((_) async => const DataSuccess([]));

      // Act
      final result = await useCase(params: null);

      // Assert
      expect(result, isA<DataSuccess<List<ArticleEntity>>>());
      expect(result.data, isEmpty);
    });

    test('passes correct params to repository', () async {
      // Arrange
      when(() => mockRepository.getNewsArticles(
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenAnswer((_) async => const DataSuccess([tArticle]));

      // Act
      await useCase(
        params: const GetArticleParams(
          category: 'science',
          query: 'mars',
          page: 2,
          pageSize: 10,
        ),
      );

      // Assert
      verify(() => mockRepository.getNewsArticles(
            category: 'science',
            query: 'mars',
            page: 2,
            pageSize: 10,
          )).called(1);
    });
  });
}
