import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';

/// Data model for articles stored in Firestore.
///
/// Extends [FirebaseArticleEntity] and handles serialization to/from
/// plain JSON maps. Per architecture rules (AV 1.2.4), this model does NOT
/// import any provider package (e.g. `cloud_firestore`). Firestore-specific
/// types (`Timestamp`, `FieldValue`) are handled in the data source layer.
///
/// Per AV 1.3.2, implements both [fromRawData] (factory) and [toEntity]
/// conversion methods.
class FirebaseArticleModel extends FirebaseArticleEntity {
  const FirebaseArticleModel({
    String? id,
    required String title,
    required String description,
    required String content,
    required String author,
    required String thumbnailUrl,
    required String ownerUid,
    String? category,
    DateTime? createdAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          content: content,
          author: author,
          thumbnailUrl: thumbnailUrl,
          ownerUid: ownerUid,
          category: category,
          createdAt: createdAt,
        );

  /// Creates a model from a plain data map and a document ID.
  ///
  /// The [docId] is the document ID, passed separately since it's not
  /// stored inside the document fields.
  ///
  /// The `createdAt` field is expected as a [DateTime] — the data source
  /// is responsible for converting provider-specific types (e.g. Firestore
  /// `Timestamp`) to [DateTime] before calling this factory.
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
      ownerUid: data['ownerUid'] as String? ?? '',
      category: data['category'] as String?,
      createdAt: data['createdAt'] as DateTime?,
    );
  }

  /// Converts the model to a plain JSON map for creation.
  ///
  /// The `createdAt` field is set to `null` as a sentinel — the data source
  /// replaces it with the provider's server-timestamp mechanism (e.g.
  /// `FieldValue.serverTimestamp()` for Firestore).
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'thumbnailURL': thumbnailUrl,
      'ownerUid': ownerUid,
      if (category != null) 'category': category,
      'createdAt': null, // sentinel — data source injects server timestamp
    };
  }

  /// Converts the model to a JSON map for updates.
  ///
  /// Unlike [toJson], this preserves the existing `createdAt` value (as a
  /// [DateTime]) so the data source can convert it to the provider format.
  /// If `createdAt` is null, the data source should use a server timestamp.
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'thumbnailURL': thumbnailUrl,
      'ownerUid': ownerUid,
      if (category != null) 'category': category,
      'createdAt': createdAt, // DateTime or null — data source converts
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
      ownerUid: ownerUid,
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
      ownerUid: entity.ownerUid,
      category: entity.category,
      createdAt: entity.createdAt,
    );
  }
}
