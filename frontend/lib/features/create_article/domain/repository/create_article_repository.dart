import 'dart:io';

import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';

/// Abstract repository interface for article CRUD operations in Firebase.
///
/// Implemented by the data layer; consumed by use cases in the domain layer.
abstract class CreateArticleRepository {
  /// Uploads an image file to Cloud Storage and returns the download URL.
  Future<DataState<String>> uploadArticleImage(File imageFile);

  /// Creates an article document in Firestore and returns the created entity.
  Future<DataState<FirebaseArticleEntity>> createArticle(
    FirebaseArticleEntity article,
  );

  /// Updates an existing article in Firestore and returns the updated entity.
  Future<DataState<FirebaseArticleEntity>> updateArticle(
    FirebaseArticleEntity article,
  );

  /// Fetches all articles owned by the given [ownerUid].
  Future<DataState<List<FirebaseArticleEntity>>> getArticlesByOwner(
    String ownerUid,
  );

  /// Fetches all community-published articles (newest first).
  Future<DataState<List<FirebaseArticleEntity>>> getAllArticles();
}
