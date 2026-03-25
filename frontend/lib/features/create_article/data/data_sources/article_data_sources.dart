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
