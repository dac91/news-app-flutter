import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

class MockGetSavedArticleUseCase extends Mock
    implements GetSavedArticleUseCase {}

class MockSaveArticleUseCase extends Mock implements SaveArticleUseCase {}

class MockRemoveArticleUseCase extends Mock implements RemoveArticleUseCase {}

class FakeArticleEntity extends Fake implements ArticleEntity {}

void main() {
  late LocalArticleBloc bloc;
  late MockGetSavedArticleUseCase mockGetSaved;
  late MockSaveArticleUseCase mockSave;
  late MockRemoveArticleUseCase mockRemove;

  setUpAll(() {
    registerFallbackValue(FakeArticleEntity());
  });

  setUp(() {
    mockGetSaved = MockGetSavedArticleUseCase();
    mockSave = MockSaveArticleUseCase();
    mockRemove = MockRemoveArticleUseCase();
    bloc = LocalArticleBloc(mockGetSaved, mockSave, mockRemove);
  });

  tearDown(() {
    bloc.close();
  });

  const tArticle = ArticleEntity(
    id: 1,
    title: 'Saved Article',
    author: 'Author',
  );

  group('LocalArticleBloc', () {
    test('initial state is LocalArticlesLoading', () {
      expect(bloc.state, isA<LocalArticlesLoading>());
    });

    test('emits LocalArticlesDone on GetSavedArticles success', () async {
      // Arrange
      when(() => mockGetSaved()).thenAnswer((_) async => [tArticle]);

      final states = <LocalArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const GetSavedArticles());
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert
      expect(states.last, isA<LocalArticlesDone>());
      expect(states.last.articles, hasLength(1));
      expect(states.last.articles!.first.title, equals('Saved Article'));
    });

    test('emits LocalArticlesError on GetSavedArticles failure', () async {
      // Arrange
      when(() => mockGetSaved()).thenThrow(Exception('DB read failed'));

      final states = <LocalArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const GetSavedArticles());
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert
      expect(states.last, isA<LocalArticlesError>());
      final errorState = states.last as LocalArticlesError;
      expect(errorState.error.message, contains('DB read failed'));
    });

    test('SaveArticle event saves then reloads articles', () async {
      // Arrange
      when(() => mockSave(params: any(named: 'params')))
          .thenAnswer((_) async {});
      when(() => mockGetSaved()).thenAnswer((_) async => [tArticle]);

      final states = <LocalArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const SaveArticle(tArticle));
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert
      verify(() => mockSave(params: tArticle)).called(1);
      verify(() => mockGetSaved()).called(1);
      expect(states.last, isA<LocalArticlesDone>());
    });

    test('RemoveArticle event removes then reloads articles', () async {
      // Arrange
      when(() => mockRemove(params: any(named: 'params')))
          .thenAnswer((_) async {});
      when(() => mockGetSaved()).thenAnswer((_) async => []);

      final states = <LocalArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const RemoveArticle(tArticle));
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert
      verify(() => mockRemove(params: tArticle)).called(1);
      verify(() => mockGetSaved()).called(1);
      expect(states.last, isA<LocalArticlesDone>());
      expect(states.last.articles, isEmpty);
    });

    test('emits LocalArticlesError when SaveArticle fails', () async {
      // Arrange
      when(() => mockSave(params: any(named: 'params')))
          .thenThrow(Exception('Save failed'));

      final states = <LocalArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const SaveArticle(tArticle));
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert
      expect(states.last, isA<LocalArticlesError>());
    });

    test('emits LocalArticlesError when RemoveArticle fails', () async {
      // Arrange
      when(() => mockRemove(params: any(named: 'params')))
          .thenThrow(Exception('Remove failed'));

      final states = <LocalArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const RemoveArticle(tArticle));
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert
      expect(states.last, isA<LocalArticlesError>());
    });
  });
}
