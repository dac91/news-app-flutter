import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';

/// Data model for articles stored in Firestore.
///
/// Extends [FirebaseArticleEntity] and handles serialization to/from
/// Firestore JSON format. Per architecture rules (AV 1.3.2), implements
/// both [fromRawData] (factory) and [toEntity] conversion methods.
class FirebaseArticleModel extends FirebaseArticleEntity {
  const FirebaseArticleModel({
    String? id,
    required String title,
    required String description,
    required String content,
    required String author,
    required String thumbnailUrl,
    String? category,
    DateTime? createdAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          content: content,
          author: author,
          thumbnailUrl: thumbnailUrl,
          category: category,
          createdAt: createdAt,
        );

  /// Creates a model from Firestore document data.
  ///
  /// The [docId] is the Firestore document ID, passed separately since
  /// it's not stored inside the document fields.
  factory FirebaseArticleModel.fromRawData(
    Map<String, dynamic> data,
    String docId,
  ) {
    return FirebaseArticleModel(
      id: docId,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      content: data['content'] as String? ?? '',
      author: data['author'] as String? ?? '',
      thumbnailUrl: data['thumbnailURL'] as String? ?? '',
      category: data['category'] as String?,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Converts the model to a Firestore-compatible JSON map.
  ///
  /// Uses [FieldValue.serverTimestamp()] for `createdAt` to ensure
  /// the timestamp is set server-side (preventing client clock manipulation,
  /// as enforced by Firestore rules).
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'thumbnailURL': thumbnailUrl,
      if (category != null) 'category': category,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Converts the model to a JSON map for Firestore updates.
  ///
  /// Unlike [toJson], this does NOT overwrite `createdAt` since
  /// the original creation timestamp should be preserved on edits.
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'thumbnailURL': thumbnailUrl,
      if (category != null) 'category': category,
    };
  }

  /// Converts this data model to a domain entity.
  FirebaseArticleEntity toEntity() {
    return FirebaseArticleEntity(
      id: id,
      title: title,
      description: description,
      content: content,
      author: author,
      thumbnailUrl: thumbnailUrl,
      category: category,
      createdAt: createdAt,
    );
  }

  /// Creates a model from a domain entity (for passing to data sources).
  factory FirebaseArticleModel.fromEntity(FirebaseArticleEntity entity) {
    return FirebaseArticleModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      content: entity.content,
      author: entity.author,
      thumbnailUrl: entity.thumbnailUrl,
      category: entity.category,
      createdAt: entity.createdAt,
    );
  }
}
