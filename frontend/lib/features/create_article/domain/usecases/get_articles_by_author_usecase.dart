import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';

/// Use case for fetching all articles owned by a specific user (by UID).
class GetArticlesByAuthorUseCase
    implements
        UseCase<DataState<List<FirebaseArticleEntity>>, String> {
  final CreateArticleRepository _repository;

  GetArticlesByAuthorUseCase(this._repository);

  @override
  Future<DataState<List<FirebaseArticleEntity>>> call({
    String? params,
  }) {
    if (params == null || params.isEmpty) {
      throw ArgumentError('Owner UID cannot be null or empty');
    }
    return _repository.getArticlesByOwner(params);
  }
}
