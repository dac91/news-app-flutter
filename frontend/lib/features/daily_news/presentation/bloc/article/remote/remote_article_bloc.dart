import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

/// Page size for paginated article fetching.
const int _kPageSize = 20;

class RemoteArticlesBloc
    extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {
  final GetArticleUseCase _getArticleUseCase;

  /// Tracks the last query parameters for "load more" requests.
  String? _lastCategory;
  String? _lastQuery;

  RemoteArticlesBloc(this._getArticleUseCase)
      : super(const RemoteArticlesLoading()) {
    on<GetArticles>(onGetArticles);
    on<LoadMoreArticles>(_onLoadMore);
  }

  void onGetArticles(
      GetArticles event, Emitter<RemoteArticlesState> emit) async {
    emit(const RemoteArticlesLoading());

    _lastCategory = event.category;
    _lastQuery = event.query;

    final dataState = await _getArticleUseCase(
      params: GetArticleParams(
        category: event.category,
        query: event.query,
        page: 1,
        pageSize: _kPageSize,
      ),
    );

    if (dataState is DataSuccess) {
      final articles = dataState.data ?? [];
      emit(RemoteArticlesDone(
        articles,
        currentPage: 1,
        hasReachedMax: articles.length < _kPageSize,
      ));
    }

    if (dataState is DataFailed) {
      emit(RemoteArticlesError(
        dataState.error ??
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
      final newArticles = dataState.data ?? [];
      final allArticles = [...(currentState.articles ?? []), ...newArticles];
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
}
