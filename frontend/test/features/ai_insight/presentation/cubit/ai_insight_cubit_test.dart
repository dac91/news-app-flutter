import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/params/get_insight_params.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/usecases/get_article_insight_usecase.dart';
import 'package:news_app_clean_architecture/features/ai_insight/presentation/cubit/ai_insight_cubit.dart';
import 'package:news_app_clean_architecture/features/ai_insight/presentation/cubit/ai_insight_state.dart';

class MockGetArticleInsightUseCase extends Mock
    implements GetArticleInsightUseCase {}

class FakeGetInsightParams extends Fake implements GetInsightParams {}

void main() {
  late AiInsightCubit cubit;
  late MockGetArticleInsightUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(FakeGetInsightParams());
  });

  setUp(() {
    mockUseCase = MockGetArticleInsightUseCase();
    cubit = AiInsightCubit(getArticleInsightUseCase: mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const tInsight = AiInsightEntity(
    summaryBullets: [
      'Global temperatures hit record highs',
      'Scientists urge immediate policy action',
      'Developing nations face disproportionate impact',
    ],
    tone: 'alarming',
    toneExplanation: 'The article uses urgent language to convey crisis.',
    sourceContext: 'The Guardian is known for progressive editorial stance.',
    emphasisAnalysis:
        'Emphasizes climate urgency; limited coverage of economic tradeoffs.',
  );

  group('AiInsightCubit', () {
    test('initial state is AiInsightInitial', () {
      expect(cubit.state, const AiInsightInitial());
    });

    group('getInsight', () {
      test('emits [Loading, Loaded] on DataSuccess', () async {
        when(() => mockUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataSuccess(tInsight));

        final states = <AiInsightState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.getInsight(
          title: 'Climate Crisis Deepens',
          description: 'Record temperatures worldwide.',
          content: 'Full article content...',
          source: 'The Guardian',
          url: 'https://theguardian.com/climate-crisis',
        );
        await Future<void>.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], const AiInsightLoading());
        expect(states[1], isA<AiInsightLoaded>());
        expect((states[1] as AiInsightLoaded).insight, tInsight);

        await subscription.cancel();
      });

      test('emits [Loading, Error] on DataFailed', () async {
        const tError = AppException(
          message: 'Gemini API rate limit exceeded',
          identifier: 'getArticleInsight',
        );
        when(() => mockUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataFailed(tError));

        final states = <AiInsightState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.getInsight(title: 'Title');
        await Future<void>.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], const AiInsightLoading());
        expect(states[1], isA<AiInsightError>());
        expect(
          (states[1] as AiInsightError).error.message,
          'Gemini API rate limit exceeded',
        );

        await subscription.cancel();
      });

      test('emits [Loading, Error] when use case throws exception', () async {
        when(() => mockUseCase.call(params: any(named: 'params')))
            .thenThrow(Exception('Unexpected failure'));

        final states = <AiInsightState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.getInsight(title: 'Title');
        await Future<void>.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], const AiInsightLoading());
        expect(states[1], isA<AiInsightError>());
        expect(
          (states[1] as AiInsightError).error.message,
          contains('Unexpected failure'),
        );

        await subscription.cancel();
      });

      test('passes correct params to use case', () async {
        when(() => mockUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataSuccess(tInsight));

        await cubit.getInsight(
          title: 'Test Title',
          description: 'Test Desc',
          content: 'Test Content',
          source: 'Test Source',
          url: 'https://example.com/test',
        );

        final captured = verify(
          () => mockUseCase.call(params: captureAny(named: 'params')),
        ).captured.single as GetInsightParams;

        expect(captured.title, 'Test Title');
        expect(captured.description, 'Test Desc');
        expect(captured.content, 'Test Content');
        expect(captured.source, 'Test Source');
        expect(captured.url, 'https://example.com/test');
      });

      test('handles null optional params correctly', () async {
        when(() => mockUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataSuccess(tInsight));

        await cubit.getInsight(title: 'Only Title');

        final captured = verify(
          () => mockUseCase.call(params: captureAny(named: 'params')),
        ).captured.single as GetInsightParams;

        expect(captured.title, 'Only Title');
        expect(captured.description, isNull);
        expect(captured.content, isNull);
        expect(captured.source, isNull);
        expect(captured.url, isNull);
      });
    });

    group('state equality', () {
      test('AiInsightInitial instances are equal', () {
        expect(const AiInsightInitial(), const AiInsightInitial());
      });

      test('AiInsightLoading instances are equal', () {
        expect(const AiInsightLoading(), const AiInsightLoading());
      });

      test('AiInsightLoaded with same insight are equal', () {
        const state1 = AiInsightLoaded(insight: tInsight);
        const state2 = AiInsightLoaded(insight: tInsight);
        expect(state1, equals(state2));
      });

      test('AiInsightLoaded with different insights are not equal', () {
        const state1 = AiInsightLoaded(insight: tInsight);
        const state2 = AiInsightLoaded(
          insight: AiInsightEntity(
            summaryBullets: ['Different'],
            tone: 'critical',
            toneExplanation: 'Different explanation',
            sourceContext: 'Different context',
            emphasisAnalysis: 'Different analysis',
          ),
        );
        expect(state1, isNot(equals(state2)));
      });

      test('AiInsightError with same error are equal', () {
        const state1 = AiInsightError(
          error: AppException(message: 'fail', identifier: 'test'),
        );
        const state2 = AiInsightError(
          error: AppException(message: 'fail', identifier: 'test'),
        );
        expect(state1, equals(state2));
      });

      test('AiInsightError with different errors are not equal', () {
        const state1 = AiInsightError(
          error: AppException(message: 'fail A'),
        );
        const state2 = AiInsightError(
          error: AppException(message: 'fail B'),
        );
        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
