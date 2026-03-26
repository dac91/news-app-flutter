import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/create_article_params.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';

/// Creates a new article in Firestore.
///
/// Accepts [CreateArticleParams] containing the article fields (title,
/// description, content, author, thumbnailUrl) and delegates to the
/// [CreateArticleRepository] for persistence.
class CreateArticleUseCase
    implements UseCase<DataState<FirebaseArticleEntity>, CreateArticleParams> {
  final CreateArticleRepository _repository;

  CreateArticleUseCase(this._repository);

  @override
  Future<DataState<FirebaseArticleEntity>> call({
    CreateArticleParams? params,
  }) {
    return _repository.createArticle(
      FirebaseArticleEntity(
        title: params!.title,
        description: params.description,
        content: params.content,
        author: params.author,
        thumbnailUrl: params.thumbnailUrl,
        ownerUid: params.ownerUid,
        category: params.category,
      ),
    );
  }
}
