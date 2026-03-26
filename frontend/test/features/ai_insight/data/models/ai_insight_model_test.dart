import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/models/ai_insight_model.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';

void main() {
  group('AiInsightModel', () {
    const tModel = AiInsightModel(
      summaryBullets: ['Key fact 1', 'Key fact 2', 'Key fact 3'],
      tone: 'neutral',
      toneExplanation: 'The article presents balanced viewpoints.',
      politicalLeaning: 'center',
      sourceContext: 'Reuters is a major international wire service.',
      emphasisAnalysis: 'Focuses on economic indicators; omits social impact.',
    );

    final tJson = <String, dynamic>{
      'summaryBullets': ['Key fact 1', 'Key fact 2', 'Key fact 3'],
      'tone': 'neutral',
      'toneExplanation': 'The article presents balanced viewpoints.',
      'politicalLeaning': 'center',
      'sourceContext': 'Reuters is a major international wire service.',
      'emphasisAnalysis':
          'Focuses on economic indicators; omits social impact.',
    };

    group('fromRawData', () {
      test('creates model from complete JSON map', () {
        final model = AiInsightModel.fromRawData(tJson);

        expect(model.summaryBullets, tModel.summaryBullets);
        expect(model.tone, tModel.tone);
        expect(model.toneExplanation, tModel.toneExplanation);
        expect(model.politicalLeaning, tModel.politicalLeaning);
        expect(model.sourceContext, tModel.sourceContext);
        expect(model.emphasisAnalysis, tModel.emphasisAnalysis);
      });

      test('handles missing summaryBullets gracefully', () {
        final model = AiInsightModel.fromRawData(const {
          'tone': 'critical',
          'toneExplanation': 'Explanation',
          'politicalLeaning': 'left',
          'sourceContext': 'Context',
          'emphasisAnalysis': 'Analysis',
        });

        expect(model.summaryBullets, isEmpty);
      });

      test('handles null string fields with defaults', () {
        final model = AiInsightModel.fromRawData(const {});

        expect(model.summaryBullets, isEmpty);
        expect(model.tone, 'unknown');
        expect(model.toneExplanation, '');
        expect(model.politicalLeaning, 'unknown');
        expect(model.sourceContext, '');
        expect(model.emphasisAnalysis, '');
      });

      test('converts dynamic list items to strings', () {
        final model = AiInsightModel.fromRawData(const {
          'summaryBullets': [1, 2.5, true, 'text'],
          'tone': 'neutral',
        });

        expect(model.summaryBullets, ['1', '2.5', 'true', 'text']);
      });

      test('handles missing politicalLeaning with unknown default', () {
        final model = AiInsightModel.fromRawData(const {
          'summaryBullets': ['Fact'],
          'tone': 'neutral',
          'toneExplanation': 'Balanced.',
          'sourceContext': 'Wire service.',
          'emphasisAnalysis': 'Broad coverage.',
        });

        expect(model.politicalLeaning, 'unknown');
      });
    });

    group('toJson', () {
      test('serializes all fields to JSON map', () {
        final json = tModel.toJson();

        expect(json, tJson);
      });

      test('round-trips through fromJson/toJson', () {
        final roundTripped = AiInsightModel.fromRawData(tModel.toJson());

        expect(roundTripped, equals(tModel));
      });
    });

    group('fromEntity', () {
      test('creates model from AiInsightEntity', () {
        const entity = AiInsightEntity(
          summaryBullets: ['Bullet A', 'Bullet B'],
          tone: 'supportive',
          toneExplanation: 'The tone is supportive.',
          politicalLeaning: 'center-left',
          sourceContext: 'The publication leans liberal.',
          emphasisAnalysis: 'Emphasizes benefits; downplays risks.',
        );

        final model = AiInsightModel.fromEntity(entity);

        expect(model.summaryBullets, entity.summaryBullets);
        expect(model.tone, entity.tone);
        expect(model.toneExplanation, entity.toneExplanation);
        expect(model.politicalLeaning, entity.politicalLeaning);
        expect(model.sourceContext, entity.sourceContext);
        expect(model.emphasisAnalysis, entity.emphasisAnalysis);
      });
    });

    group('toEntity', () {
      test('converts to AiInsightEntity with all fields preserved', () {
        final entity = tModel.toEntity();

        expect(entity, isA<AiInsightEntity>());
        expect(entity.summaryBullets, tModel.summaryBullets);
        expect(entity.tone, tModel.tone);
        expect(entity.toneExplanation, tModel.toneExplanation);
        expect(entity.politicalLeaning, tModel.politicalLeaning);
        expect(entity.sourceContext, tModel.sourceContext);
        expect(entity.emphasisAnalysis, tModel.emphasisAnalysis);
      });

      test('round-trips through fromEntity/toEntity', () {
        const originalEntity = AiInsightEntity(
          summaryBullets: ['X', 'Y'],
          tone: 'analytical',
          toneExplanation: 'Deep dive tone',
          politicalLeaning: 'center-right',
          sourceContext: 'Academic publication',
          emphasisAnalysis: 'Data-heavy approach',
        );

        final roundTripped =
            AiInsightModel.fromEntity(originalEntity).toEntity();

        expect(roundTripped, equals(originalEntity));
      });
    });

    group('equality', () {
      test('supports value equality via Equatable', () {
        const model1 = AiInsightModel(
          summaryBullets: ['A'],
          tone: 'neutral',
          toneExplanation: 'Exp',
          politicalLeaning: 'center',
          sourceContext: 'Ctx',
          emphasisAnalysis: 'Ana',
        );
        const model2 = AiInsightModel(
          summaryBullets: ['A'],
          tone: 'neutral',
          toneExplanation: 'Exp',
          politicalLeaning: 'center',
          sourceContext: 'Ctx',
          emphasisAnalysis: 'Ana',
        );

        expect(model1, equals(model2));
      });

      test('models with different fields are not equal', () {
        const model1 = AiInsightModel(
          summaryBullets: ['A'],
          tone: 'neutral',
          toneExplanation: 'Exp',
          politicalLeaning: 'center',
          sourceContext: 'Ctx',
          emphasisAnalysis: 'Ana',
        );
        const model2 = AiInsightModel(
          summaryBullets: ['B'],
          tone: 'neutral',
          toneExplanation: 'Exp',
          politicalLeaning: 'center',
          sourceContext: 'Ctx',
          emphasisAnalysis: 'Ana',
        );

        expect(model1, isNot(equals(model2)));
      });

      test('models with different politicalLeaning are not equal', () {
        const model1 = AiInsightModel(
          summaryBullets: ['A'],
          tone: 'neutral',
          toneExplanation: 'Exp',
          politicalLeaning: 'left',
          sourceContext: 'Ctx',
          emphasisAnalysis: 'Ana',
        );
        const model2 = AiInsightModel(
          summaryBullets: ['A'],
          tone: 'neutral',
          toneExplanation: 'Exp',
          politicalLeaning: 'right',
          sourceContext: 'Ctx',
          emphasisAnalysis: 'Ana',
        );

        expect(model1, isNot(equals(model2)));
      });
    });
  });
}
