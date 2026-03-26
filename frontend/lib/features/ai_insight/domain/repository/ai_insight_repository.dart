import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/params/get_insight_params.dart';

/// Abstract repository interface for AI article insights.
///
/// Implemented by the data layer with cache-first logic:
/// 1. Check Firestore cache for existing insight
/// 2. If miss, call Gemini API and cache the result
/// 3. Return the insight entity wrapped in [DataState]
abstract class AiInsightRepository {
  /// Gets an AI-generated insight for the given article parameters.
  ///
  /// Returns [DataSuccess] with the insight entity, or [DataFailed]
  /// with an [AppException] on error.
  Future<DataState<AiInsightEntity>> getArticleInsight(
    GetInsightParams params,
  );
}
