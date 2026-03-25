import 'dart:io';

import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';

/// Abstract repository interface for creating articles in Firebase.
///
/// Implemented by the data layer; consumed by use cases in the domain layer.
abstract class CreateArticleRepository {
  /// Uploads an image file to Cloud Storage and returns the download URL.
  Future<DataState<String>> uploadArticleImage(File imageFile);

  /// Creates an article document in Firestore and returns the created entity.
  Future<DataState<FirebaseArticleEntity>> createArticle(
    FirebaseArticleEntity article,
  );
}
