import 'dart:io';

import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';

/// In-memory mock implementation of [CreateArticleRepository].
///
/// Returns deterministic [DataSuccess] results backed by a simple list,
/// allowing the app to run without a live Firebase backend (useful for
/// demos, offline development, and manual testing).
class MockCreateArticleRepositoryImpl implements CreateArticleRepository {
  final List<FirebaseArticleEntity> _articles = [];
  int _idCounter = 0;

  @override
  Future<DataState<String>> uploadArticleImage(File imageFile) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return DataSuccess(
      'https://mock-storage.example.com/images/${imageFile.path.split('/').last}',
    );
  }

  @override
  Future<DataState<FirebaseArticleEntity>> createArticle(
    FirebaseArticleEntity article,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _idCounter++;
    final created = FirebaseArticleEntity(
      id: 'mock-$_idCounter',
      title: article.title,
      description: article.description,
      content: article.content,
      author: article.author,
      thumbnailUrl: article.thumbnailUrl,
      ownerUid: article.ownerUid,
      category: article.category,
      createdAt: DateTime.now(),
    );
    _articles.add(created);
    return DataSuccess(created);
  }

  @override
  Future<DataState<FirebaseArticleEntity>> updateArticle(
    FirebaseArticleEntity article,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _articles.indexWhere((a) => a.id == article.id);
    if (index == -1) {
      return DataSuccess(article); // no-op for unknown articles
    }
    _articles[index] = article;
    return DataSuccess(article);
  }

  @override
  Future<DataState<List<FirebaseArticleEntity>>> getArticlesByOwner(
    String ownerUid,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final filtered =
        _articles.where((a) => a.ownerUid == ownerUid).toList();
    return DataSuccess(filtered);
  }
}
