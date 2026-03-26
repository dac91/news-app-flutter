import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/create_article_params.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/upload_article_image_params.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/create_article_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/update_article_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/upload_article_image_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/create_article_state.dart';

/// Cubit managing the "Create/Edit Article" screen's state transitions.
///
/// Uses [UploadArticleImageUseCase], [CreateArticleUseCase], and
/// [UpdateArticleUseCase] to handle create and edit flows.
///
/// Chosen over Bloc because the create-article flow is form-driven
/// (method calls) rather than event-driven (discrete events).
///
/// Also holds transient UI state ([selectedImage], [uploadedImageUrl],
/// [selectedCategory]) as plain fields so that the page widget never
/// needs to call `setState` — all rebuilds flow through [BlocBuilder].
class CreateArticleCubit extends Cubit<CreateArticleState> {
  final UploadArticleImageUseCase _uploadImageUseCase;
  final CreateArticleUseCase _createArticleUseCase;
  final UpdateArticleUseCase? _updateArticleUseCase;

  CreateArticleCubit({
    required UploadArticleImageUseCase uploadImageUseCase,
    required CreateArticleUseCase createArticleUseCase,
    UpdateArticleUseCase? updateArticleUseCase,
  })  : _uploadImageUseCase = uploadImageUseCase,
        _createArticleUseCase = createArticleUseCase,
        _updateArticleUseCase = updateArticleUseCase,
        super(const CreateArticleInitial());

  // ---------------------------------------------------------------------------
  // Transient UI fields — not part of [CreateArticleState] because they
  // represent ephemeral widget state (selected file, chosen category) rather
  // than domain/flow state.  Stored here so the page can avoid `setState`.
  // ---------------------------------------------------------------------------

  /// The locally-picked image file (before or during upload).
  File? selectedImage;

  /// The Cloud Storage download URL after a successful upload.
  String? uploadedImageUrl;

  /// The category chosen from the dropdown.
  String? selectedCategory;

  /// Sets [selectedImage], clears [uploadedImageUrl], and triggers an
  /// upload. Called after the user picks a file from gallery/camera.
  Future<void> pickAndUploadImage(File imageFile) async {
    selectedImage = imageFile;
    uploadedImageUrl = null;
    emit(const CreateArticleImageUploading());

    final result = await _uploadImageUseCase.call(
      params: UploadArticleImageParams(imageFile: imageFile),
    );

    if (result is DataSuccess<String>) {
      uploadedImageUrl = result.data!;
      emit(CreateArticleImageUploaded(imageUrl: result.data!));
    } else if (result is DataFailed<String>) {
      emit(CreateArticleError(error: result.error!));
    }
  }

  /// Uploads a thumbnail image to Cloud Storage (legacy method signature).
  ///
  /// Transitions: Initial/Error -> ImageUploading -> ImageUploaded | Error
  Future<void> uploadImage(File imageFile) async {
    emit(const CreateArticleImageUploading());

    final result = await _uploadImageUseCase.call(
      params: UploadArticleImageParams(imageFile: imageFile),
    );

    if (result is DataSuccess<String>) {
      uploadedImageUrl = result.data!;
      emit(CreateArticleImageUploaded(imageUrl: result.data!));
    } else if (result is DataFailed<String>) {
      emit(CreateArticleError(error: result.error!));
    }
  }

  /// Restores [uploadedImageUrl] from a saved draft.
  void restoreDraftImageUrl(String? url) {
    uploadedImageUrl = url;
  }

  /// Submits a new article to Firestore.
  ///
  /// Requires an image URL (from a prior successful upload).
  /// Transitions: ImageUploaded/Error(with imageUrl) -> Submitting -> Success | Error
  Future<void> submitArticle({
    required String title,
    required String description,
    required String content,
    required String author,
    required String imageUrl,
    String? category,
  }) async {
    emit(CreateArticleSubmitting(imageUrl: imageUrl));

    final result = await _createArticleUseCase.call(
      params: CreateArticleParams(
        title: title,
        description: description,
        content: content,
        author: author,
        thumbnailUrl: imageUrl,
        category: category,
      ),
    );

    if (result is DataSuccess) {
      emit(CreateArticleSuccess(article: result.data!));
    } else if (result is DataFailed) {
      uploadedImageUrl = imageUrl;
      emit(CreateArticleError(error: result.error!, imageUrl: imageUrl));
    }
  }

  /// Updates an existing article in Firestore.
  ///
  /// Requires the article's [id] to identify the document.
  Future<void> updateArticle({
    required String id,
    required String title,
    required String description,
    required String content,
    required String author,
    required String imageUrl,
    String? category,
    DateTime? createdAt,
  }) async {
    if (_updateArticleUseCase == null) return;

    emit(CreateArticleSubmitting(imageUrl: imageUrl));

    final entity = FirebaseArticleEntity(
      id: id,
      title: title,
      description: description,
      content: content,
      author: author,
      thumbnailUrl: imageUrl,
      category: category,
      createdAt: createdAt,
    );

    final result = await _updateArticleUseCase.call(params: entity);

    if (result is DataSuccess) {
      emit(CreateArticleSuccess(article: result.data!));
    } else if (result is DataFailed) {
      uploadedImageUrl = imageUrl;
      emit(CreateArticleError(error: result.error!, imageUrl: imageUrl));
    }
  }

  /// Resets to initial state (e.g. after successful creation or cancel).
  void reset() {
    selectedImage = null;
    uploadedImageUrl = null;
    selectedCategory = null;
    emit(const CreateArticleInitial());
  }
}
