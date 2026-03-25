import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/get_articles_by_author_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/my_articles_cubit.dart';

class MockGetArticlesByAuthorUseCase extends Mock
    implements GetArticlesByAuthorUseCase {}

void main() {
  late MyArticlesCubit cubit;
  late MockGetArticlesByAuthorUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetArticlesByAuthorUseCase();
    cubit = MyArticlesCubit(getArticlesByAuthorUseCase: mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  final tArticles = [
    FirebaseArticleEntity(
      id: 'doc-1',
      title: 'Article One',
      description: 'Desc 1',
      content: 'Content 1',
      author: 'John Doe',
      thumbnailUrl: 'https://example.com/1.jpg',
      createdAt: DateTime(2026, 3, 25),
    ),
    FirebaseArticleEntity(
      id: 'doc-2',
      title: 'Article Two',
      description: 'Desc 2',
      content: 'Content 2',
      author: 'John Doe',
      thumbnailUrl: 'https://example.com/2.jpg',
      createdAt: DateTime(2026, 3, 24),
    ),
  ];

  group('MyArticlesCubit', () {
    test('initial state is MyArticlesInitial', () {
      expect(cubit.state, isA<MyArticlesInitial>());
    });

    test('emits [Loading, Loaded] on successful fetch', () async {
      when(() => mockUseCase.call(params: 'John Doe'))
          .thenAnswer((_) async => DataSuccess(tArticles));

      final states = <MyArticlesState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.fetchArticles('John Doe');
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0], isA<MyArticlesLoading>());
      expect(states[1], isA<MyArticlesLoaded>());
      expect((states[1] as MyArticlesLoaded).articles.length, 2);

      await subscription.cancel();
    });

    test('emits [Loading, Loaded] with empty list when no articles', () async {
      when(() => mockUseCase.call(params: 'Nobody'))
          .thenAnswer((_) async => const DataSuccess([]));

      final states = <MyArticlesState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.fetchArticles('Nobody');
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0], isA<MyArticlesLoading>());
      expect(states[1], isA<MyArticlesLoaded>());
      expect((states[1] as MyArticlesLoaded).articles, isEmpty);

      await subscription.cancel();
    });

    test('emits [Loading, Error] on failure', () async {
      const tException = AppException(
        message: 'Network error',
        identifier: 'getArticlesByAuthor',
      );
      when(() => mockUseCase.call(params: 'John Doe'))
          .thenAnswer((_) async => const DataFailed(tException));

      final states = <MyArticlesState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.fetchArticles('John Doe');
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0], isA<MyArticlesLoading>());
      expect(states[1], isA<MyArticlesError>());
      expect((states[1] as MyArticlesError).message, 'Network error');

      await subscription.cancel();
    });

    test('does not emit when authorName is empty', () async {
      final states = <MyArticlesState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.fetchArticles('');
      await Future<void>.delayed(Duration.zero);

      expect(states, isEmpty);

      await subscription.cancel();
    });

    test('handles exception thrown by use case', () async {
      when(() => mockUseCase.call(params: 'John Doe'))
          .thenThrow(Exception('Unexpected'));

      final states = <MyArticlesState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.fetchArticles('John Doe');
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0], isA<MyArticlesLoading>());
      expect(states[1], isA<MyArticlesError>());

      await subscription.cancel();
    });
  });
}
