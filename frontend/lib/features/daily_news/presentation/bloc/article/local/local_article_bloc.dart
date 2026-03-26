import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

import '../../../../domain/usecases/get_saved_article.dart';
import '../../../../domain/usecases/remove_article.dart';
import '../../../../domain/usecases/save_article.dart';

class LocalArticleBloc extends Bloc<LocalArticlesEvent,LocalArticlesState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  LocalArticleBloc(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase
  ) : super(const LocalArticlesLoading()){
    on <GetSavedArticles> (onGetSavedArticles);
    on <RemoveArticle> (onRemoveArticle);
    on <SaveArticle> (onSaveArticle);
  }

  /// Helper that calls the use case and unwraps the [DataState].
  ///
  /// Returns the article list on success, or throws an [AppException] on
  /// failure so callers can catch it uniformly.
  Future<List<ArticleEntity>> _fetchSavedArticles() async {
    final result = await _getSavedArticleUseCase();
    if (result is DataSuccess<List<ArticleEntity>>) {
      return result.data!;
    }
    throw (result as DataFailed).error ??
        const AppException(
          message: 'Failed to load saved articles',
          identifier: 'getSavedArticles',
        );
  }

  void onGetSavedArticles(GetSavedArticles event,Emitter<LocalArticlesState> emit) async {
    try {
      final articles = await _fetchSavedArticles();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      final error = e is AppException
          ? e
          : AppException(message: e.toString(), identifier: 'getSavedArticles');
      emit(LocalArticlesError(error));
    }
  }
  
  void onRemoveArticle(RemoveArticle removeArticle,Emitter<LocalArticlesState> emit) async {
    try {
      // Floor's @delete matches by primary key (id). Articles from the API
      // may have id == null, so look up the persisted row by URL first.
      final saved = await _fetchSavedArticles();
      final match = saved.where((a) => a.url == removeArticle.article?.url);
      if (match.isNotEmpty) {
        await _removeArticleUseCase(params: match.first);
      }
      final articles = await _fetchSavedArticles();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      final error = e is AppException
          ? e
          : AppException(message: e.toString(), identifier: 'removeArticle');
      emit(LocalArticlesError(error));
    }
  }

  void onSaveArticle(SaveArticle saveArticle,Emitter<LocalArticlesState> emit) async {
    try {
      // Prevent duplicates — skip if an article with the same URL is already saved.
      final saved = await _fetchSavedArticles();
      final alreadySaved = saved.any((a) => a.url == saveArticle.article?.url);
      if (!alreadySaved) {
        await _saveArticleUseCase(params: saveArticle.article);
      }
      final articles = await _fetchSavedArticles();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      final error = e is AppException
          ? e
          : AppException(message: e.toString(), identifier: 'saveArticle');
      emit(LocalArticlesError(error));
    }
  }
}