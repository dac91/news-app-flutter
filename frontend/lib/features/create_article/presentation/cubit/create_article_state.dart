import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';

/// States for the article creation flow.
///
/// The flow is: Initial → ImageUploading → ImageUploaded → Submitting → Success
/// Any state can transition to Error, which preserves the failed state's
/// image URL (if any) so the user doesn't lose progress.
abstract class CreateArticleState extends Equatable {
  const CreateArticleState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no image selected, form empty.
class CreateArticleInitial extends CreateArticleState {
  const CreateArticleInitial();
}

/// Image is being uploaded to Cloud Storage.
class CreateArticleImageUploading extends CreateArticleState {
  const CreateArticleImageUploading();
}

/// Image uploaded successfully; [imageUrl] is the Cloud Storage download URL.
class CreateArticleImageUploaded extends CreateArticleState {
  final String imageUrl;

  const CreateArticleImageUploaded({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

/// Article is being submitted to Firestore (image already uploaded).
class CreateArticleSubmitting extends CreateArticleState {
  final String imageUrl;

  const CreateArticleSubmitting({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

/// Article created successfully.
class CreateArticleSuccess extends CreateArticleState {
  final FirebaseArticleEntity article;

  const CreateArticleSuccess({required this.article});

  @override
  List<Object?> get props => [article];
}

/// An error occurred. Preserves [imageUrl] if image was already uploaded,
/// so the user can retry submission without re-uploading.
class CreateArticleError extends CreateArticleState {
  final AppException error;
  final String? imageUrl;

  const CreateArticleError({required this.error, this.imageUrl});

  @override
  List<Object?> get props => [error, imageUrl];
}
