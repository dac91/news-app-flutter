import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/create_article_params.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/upload_article_image_params.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/create_article_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/upload_article_image_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/create_article_state.dart';

/// Cubit managing the "Create Article" screen's state transitions.
///
/// Uses [UploadArticleImageUseCase] and [CreateArticleUseCase] to handle
/// the two-step flow: upload image → submit article.
///
/// Chosen over Bloc because the create-article flow is form-driven
/// (method calls) rather than event-driven (discrete events).
class CreateArticleCubit extends Cubit<CreateArticleState> {
  final UploadArticleImageUseCase _uploadImageUseCase;
  final CreateArticleUseCase _createArticleUseCase;

  CreateArticleCubit({
    required UploadArticleImageUseCase uploadImageUseCase,
    required CreateArticleUseCase createArticleUseCase,
  })  : _uploadImageUseCase = uploadImageUseCase,
        _createArticleUseCase = createArticleUseCase,
        super(const CreateArticleInitial());

  /// Uploads a thumbnail image to Cloud Storage.
  ///
  /// Transitions: Initial/Error → ImageUploading → ImageUploaded | Error
  Future<void> uploadImage(File imageFile) async {
    emit(const CreateArticleImageUploading());

    final result = await _uploadImageUseCase.call(
      params: UploadArticleImageParams(imageFile: imageFile),
    );

    if (result is DataSuccess<String>) {
      emit(CreateArticleImageUploaded(imageUrl: result.data!));
    } else if (result is DataFailed<String>) {
      emit(CreateArticleError(error: result.error!));
    }
  }

  /// Submits the article to Firestore.
  ///
  /// Requires an image URL (from a prior successful upload).
  /// Transitions: ImageUploaded/Error(with imageUrl) → Submitting → Success | Error
  Future<void> submitArticle({
    required String title,
    required String description,
    required String content,
    required String author,
    required String imageUrl,
  }) async {
    emit(CreateArticleSubmitting(imageUrl: imageUrl));

    final result = await _createArticleUseCase.call(
      params: CreateArticleParams(
        title: title,
        description: description,
        content: content,
        author: author,
        thumbnailUrl: imageUrl,
      ),
    );

    if (result is DataSuccess) {
      emit(CreateArticleSuccess(article: result.data!));
    } else if (result is DataFailed) {
      emit(CreateArticleError(error: result.error!, imageUrl: imageUrl));
    }
  }

  /// Resets to initial state (e.g. after successful creation or cancel).
  void reset() {
    emit(const CreateArticleInitial());
  }
}
