import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

class FakeArticleEntity extends Fake implements ArticleEntity {}

void main() {
  late SaveArticleUseCase useCase;
  late MockArticleRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeArticleEntity());
  });

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = SaveArticleUseCase(mockRepository);
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

  group('SaveArticleUseCase', () {
    test('calls repository.saveArticle with correct entity', () async {
      // Arrange
      when(() => mockRepository.saveArticle(any()))
          .thenAnswer((_) async {});

      // Act
      await useCase(params: tArticle);

      // Assert
      verify(() => mockRepository.saveArticle(tArticle)).called(1);
    });

    test('throws ArgumentError when params is null', () async {
      // Act & Assert
      expect(
        () => useCase(params: null),
        throwsA(isA<ArgumentError>()),
      );
      verifyNever(() => mockRepository.saveArticle(any()));
    });

    test('propagates exception from repository', () async {
      // Arrange
      when(() => mockRepository.saveArticle(any()))
          .thenThrow(Exception('DB write failed'));

      // Act & Assert
      expect(
        () => useCase(params: tArticle),
        throwsA(isA<Exception>()),
      );
    });
  });
}
