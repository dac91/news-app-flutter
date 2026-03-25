import 'package:equatable/equatable.dart';

/// Parameters for the [CreateArticleUseCase].
///
/// Contains all form fields needed to create an article.
/// The [thumbnailUrl] is the download URL returned by [UploadArticleImageUseCase].
class CreateArticleParams extends Equatable {
  final String title;
  final String description;
  final String content;
  final String author;
  final String thumbnailUrl;

  const CreateArticleParams({
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [title, description, content, author, thumbnailUrl];
}
