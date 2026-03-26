import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/params/get_insight_params.dart';

void main() {
  group('GetInsightParams', () {
    test('supports value equality via Equatable', () {
      const params1 = GetInsightParams(
        title: 'Test Article',
        description: 'A description',
        content: 'Full content here',
        source: 'Reuters',
        url: 'https://reuters.com/article/123',
      );
      const params2 = GetInsightParams(
        title: 'Test Article',
        description: 'A description',
        content: 'Full content here',
        source: 'Reuters',
        url: 'https://reuters.com/article/123',
      );

      expect(params1, equals(params2));
    });

    test('params with different titles are not equal', () {
      const params1 = GetInsightParams(title: 'Title A');
      const params2 = GetInsightParams(title: 'Title B');

      expect(params1, isNot(equals(params2)));
    });

    test('optional fields default to null', () {
      const params = GetInsightParams(title: 'Only Title');

      expect(params.description, isNull);
      expect(params.content, isNull);
      expect(params.source, isNull);
      expect(params.url, isNull);
    });

    test('cacheKey uses URL hash when URL is provided', () {
      const params = GetInsightParams(
        title: 'Title',
        url: 'https://example.com/article/1',
      );

      final key = params.cacheKey;
      expect(key, equals(params.url!.hashCode.toRadixString(16)));
      expect(key, isNotEmpty);
    });

    test('cacheKey falls back to title hash when URL is null', () {
      const params = GetInsightParams(title: 'Fallback Title');

      final key = params.cacheKey;
      expect(key, equals('Fallback Title'.hashCode.toRadixString(16)));
    });

    test('cacheKey falls back to title hash when URL is empty', () {
      const params = GetInsightParams(title: 'Empty URL Title', url: '');

      final key = params.cacheKey;
      expect(key, equals('Empty URL Title'.hashCode.toRadixString(16)));
    });

    test('same URL produces same cache key', () {
      const params1 = GetInsightParams(
        title: 'Title A',
        url: 'https://example.com/same',
      );
      const params2 = GetInsightParams(
        title: 'Title B',
        url: 'https://example.com/same',
      );

      expect(params1.cacheKey, equals(params2.cacheKey));
    });

    test('different URLs produce different cache keys', () {
      const params1 = GetInsightParams(
        title: 'Title',
        url: 'https://example.com/a',
      );
      const params2 = GetInsightParams(
        title: 'Title',
        url: 'https://example.com/b',
      );

      expect(params1.cacheKey, isNot(equals(params2.cacheKey)));
    });

    test('props contains all fields', () {
      const params = GetInsightParams(
        title: 'Title',
        description: 'Desc',
        content: 'Content',
        source: 'Source',
        url: 'https://example.com',
      );

      expect(params.props, [
        'Title',
        'Desc',
        'Content',
        'Source',
        'https://example.com',
      ]);
    });
  });
}
