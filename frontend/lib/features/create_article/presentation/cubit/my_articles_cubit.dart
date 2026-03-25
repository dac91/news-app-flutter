import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/get_articles_by_author_usecase.dart';

/// States for [MyArticlesCubit].
abstract class MyArticlesState {
  const MyArticlesState();
}

class MyArticlesInitial extends MyArticlesState {
  const MyArticlesInitial();
}

class MyArticlesLoading extends MyArticlesState {
  const MyArticlesLoading();
}

class MyArticlesLoaded extends MyArticlesState {
  final List<FirebaseArticleEntity> articles;
  const MyArticlesLoaded({required this.articles});
}

class MyArticlesError extends MyArticlesState {
  final String message;
  const MyArticlesError({required this.message});
}

/// Cubit that fetches articles authored by the current user.
///
/// Uses [GetArticlesByAuthorUseCase] to query Firestore by author name.
class MyArticlesCubit extends Cubit<MyArticlesState> {
  final GetArticlesByAuthorUseCase _getArticlesByAuthorUseCase;

  MyArticlesCubit({
    required GetArticlesByAuthorUseCase getArticlesByAuthorUseCase,
  })  : _getArticlesByAuthorUseCase = getArticlesByAuthorUseCase,
        super(const MyArticlesInitial());

  /// Fetches articles for the given [authorName].
  Future<void> fetchArticles(String authorName) async {
    if (authorName.isEmpty) return;

    emit(const MyArticlesLoading());

    try {
      final result = await _getArticlesByAuthorUseCase.call(
        params: authorName,
      );

      if (result is DataSuccess<List<FirebaseArticleEntity>>) {
        emit(MyArticlesLoaded(articles: result.data ?? []));
      } else if (result is DataFailed) {
        emit(MyArticlesError(
          message: result.error?.message ?? 'Failed to load articles',
        ));
      }
    } catch (e) {
      emit(MyArticlesError(message: e.toString()));
    }
  }
}
