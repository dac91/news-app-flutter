import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/services/connectivity_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/DAO/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

class MockNewsApiService extends Mock implements NewsApiService {}

class MockAppDatabase extends Mock implements AppDatabase {}

class MockArticleDao extends Mock implements ArticleDao {}

class MockConnectivityService extends Mock implements ConnectivityServiceBase {}

class FakeArticleModel extends Fake implements ArticleModel {}

void main() {
  late ArticleRepositoryImpl repository;
  late MockNewsApiService mockApiService;
  late MockAppDatabase mockDatabase;
  late MockArticleDao mockDao;
  late MockConnectivityService mockConnectivity;

  setUpAll(() {
    registerFallbackValue(FakeArticleModel());
  });

  setUp(() {
    mockApiService = MockNewsApiService();
    mockDatabase = MockAppDatabase();
    mockDao = MockArticleDao();
    mockConnectivity = MockConnectivityService();
    repository = ArticleRepositoryImpl(
      mockApiService,
      mockDatabase,
      mockConnectivity,
    );

    when(() => mockDatabase.articleDAO).thenReturn(mockDao);
  });

  final tModels = [
    const ArticleModel(
      id: 1,
      author: 'John',
      title: 'Test Article',
      description: 'Desc',
      url: 'https://example.com',
      urlToImage: 'https://example.com/img.jpg',
      publishedAt: '2026-03-25',
      content: 'Content',
    ),
  ];

  group('getNewsArticles', () {
    test('returns DataFailed when offline and no cached articles', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => false);
      when(() => mockDao.getArticles()).thenAnswer((_) async => []);

      final result = await repository.getNewsArticles();

      expect(result, isA<DataFailed<List<ArticleModel>>>());
      expect(result.error!.identifier, equals('getNewsArticles.offline'));
    });

    test('returns cached articles when offline and cache exists', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => false);
      when(() => mockDao.getArticles()).thenAnswer((_) async => tModels);

      final result = await repository.getNewsArticles();

      expect(result, isA<DataSuccess<List<ArticleModel>>>());
      expect(result.data!.length, equals(1));
      expect(result.data!.first.title, equals('Test Article'));
    });

    test('returns DataSuccess with articles on successful API call', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockApiService.getNewsArticles(
            apiKey: any(named: 'apiKey'),
            country: any(named: 'country'),
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenAnswer((_) async => HttpResponse(
            tModels,
            Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: HttpStatus.ok,
            ),
          ));

      final result = await repository.getNewsArticles();

      expect(result, isA<DataSuccess<List<ArticleModel>>>());
      expect(result.data, equals(tModels));
    });

    test('returns DataFailed when API returns non-200 status', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockApiService.getNewsArticles(
            apiKey: any(named: 'apiKey'),
            country: any(named: 'country'),
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenAnswer((_) async => HttpResponse(
            <ArticleModel>[],
            Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 429,
              statusMessage: 'Rate limited',
            ),
          ));

      final result = await repository.getNewsArticles();

      expect(result, isA<DataFailed<List<ArticleModel>>>());
      expect(result.error!.message, equals('Rate limited'));
    });

    test('returns DataFailed when API throws an exception', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockApiService.getNewsArticles(
            apiKey: any(named: 'apiKey'),
            country: any(named: 'country'),
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenThrow(Exception('Network error'));

      final result = await repository.getNewsArticles();

      expect(result, isA<DataFailed<List<ArticleModel>>>());
      expect(result.error, isA<AppException>());
    });

    test('passes null country and uses query when search query is provided',
        () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockApiService.getNewsArticles(
            apiKey: any(named: 'apiKey'),
            country: any(named: 'country'),
            category: any(named: 'category'),
            query: any(named: 'query'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenAnswer((_) async => HttpResponse(
            tModels,
            Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: HttpStatus.ok,
            ),
          ));

      await repository.getNewsArticles(query: 'flutter');

      final captured = verify(() => mockApiService.getNewsArticles(
            apiKey: any(named: 'apiKey'),
            country: captureAny(named: 'country'),
            category: any(named: 'category'),
            query: captureAny(named: 'query'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).captured;

      expect(captured[0], isNull); // country should be null when query present
      expect(captured[1], equals('flutter'));
    });
  });

  group('getSavedArticles', () {
    test('returns DataSuccess with saved articles from local DB', () async {
      when(() => mockDao.getArticles()).thenAnswer((_) async => tModels);

      final result = await repository.getSavedArticles();

      expect(result, isA<DataSuccess<List<ArticleModel>>>());
      expect(result.data!.length, equals(1));
    });

    test('returns DataFailed when local DB throws', () async {
      when(() => mockDao.getArticles()).thenThrow(Exception('DB error'));

      final result = await repository.getSavedArticles();

      expect(result, isA<DataFailed<List<ArticleModel>>>());
      expect(result.error!.identifier, equals('getSavedArticles'));
    });
  });

  group('saveArticle', () {
    test('delegates to DAO insertArticle', () async {
      when(() => mockDao.insertArticle(any())).thenAnswer((_) async {});

      const entity = ArticleEntity(id: 1, title: 'Save Me');
      await repository.saveArticle(entity);

      verify(() => mockDao.insertArticle(any())).called(1);
    });
  });

  group('removeArticle', () {
    test('delegates to DAO deleteArticle', () async {
      when(() => mockDao.deleteArticle(any())).thenAnswer((_) async {});

      const entity = ArticleEntity(id: 1, title: 'Remove Me');
      await repository.removeArticle(entity);

      verify(() => mockDao.deleteArticle(any())).called(1);
    });
  });
}
