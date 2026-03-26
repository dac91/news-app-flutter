import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/data_sources/ai_insight_data_sources.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/models/ai_insight_model.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/repository/ai_insight_repository_impl.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/params/get_insight_params.dart';

class MockGeminiDataSource extends Mock implements GeminiDataSource {}

class MockInsightCacheDataSource extends Mock
    implements InsightCacheDataSource {}

class FakeAiInsightModel extends Fake implements AiInsightModel {}

void main() {
  late AiInsightRepositoryImpl repository;
  late MockGeminiDataSource mockGeminiDataSource;
  late MockInsightCacheDataSource mockCacheDataSource;

  setUpAll(() {
    registerFallbackValue(FakeAiInsightModel());
  });

  setUp(() {
    mockGeminiDataSource = MockGeminiDataSource();
    mockCacheDataSource = MockInsightCacheDataSource();
    repository = AiInsightRepositoryImpl(
      mockGeminiDataSource,
      mockCacheDataSource,
    );
  });

  const tParams = GetInsightParams(
    title: 'Test Article Title',
    description: 'A brief description',
    content: 'The full article content',
    source: 'BBC',
    url: 'https://bbc.com/article/test-123',
  );

  const tModel = AiInsightModel(
    summaryBullets: ['Fact 1', 'Fact 2', 'Fact 3'],
    tone: 'neutral',
    toneExplanation: 'Balanced reporting style.',
    sourceContext: 'BBC is the UK public broadcaster.',
    emphasisAnalysis: 'Emphasizes policy impact; limited business perspective.',
  );

  group('getArticleInsight', () {
    group('cache hit', () {
      test('returns DataSuccess from cache without calling Gemini', () async {
        // Arrange
        when(() => mockCacheDataSource.getCachedInsight(any()))
            .thenAnswer((_) async => tModel);

        // Act
        final result = await repository.getArticleInsight(tParams);

        // Assert
        expect(result, isA<DataSuccess<AiInsightEntity>>());
        expect(result.data!.tone, 'neutral');
        expect(result.data!.summaryBullets, ['Fact 1', 'Fact 2', 'Fact 3']);
        verify(
          () => mockCacheDataSource.getCachedInsight(tParams.cacheKey),
        ).called(1);
        verifyNever(
          () => mockGeminiDataSource.generateInsight(
            title: any(named: 'title'),
            description: any(named: 'description'),
            content: any(named: 'content'),
            source: any(named: 'source'),
          ),
        );
      });

      test('does not attempt to re-cache cached results', () async {
        when(() => mockCacheDataSource.getCachedInsight(any()))
            .thenAnswer((_) async => tModel);

        await repository.getArticleInsight(tParams);

        verifyNever(
          () => mockCacheDataSource.cacheInsight(any(), any()),
        );
      });
    });

    group('cache miss', () {
      setUp(() {
        when(() => mockCacheDataSource.getCachedInsight(any()))
            .thenAnswer((_) async => null);
      });

      test('calls Gemini API and returns DataSuccess', () async {
        // Arrange
        when(() => mockGeminiDataSource.generateInsight(
              title: any(named: 'title'),
              description: any(named: 'description'),
              content: any(named: 'content'),
              source: any(named: 'source'),
            )).thenAnswer((_) async => tModel);
        when(() => mockCacheDataSource.cacheInsight(any(), any()))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.getArticleInsight(tParams);

        // Assert
        expect(result, isA<DataSuccess<AiInsightEntity>>());
        expect(result.data!.tone, 'neutral');
        verify(
          () => mockGeminiDataSource.generateInsight(
            title: tParams.title,
            description: tParams.description,
            content: tParams.content,
            source: tParams.source,
          ),
        ).called(1);
      });

      test('caches the Gemini result for future requests', () async {
        when(() => mockGeminiDataSource.generateInsight(
              title: any(named: 'title'),
              description: any(named: 'description'),
              content: any(named: 'content'),
              source: any(named: 'source'),
            )).thenAnswer((_) async => tModel);
        when(() => mockCacheDataSource.cacheInsight(any(), any()))
            .thenAnswer((_) async {});

        await repository.getArticleInsight(tParams);

        verify(
          () => mockCacheDataSource.cacheInsight(tParams.cacheKey, tModel),
        ).called(1);
      });

      test('returns DataFailed when Gemini throws', () async {
        when(() => mockGeminiDataSource.generateInsight(
              title: any(named: 'title'),
              description: any(named: 'description'),
              content: any(named: 'content'),
              source: any(named: 'source'),
            )).thenThrow(Exception('Gemini API rate limit exceeded'));

        final result = await repository.getArticleInsight(tParams);

        expect(result, isA<DataFailed<AiInsightEntity>>());
        expect(result.error, isNotNull);
        expect(result.error!.identifier, 'getArticleInsight');
        expect(
          result.error!.message,
          contains('Gemini API rate limit exceeded'),
        );
      });

      test('does not cache when Gemini throws', () async {
        when(() => mockGeminiDataSource.generateInsight(
              title: any(named: 'title'),
              description: any(named: 'description'),
              content: any(named: 'content'),
              source: any(named: 'source'),
            )).thenThrow(Exception('API error'));

        await repository.getArticleInsight(tParams);

        verifyNever(
          () => mockCacheDataSource.cacheInsight(any(), any()),
        );
      });
    });

    group('cache read error (resilient fallback)', () {
      test('falls back to Gemini when cache read throws', () async {
        when(() => mockCacheDataSource.getCachedInsight(any()))
            .thenThrow(Exception('Firestore unavailable'));
        when(() => mockGeminiDataSource.generateInsight(
              title: any(named: 'title'),
              description: any(named: 'description'),
              content: any(named: 'content'),
              source: any(named: 'source'),
            )).thenAnswer((_) async => tModel);
        when(() => mockCacheDataSource.cacheInsight(any(), any()))
            .thenAnswer((_) async {});

        final result = await repository.getArticleInsight(tParams);

        expect(result, isA<DataSuccess<AiInsightEntity>>());
        expect(result.data!.tone, 'neutral');
        verify(
          () => mockGeminiDataSource.generateInsight(
            title: tParams.title,
            description: tParams.description,
            content: tParams.content,
            source: tParams.source,
          ),
        ).called(1);
      });

      test('returns DataFailed when both cache and Gemini fail', () async {
        when(() => mockCacheDataSource.getCachedInsight(any()))
            .thenThrow(Exception('Firestore unavailable'));
        when(() => mockGeminiDataSource.generateInsight(
              title: any(named: 'title'),
              description: any(named: 'description'),
              content: any(named: 'content'),
              source: any(named: 'source'),
            )).thenThrow(Exception('Gemini API error'));

        final result = await repository.getArticleInsight(tParams);

        expect(result, isA<DataFailed<AiInsightEntity>>());
        expect(result.error!.identifier, 'getArticleInsight');
        expect(result.error!.message, contains('Gemini API error'));
      });

      test('still caches Gemini result after cache read failure', () async {
        when(() => mockCacheDataSource.getCachedInsight(any()))
            .thenThrow(Exception('Firestore unavailable'));
        when(() => mockGeminiDataSource.generateInsight(
              title: any(named: 'title'),
              description: any(named: 'description'),
              content: any(named: 'content'),
              source: any(named: 'source'),
            )).thenAnswer((_) async => tModel);
        when(() => mockCacheDataSource.cacheInsight(any(), any()))
            .thenAnswer((_) async {});

        await repository.getArticleInsight(tParams);

        verify(
          () => mockCacheDataSource.cacheInsight(tParams.cacheKey, tModel),
        ).called(1);
      });
    });

    group('cache write error (resilient)', () {
      test('returns DataSuccess even when cache write throws', () async {
        when(() => mockCacheDataSource.getCachedInsight(any()))
            .thenAnswer((_) async => null);
        when(() => mockGeminiDataSource.generateInsight(
              title: any(named: 'title'),
              description: any(named: 'description'),
              content: any(named: 'content'),
              source: any(named: 'source'),
            )).thenAnswer((_) async => tModel);
        when(() => mockCacheDataSource.cacheInsight(any(), any()))
            .thenThrow(Exception('Firestore write denied'));

        final result = await repository.getArticleInsight(tParams);

        expect(result, isA<DataSuccess<AiInsightEntity>>());
        expect(result.data!.tone, 'neutral');
      });
    });
  });
}
