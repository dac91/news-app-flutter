import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
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


  void onGetSavedArticles(GetSavedArticles event,Emitter<LocalArticlesState> emit) async {
    try {
      final articles = await _getSavedArticleUseCase();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      emit(LocalArticlesError(
        AppException(message: e.toString(), identifier: 'getSavedArticles'),
      ));
    }
  }
  
  void onRemoveArticle(RemoveArticle removeArticle,Emitter<LocalArticlesState> emit) async {
    try {
      // Floor's @delete matches by primary key (id). Articles from the API
      // may have id == null, so look up the persisted row by URL first.
      final saved = await _getSavedArticleUseCase();
      final match = saved.where((a) => a.url == removeArticle.article?.url);
      if (match.isNotEmpty) {
        await _removeArticleUseCase(params: match.first);
      }
      final articles = await _getSavedArticleUseCase();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      emit(LocalArticlesError(
        AppException(message: e.toString(), identifier: 'removeArticle'),
      ));
    }
  }

  void onSaveArticle(SaveArticle saveArticle,Emitter<LocalArticlesState> emit) async {
    try {
      // Prevent duplicates — skip if an article with the same URL is already saved.
      final saved = await _getSavedArticleUseCase();
      final alreadySaved = saved.any((a) => a.url == saveArticle.article?.url);
      if (!alreadySaved) {
        await _saveArticleUseCase(params: saveArticle.article);
      }
      final articles = await _getSavedArticleUseCase();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      emit(LocalArticlesError(
        AppException(message: e.toString(), identifier: 'saveArticle'),
      ));
    }
  }
}