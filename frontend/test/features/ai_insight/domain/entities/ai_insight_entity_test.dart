import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';

void main() {
  group('AiInsightEntity', () {
    test('supports value equality via Equatable', () {
      const entity1 = AiInsightEntity(
        summaryBullets: ['Bullet 1', 'Bullet 2'],
        tone: 'neutral',
        toneExplanation: 'The article presents facts without bias.',
        sourceContext: 'Reuters is a global wire service.',
        emphasisAnalysis: 'Focuses on economic data; omits social impact.',
      );
      const entity2 = AiInsightEntity(
        summaryBullets: ['Bullet 1', 'Bullet 2'],
        tone: 'neutral',
        toneExplanation: 'The article presents facts without bias.',
        sourceContext: 'Reuters is a global wire service.',
        emphasisAnalysis: 'Focuses on economic data; omits social impact.',
      );

      expect(entity1, equals(entity2));
    });

    test('entities with different fields are not equal', () {
      const entity1 = AiInsightEntity(
        summaryBullets: ['Bullet 1'],
        tone: 'neutral',
        toneExplanation: 'Explanation',
        sourceContext: 'Context',
        emphasisAnalysis: 'Analysis',
      );
      const entity2 = AiInsightEntity(
        summaryBullets: ['Bullet 1'],
        tone: 'critical',
        toneExplanation: 'Explanation',
        sourceContext: 'Context',
        emphasisAnalysis: 'Analysis',
      );

      expect(entity1, isNot(equals(entity2)));
    });

    test('entities with different summaryBullets are not equal', () {
      const entity1 = AiInsightEntity(
        summaryBullets: ['A', 'B'],
        tone: 'neutral',
        toneExplanation: 'Explanation',
        sourceContext: 'Context',
        emphasisAnalysis: 'Analysis',
      );
      const entity2 = AiInsightEntity(
        summaryBullets: ['A', 'C'],
        tone: 'neutral',
        toneExplanation: 'Explanation',
        sourceContext: 'Context',
        emphasisAnalysis: 'Analysis',
      );

      expect(entity1, isNot(equals(entity2)));
    });

    test('props contains all fields', () {
      const entity = AiInsightEntity(
        summaryBullets: ['Point 1'],
        tone: 'supportive',
        toneExplanation: 'Tone explanation text',
        sourceContext: 'Source context text',
        emphasisAnalysis: 'Emphasis analysis text',
      );

      expect(entity.props, [
        ['Point 1'],
        'supportive',
        'Tone explanation text',
        'Source context text',
        'Emphasis analysis text',
      ]);
    });
  });
}
