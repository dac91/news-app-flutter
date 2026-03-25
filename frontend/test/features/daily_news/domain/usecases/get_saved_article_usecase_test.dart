import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late GetSavedArticleUseCase useCase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    useCase = GetSavedArticleUseCase(mockRepository);
  });

  const tArticles = [
    ArticleEntity(
      id: 1,
      author: 'Author 1',
      title: 'Title 1',
      description: 'Desc 1',
    ),
    ArticleEntity(
      id: 2,
      author: 'Author 2',
      title: 'Title 2',
      description: 'Desc 2',
    ),
  ];

  group('GetSavedArticleUseCase', () {
    test('returns list of saved articles on success', () async {
      // Arrange
      when(() => mockRepository.getSavedArticles())
          .thenAnswer((_) async => tArticles);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(tArticles));
      expect(result, hasLength(2));
      verify(() => mockRepository.getSavedArticles()).called(1);
    });

    test('returns empty list when no saved articles', () async {
      // Arrange
      when(() => mockRepository.getSavedArticles())
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
    });

    test('propagates exception from repository', () async {
      // Arrange
      when(() => mockRepository.getSavedArticles())
          .thenThrow(Exception('DB read failed'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
