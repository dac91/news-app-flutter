import 'dart:io';

import 'package:news_app_clean_architecture/features/create_article/data/models/firebase_article_model.dart';

/// Abstract interface for Firestore article operations.
///
/// Implemented by [FirestoreArticleDataSourceImpl]. Consumed by the
/// repository implementation, never by the presentation or domain layers.
abstract class FirestoreArticleDataSource {
  /// Creates an article document in Firestore.
  ///
  /// Returns the created [FirebaseArticleModel] with the server-assigned
  /// document ID and timestamp populated.
  Future<FirebaseArticleModel> createArticle(FirebaseArticleModel model);

  /// Updates an existing article document in Firestore.
  ///
  /// Returns the updated [FirebaseArticleModel] with the latest data.
  Future<FirebaseArticleModel> updateArticle(FirebaseArticleModel model);

  /// Fetches all articles owned by the given [ownerUid].
  Future<List<FirebaseArticleModel>> getArticlesByOwner(String ownerUid);

  /// Fetches all community-published articles, ordered by creation date
  /// (newest first).
  Future<List<FirebaseArticleModel>> getAllArticles();
}

/// Abstract interface for Cloud Storage image operations.
///
/// Implemented by [StorageArticleDataSourceImpl]. Consumed by the
/// repository implementation, never by the presentation or domain layers.
abstract class StorageArticleDataSource {
  /// Uploads an image file to Cloud Storage.
  ///
  /// Returns the public download URL of the uploaded image.
  Future<String> uploadImage(File imageFile);
}
