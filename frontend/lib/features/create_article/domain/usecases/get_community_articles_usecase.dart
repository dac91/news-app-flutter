import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';

/// Use case for fetching all community-published articles (newest first).
///
/// Used by [RemoteArticlesBloc] to merge Firestore articles into the
/// Home feed alongside NewsAPI articles.
class GetCommunityArticlesUseCase
    implements UseCase<DataState<List<FirebaseArticleEntity>>, void> {
  final CreateArticleRepository _repository;

  GetCommunityArticlesUseCase(this._repository);

  @override
  Future<DataState<List<FirebaseArticleEntity>>> call({
    void params,
  }) {
    return _repository.getAllArticles();
  }
}
