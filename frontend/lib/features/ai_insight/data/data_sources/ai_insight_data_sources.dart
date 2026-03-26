import 'package:news_app_clean_architecture/features/ai_insight/data/models/ai_insight_model.dart';

/// Abstract interface for AI model API calls.
///
/// Implemented by [GeminiDataSourceImpl]. Consumed by the repository,
/// never by the presentation or domain layers.
abstract class GeminiDataSource {
  /// Sends article content to the AI model and returns a structured insight.
  ///
  /// The [title], [description], [content], and [source] are article fields
  /// sent as prompt context.
  Future<AiInsightModel> generateInsight({
    required String title,
    String? description,
    String? content,
    String? source,
  });
}

/// Abstract interface for caching AI insights in Firestore.
///
/// Implemented by [FirestoreInsightCacheImpl]. Consumed by the repository,
/// never by the presentation or domain layers.
abstract class InsightCacheDataSource {
  /// Returns a cached insight if one exists for the given [cacheKey].
  Future<AiInsightModel?> getCachedInsight(String cacheKey);

  /// Saves an insight to the cache with the given [cacheKey].
  Future<void> cacheInsight(String cacheKey, AiInsightModel model);
}
