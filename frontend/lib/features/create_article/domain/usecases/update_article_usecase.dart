import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';

/// Use case for updating an existing article in Firestore.
class UpdateArticleUseCase
    implements UseCase<DataState<FirebaseArticleEntity>, FirebaseArticleEntity> {
  final CreateArticleRepository _repository;

  UpdateArticleUseCase(this._repository);

  @override
  Future<DataState<FirebaseArticleEntity>> call({
    FirebaseArticleEntity? params,
  }) {
    if (params == null) {
      throw ArgumentError('FirebaseArticleEntity cannot be null');
    }
    return _repository.updateArticle(params);
  }
}
