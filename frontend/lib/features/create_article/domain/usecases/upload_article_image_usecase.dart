import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/upload_article_image_params.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';

/// Uploads an article thumbnail image to Cloud Storage.
///
/// Returns a [DataState<String>] containing the download URL on success,
/// or an [AppException] on failure.
class UploadArticleImageUseCase
    implements UseCase<DataState<String>, UploadArticleImageParams> {
  final CreateArticleRepository _repository;

  UploadArticleImageUseCase(this._repository);

  @override
  Future<DataState<String>> call({UploadArticleImageParams? params}) {
    return _repository.uploadArticleImage(params!.imageFile);
  }
}
