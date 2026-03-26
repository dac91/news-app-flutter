import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
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
    test('returns DataSuccess with list of saved articles on success', () async {
      // Arrange
      when(() => mockRepository.getSavedArticles())
          .thenAnswer((_) async => const DataSuccess(tArticles));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<DataSuccess<List<ArticleEntity>>>());
      expect((result as DataSuccess).data, equals(tArticles));
      expect(result.data, hasLength(2));
      verify(() => mockRepository.getSavedArticles()).called(1);
    });

    test('returns DataSuccess with empty list when no saved articles', () async {
      // Arrange
      when(() => mockRepository.getSavedArticles())
          .thenAnswer((_) async => const DataSuccess(<ArticleEntity>[]));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<DataSuccess<List<ArticleEntity>>>());
      expect((result as DataSuccess).data, isEmpty);
    });

    test('returns DataFailed when repository fails', () async {
      // Arrange
      const error = AppException(
        message: 'DB read failed',
        identifier: 'getSavedArticles',
      );
      when(() => mockRepository.getSavedArticles())
          .thenAnswer((_) async => const DataFailed(error));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<DataFailed<List<ArticleEntity>>>());
      expect((result as DataFailed).error?.message, 'DB read failed');
    });
  });
}
