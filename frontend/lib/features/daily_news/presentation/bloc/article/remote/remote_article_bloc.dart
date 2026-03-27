import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/get_community_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

/// Page size for paginated article fetching.
const int _kPageSize = 20;

class RemoteArticlesBloc
    extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {
  final GetArticleUseCase _getArticleUseCase;
  final GetCommunityArticlesUseCase _getCommunityArticlesUseCase;

  /// Tracks the last query parameters for "load more" requests.
  String? _lastCategory;
  String? _lastQuery;

  RemoteArticlesBloc(this._getArticleUseCase, this._getCommunityArticlesUseCase)
      : super(const RemoteArticlesLoading()) {
    on<GetArticles>(onGetArticles);
    on<LoadMoreArticles>(_onLoadMore);
  }

  void onGetArticles(
      GetArticles event, Emitter<RemoteArticlesState> emit) async {
    emit(const RemoteArticlesLoading());

    _lastCategory = event.category;
    _lastQuery = event.query;

    // Fetch NewsAPI and community articles in parallel.
    final results = await Future.wait([
      _getArticleUseCase(
        params: GetArticleParams(
          category: event.category,
          query: event.query,
          page: 1,
          pageSize: _kPageSize,
        ),
      ),
      _getCommunityArticlesUseCase(),
    ]);

    final newsApiResult = results[0] as DataState<List<ArticleEntity>>;
    final communityResult =
        results[1] as DataState<List<FirebaseArticleEntity>>;

    if (newsApiResult is DataSuccess) {
      final newsArticles = newsApiResult.data ?? [];

      // Convert community articles to ArticleEntity and merge.
      // Community articles are best-effort: if the fetch fails, we
      // still show NewsAPI articles without error.
      // When a search query or category filter is active, filter
      // community articles client-side (Firestore doesn't support
      // full-text search).
      var communityFirebase = communityResult is DataSuccess
          ? (communityResult.data ?? <FirebaseArticleEntity>[])
          : <FirebaseArticleEntity>[];

      if (event.category != null && event.category!.isNotEmpty) {
        final cat = event.category!.toLowerCase();
        communityFirebase = communityFirebase
            .where((a) => a.category?.toLowerCase() == cat)
            .toList();
      }

      if (event.query != null && event.query!.isNotEmpty) {
        final q = event.query!.toLowerCase();
        communityFirebase = communityFirebase
            .where((a) =>
                a.title.toLowerCase().contains(q) ||
                a.description.toLowerCase().contains(q) ||
                a.content.toLowerCase().contains(q))
            .toList();
      }

      final communityArticles =
          communityFirebase.map(_communityToArticleEntity).toList();

      final merged = _mergeByDate(newsArticles, communityArticles);

      emit(RemoteArticlesDone(
        merged,
        currentPage: 1,
        hasReachedMax: newsArticles.length < _kPageSize,
      ));
    }

    if (newsApiResult is DataFailed) {
      emit(RemoteArticlesError(
        newsApiResult.error ??
            const AppException(
              message: 'Unknown error occurred',
              identifier: 'getArticles',
            ),
      ));
    }
  }

  Future<void> _onLoadMore(
      LoadMoreArticles event, Emitter<RemoteArticlesState> emit) async {
    final currentState = state;
    if (currentState is! RemoteArticlesDone) return;
    if (currentState.hasReachedMax || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final dataState = await _getArticleUseCase(
      params: GetArticleParams(
        category: _lastCategory,
        query: _lastQuery,
        page: nextPage,
        pageSize: _kPageSize,
      ),
    );

    if (dataState is DataSuccess) {
      final newArticles = dataState.data ?? <ArticleEntity>[];
      final allArticles = <ArticleEntity>[
        ...(currentState.articles ?? []),
        ...newArticles
      ];
      emit(RemoteArticlesDone(
        allArticles,
        currentPage: nextPage,
        hasReachedMax: newArticles.length < _kPageSize,
      ));
    }

    if (dataState is DataFailed) {
      // On load-more failure, revert to previous state without isLoadingMore
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Converts a [FirebaseArticleEntity] to an [ArticleEntity] so it can be
  /// displayed in the same feed as NewsAPI articles.
  static ArticleEntity _communityToArticleEntity(
    FirebaseArticleEntity firebase,
  ) {
    return ArticleEntity(
      id: firebase.id.hashCode,
      author: firebase.author,
      title: firebase.title,
      description: firebase.description,
      url: null,
      urlToImage: firebase.thumbnailUrl,
      publishedAt: firebase.createdAt?.toIso8601String(),
      content: firebase.content,
    );
  }

  /// Merges two lists of articles by [publishedAt] date (newest first).
  ///
  /// Articles without a valid date are appended at the end.
  static List<ArticleEntity> _mergeByDate(
    List<ArticleEntity> newsApi,
    List<ArticleEntity> community,
  ) {
    final all = [...newsApi, ...community];
    all.sort((a, b) {
      final aDate = DateTime.tryParse(a.publishedAt ?? '');
      final bDate = DateTime.tryParse(b.publishedAt ?? '');
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate); // newest first
    });
    return all;
  }
}
