import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/params/get_insight_params.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/repository/ai_insight_repository.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/usecases/get_article_insight_usecase.dart';

class MockAiInsightRepository extends Mock implements AiInsightRepository {}

class FakeGetInsightParams extends Fake implements GetInsightParams {}

void main() {
  late GetArticleInsightUseCase useCase;
  late MockAiInsightRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeGetInsightParams());
  });

  setUp(() {
    mockRepository = MockAiInsightRepository();
    useCase = GetArticleInsightUseCase(mockRepository);
  });

  const tParams = GetInsightParams(
    title: 'AI in healthcare',
    description: 'How AI is changing diagnostics.',
    content: 'Full article content about AI in healthcare...',
    source: 'Reuters',
    url: 'https://reuters.com/article/ai-healthcare',
  );

  const tInsight = AiInsightEntity(
    summaryBullets: [
      'AI diagnostics improve accuracy by 20%',
      'FDA approved 3 new AI tools this quarter',
      'Challenges remain around data privacy',
    ],
    tone: 'neutral',
    toneExplanation: 'The article presents factual data without advocacy.',
    politicalLeaning: 'center',
    sourceContext: 'Reuters is a major international wire service.',
    emphasisAnalysis:
        'Focuses on regulatory approvals; limited on patient impact.',
  );

  group('GetArticleInsightUseCase', () {
    test('returns DataSuccess with insight entity on success', () async {
      // Arrange
      when(() => mockRepository.getArticleInsight(any()))
          .thenAnswer((_) async => const DataSuccess(tInsight));

      // Act
      final result = await useCase(params: tParams);

      // Assert
      expect(result, isA<DataSuccess<AiInsightEntity>>());
      expect(result.data, equals(tInsight));
      expect(result.data!.summaryBullets.length, 3);
      verify(() => mockRepository.getArticleInsight(any())).called(1);
    });

    test('returns DataFailed with AppException on failure', () async {
      // Arrange
      const tException = AppException(
        message: 'Gemini API error',
        identifier: 'getArticleInsight',
      );
      when(() => mockRepository.getArticleInsight(any()))
          .thenAnswer((_) async => const DataFailed(tException));

      // Act
      final result = await useCase(params: tParams);

      // Assert
      expect(result, isA<DataFailed<AiInsightEntity>>());
      expect(result.error, equals(tException));
      expect(result.error!.message, 'Gemini API error');
      verify(() => mockRepository.getArticleInsight(any())).called(1);
    });

    test('passes correct params to repository', () async {
      // Arrange
      when(() => mockRepository.getArticleInsight(any()))
          .thenAnswer((_) async => const DataSuccess(tInsight));

      // Act
      await useCase(params: tParams);

      // Assert
      final captured = verify(
        () => mockRepository.getArticleInsight(captureAny()),
      ).captured.single as GetInsightParams;

      expect(captured.title, equals(tParams.title));
      expect(captured.description, equals(tParams.description));
      expect(captured.content, equals(tParams.content));
      expect(captured.source, equals(tParams.source));
      expect(captured.url, equals(tParams.url));
    });

    test('throws ArgumentError when params is null', () async {
      expect(
        () => useCase(params: null),
        throwsA(isA<ArgumentError>()),
      );
      verifyNever(() => mockRepository.getArticleInsight(any()));
    });
  });
}
