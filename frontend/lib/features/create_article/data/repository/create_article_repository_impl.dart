import 'dart:io';

import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/data/data_sources/article_data_sources.dart';
import 'package:news_app_clean_architecture/features/create_article/data/models/firebase_article_model.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';

/// Concrete implementation of [CreateArticleRepository].
///
/// Manages Firebase interactions through data source abstractions,
/// converting framework-specific exceptions to domain [AppException]s
/// at the boundary (same pattern as [ArticleRepositoryImpl]).
class CreateArticleRepositoryImpl implements CreateArticleRepository {
  final FirestoreArticleDataSource _firestoreDataSource;
  final StorageArticleDataSource _storageDataSource;

  CreateArticleRepositoryImpl(
    this._firestoreDataSource,
    this._storageDataSource,
  );

  @override
  Future<DataState<String>> uploadArticleImage(File imageFile) async {
    try {
      final downloadUrl = await _storageDataSource.uploadImage(imageFile);
      return DataSuccess(downloadUrl);
    } catch (e) {
      return DataFailed(
        AppException(
          message: e.toString(),
          identifier: 'uploadArticleImage',
        ),
      );
    }
  }

  @override
  Future<DataState<FirebaseArticleEntity>> createArticle(
    FirebaseArticleEntity article,
  ) async {
    try {
      final model = FirebaseArticleModel.fromEntity(article);
      final createdModel = await _firestoreDataSource.createArticle(model);
      return DataSuccess(createdModel.toEntity());
    } catch (e) {
      return DataFailed(
        AppException(
          message: e.toString(),
          identifier: 'createArticle',
        ),
      );
    }
  }

  @override
  Future<DataState<FirebaseArticleEntity>> updateArticle(
    FirebaseArticleEntity article,
  ) async {
    try {
      final model = FirebaseArticleModel.fromEntity(article);
      final updatedModel = await _firestoreDataSource.updateArticle(model);
      return DataSuccess(updatedModel.toEntity());
    } catch (e) {
      return DataFailed(
        AppException(
          message: e.toString(),
          identifier: 'updateArticle',
        ),
      );
    }
  }

  @override
  Future<DataState<List<FirebaseArticleEntity>>> getArticlesByOwner(
    String ownerUid,
  ) async {
    try {
      final models =
          await _firestoreDataSource.getArticlesByOwner(ownerUid);
      return DataSuccess(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return DataFailed(
        AppException(
          message: e.toString(),
          identifier: 'getArticlesByOwner',
        ),
      );
    }
  }
}
