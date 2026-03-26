import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/get_community_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

class MockGetArticleUseCase extends Mock implements GetArticleUseCase {}

class MockGetCommunityArticlesUseCase extends Mock
    implements GetCommunityArticlesUseCase {}

void main() {
  late RemoteArticlesBloc bloc;
  late MockGetArticleUseCase mockUseCase;
  late MockGetCommunityArticlesUseCase mockCommunityUseCase;

  setUpAll(() {
    registerFallbackValue(const GetArticleParams());
  });

  setUp(() {
    mockUseCase = MockGetArticleUseCase();
    mockCommunityUseCase = MockGetCommunityArticlesUseCase();
    bloc = RemoteArticlesBloc(mockUseCase, mockCommunityUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  const tArticles = [
    ArticleEntity(id: 1, title: 'Article 1', author: 'Author 1'),
    ArticleEntity(id: 2, title: 'Article 2', author: 'Author 2'),
  ];

  /// Helper to stub community use case with an empty success result.
  void stubCommunityEmpty() {
    when(() => mockCommunityUseCase())
        .thenAnswer((_) async => const DataSuccess(<FirebaseArticleEntity>[]));
  }

  group('RemoteArticlesBloc', () {
    test('initial state is RemoteArticlesLoading', () {
      expect(bloc.state, isA<RemoteArticlesLoading>());
    });

    test('emits [Loading, Done] on GetArticles success', () async {
      // Arrange
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataSuccess(tArticles));
      stubCommunityEmpty();

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
      stubCommunityEmpty();

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
      stubCommunityEmpty();

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
      stubCommunityEmpty();

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
      stubCommunityEmpty();

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

    test('merges community articles into feed on GetArticles success',
        () async {
      // Arrange — NewsAPI returns 2 articles with dates
      const newsArticles = [
        ArticleEntity(
          id: 1,
          title: 'News 1',
          publishedAt: '2026-03-25T10:00:00Z',
        ),
        ArticleEntity(
          id: 2,
          title: 'News 2',
          publishedAt: '2026-03-24T10:00:00Z',
        ),
      ];
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataSuccess(newsArticles));

      // Community returns 1 article between the two news articles
      final communityArticles = [
        FirebaseArticleEntity(
          id: 'firebase-1',
          title: 'Community Article',
          description: 'Desc',
          content: 'Content',
          author: 'Community Author',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          ownerUid: 'uid-1',
          createdAt: DateTime.utc(2026, 3, 24, 18, 0, 0),
        ),
      ];
      when(() => mockCommunityUseCase())
          .thenAnswer((_) async => DataSuccess(communityArticles));

      final states = <RemoteArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const GetArticles());
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert — 3 articles total, sorted by date newest first
      final doneState = states.last as RemoteArticlesDone;
      expect(doneState.articles, hasLength(3));
      expect(doneState.articles![0].title, equals('News 1'));
      expect(doneState.articles![1].title, equals('Community Article'));
      expect(doneState.articles![2].title, equals('News 2'));
    });

    test(
        'shows NewsAPI articles even when community articles fetch fails',
        () async {
      // Arrange
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataSuccess(tArticles));
      when(() => mockCommunityUseCase()).thenAnswer(
        (_) async => const DataFailed(AppException(
          message: 'Firestore error',
          identifier: 'getAllArticles',
        )),
      );

      final states = <RemoteArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const GetArticles());
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert — still succeeds with NewsAPI articles only
      final doneState = states.last as RemoteArticlesDone;
      expect(doneState.articles, hasLength(2));
    });

    test('community article conversion maps fields correctly', () async {
      // Arrange
      const newsArticles = <ArticleEntity>[];
      when(() => mockUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const DataSuccess(newsArticles));

      final communityArticles = [
        FirebaseArticleEntity(
          id: 'fb-id-123',
          title: 'My Article',
          description: 'My Description',
          content: 'My Content',
          author: 'Jane Doe',
          thumbnailUrl: 'https://storage.example.com/thumb.jpg',
          ownerUid: 'uid-jane',
          category: 'tech',
          createdAt: DateTime.utc(2026, 3, 25, 12, 0, 0),
        ),
      ];
      when(() => mockCommunityUseCase())
          .thenAnswer((_) async => DataSuccess(communityArticles));

      final states = <RemoteArticlesState>[];
      bloc.stream.listen(states.add);

      // Act
      bloc.add(const GetArticles());
      await Future.delayed(const Duration(milliseconds: 300));

      // Assert — verify field mapping
      final doneState = states.last as RemoteArticlesDone;
      expect(doneState.articles, hasLength(1));
      final converted = doneState.articles!.first;
      expect(converted.id, equals('fb-id-123'.hashCode));
      expect(converted.author, equals('Jane Doe'));
      expect(converted.title, equals('My Article'));
      expect(converted.description, equals('My Description'));
      expect(converted.content, equals('My Content'));
      expect(converted.url, isNull);
      expect(
        converted.urlToImage,
        equals('https://storage.example.com/thumb.jpg'),
      );
      expect(converted.publishedAt, equals('2026-03-25T12:00:00.000Z'));
    });
  });
}
