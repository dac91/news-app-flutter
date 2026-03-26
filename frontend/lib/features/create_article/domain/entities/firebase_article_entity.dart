import 'package:equatable/equatable.dart';

/// Domain entity representing a journalist-created article stored in Firebase.
///
/// This is distinct from [ArticleEntity] in the daily_news feature, which
/// represents articles fetched from the NewsAPI. Firebase articles have
/// different fields (e.g. no `url` to an external site, but a `thumbnailUrl`
/// pointing to Cloud Storage).
class FirebaseArticleEntity extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String content;
  final String author;
  final String thumbnailUrl;
  final String ownerUid;
  final String? category;
  final DateTime? createdAt;

  const FirebaseArticleEntity({
    this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.thumbnailUrl,
    required this.ownerUid,
    this.category,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        author,
        thumbnailUrl,
        ownerUid,
        category,
        createdAt,
      ];
}
