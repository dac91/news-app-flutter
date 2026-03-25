import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

class MockGetArticleUseCase extends Mock implements GetArticleUseCase {}

void main() {
  late RemoteArticlesBloc bloc;
  late MockGetArticleUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(const GetArticleParams());
  });

  setUp(() {
    mockUseCase = MockGetArticleUseCase();
    bloc = RemoteArticlesBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  const tArticles = [
    ArticleEntity(id: 1, title: 'Article 1', author: 'Author 1'),
    ArticleEntity(id: 2, title: 'Article 2', author: 'Author 2'),
  ];

  group('RemoteArticlesBloc', () {
    test('initial state is RemoteArticlesLoading', () {
      expect(bloc.state, isA<RemoteArticlesLoading>());
    });

    test('emits [Loading, Done] on GetArticles success', () async {
      // Arrange
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataSuccess(tArticles));

      final states = <RemoteArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const GetArticles());
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert
      expect(states.length, greaterThanOrEqualTo(2));
      expect(states[0], isA<RemoteArticlesLoading>());
      expect(states[1], isA<RemoteArticlesDone>());
      expect((states[1] as RemoteArticlesDone).articles, hasLength(2));
      expect((states[1] as RemoteArticlesDone).currentPage, equals(1));
    });

    test('emits [Loading, Error] on GetArticles failure', () async {
      // Arrange
      const tException = AppException(
        message: 'Network error',
        identifier: 'getArticles',
      );
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataFailed(tException));

      final states = <RemoteArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const GetArticles());
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert
      expect(states.length, greaterThanOrEqualTo(2));
      expect(states[0], isA<RemoteArticlesLoading>());
      expect(states[1], isA<RemoteArticlesError>());
      expect((states[1] as RemoteArticlesError).error!.message,
          equals('Network error'));
    });

    test('passes category and query to use case', () async {
      // Arrange
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataSuccess(tArticles));

      // Act
      bloc.add(const GetArticles(category: 'technology', query: 'AI'));
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert
      final captured = verify(
        () => mockUseCase(params: captureAny(named: 'params')),
      ).captured.single as GetArticleParams;
      expect(captured.category, equals('technology'));
      expect(captured.query, equals('AI'));
      expect(captured.page, equals(1));
    });

    test('hasReachedMax is true when fewer articles than page size returned',
        () async {
      // Arrange — return fewer than _kPageSize (20)
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataSuccess(tArticles));

      final states = <RemoteArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const GetArticles());
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert — 2 articles < 20 → hasReachedMax
      final doneState = states.last as RemoteArticlesDone;
      expect(doneState.hasReachedMax, isTrue);
    });

    test('LoadMoreArticles appends articles and increments page', () async {
      // Arrange — first load returns full page (20 articles)
      final fullPage = List.generate(
        20,
        (i) => ArticleEntity(id: i, title: 'Article $i'),
      );
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => DataSuccess(fullPage));

      final states = <RemoteArticlesState>[];
      bloc.stream.listen(states.add);

      bloc.add(const GetArticles());
      await Future.delayed(const Duration(milliseconds: 300));

      // Verify first load: not reached max
      expect((states.last as RemoteArticlesDone).hasReachedMax, isFalse);

      // Arrange — second page returns partial results
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataSuccess(tArticles));

      // Act
      bloc.add(const LoadMoreArticles());
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert
      final finalState = states.last as RemoteArticlesDone;
      expect(finalState.articles, hasLength(22)); // 20 + 2
      expect(finalState.currentPage, equals(2));
      expect(finalState.hasReachedMax, isTrue);
    });
  });
}
