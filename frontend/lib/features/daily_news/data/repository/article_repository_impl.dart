import 'dart:io';

import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/services/connectivity_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final AppDatabase _appDatabase;
  final ConnectivityService _connectivityService;

  ArticleRepositoryImpl(
    this._newsApiService,
    this._appDatabase,
    this._connectivityService,
  );

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles({
    String? category,
    String? query,
    int? page,
    int? pageSize,
  }) async {
    // Offline fallback: return saved articles from local DB
    final isOnline = await _connectivityService.isConnected;
    if (!isOnline) {
      final cached = await _appDatabase.articleDAO.getArticles();
      if (cached.isNotEmpty) {
        return DataSuccess(cached);
      }
      return const DataFailed(
        AppException(
          message: 'No internet connection and no cached articles available',
          identifier: 'getNewsArticles.offline',
        ),
      );
    }

    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: newsAPIKey,
        country: query != null ? null : countryQuery,
        category: category ?? categoryQuery,
        query: query,
        page: page,
        pageSize: pageSize,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          AppException(
            message: httpResponse.response.statusMessage ?? 'Unknown error',
            statusCode: httpResponse.response.statusCode,
            identifier: 'getNewsArticles',
          ),
        );
      }
    } on DioError catch (e) {
      return DataFailed(
        AppException(
          message: e.message,
          statusCode: e.response?.statusCode,
          identifier: 'getNewsArticles',
        ),
      );
    }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    return _appDatabase.articleDAO.getArticles();
  }

  @override
  Future<void> removeArticle(ArticleEntity article) {
    return _appDatabase.articleDAO
        .deleteArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _appDatabase.articleDAO
        .insertArticle(ArticleModel.fromEntity(article));
  }
}