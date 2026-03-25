import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

class FakeArticleEntity extends Fake implements ArticleEntity {}

void main() {
  late RemoveArticleUseCase useCase;
  late MockArticleRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeArticleEntity());
  });

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = RemoveArticleUseCase(mockRepository);
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

  group('RemoveArticleUseCase', () {
    test('calls repository.removeArticle with correct entity', () async {
      // Arrange
      when(() => mockRepository.removeArticle(any()))
          .thenAnswer((_) async {});

      // Act
      await useCase(params: tArticle);

      // Assert
      verify(() => mockRepository.removeArticle(tArticle)).called(1);
    });

    test('throws ArgumentError when params is null', () async {
      // Act & Assert
      expect(
        () => useCase(params: null),
        throwsA(isA<ArgumentError>()),
      );
      verifyNever(() => mockRepository.removeArticle(any()));
    });

    test('propagates exception from repository', () async {
      // Arrange
      when(() => mockRepository.removeArticle(any()))
          .thenThrow(Exception('DB delete failed'));

      // Act & Assert
      expect(
        () => useCase(params: tArticle),
        throwsA(isA<Exception>()),
      );
    });
  });
}
