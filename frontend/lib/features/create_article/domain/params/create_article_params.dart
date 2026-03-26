import 'package:equatable/equatable.dart';

/// Parameters for the [CreateArticleUseCase].
///
/// Contains all form fields needed to create an article.
/// The [thumbnailUrl] is the download URL returned by [UploadArticleImageUseCase].
/// The [ownerUid] is the Firebase Auth UID of the authenticated user.
class CreateArticleParams extends Equatable {
  final String title;
  final String description;
  final String content;
  final String author;
  final String thumbnailUrl;
  final String ownerUid;
  final String? category;

  const CreateArticleParams({
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.thumbnailUrl,
    required this.ownerUid,
    this.category,
  });

  @override
  List<Object?> get props => [title, description, content, author, thumbnailUrl, ownerUid, category];
}
