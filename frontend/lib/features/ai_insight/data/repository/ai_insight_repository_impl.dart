import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/data_sources/ai_insight_data_sources.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/params/get_insight_params.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/repository/ai_insight_repository.dart';

/// Concrete implementation of [AiInsightRepository].
///
/// Uses a cache-first strategy:
/// 1. Check Firestore cache for existing insight (by URL hash)
/// 2. On cache miss, call Gemini API to generate the insight
/// 3. Cache the result in Firestore for future requests
/// 4. Return the insight wrapped in [DataState]
///
/// All exceptions are caught and wrapped in [DataFailed(AppException)]
/// at the boundary, keeping the domain layer pure.
class AiInsightRepositoryImpl implements AiInsightRepository {
  final GeminiDataSource _geminiDataSource;
  final InsightCacheDataSource _cacheDataSource;

  AiInsightRepositoryImpl(this._geminiDataSource, this._cacheDataSource);

  @override
  Future<DataState<AiInsightEntity>> getArticleInsight(
    GetInsightParams params,
  ) async {
    try {
      // 1. Check cache first
      final cached = await _cacheDataSource.getCachedInsight(params.cacheKey);
      if (cached != null) {
        return DataSuccess(cached.toEntity());
      }

      // 2. Cache miss — call Gemini API
      final model = await _geminiDataSource.generateInsight(
        title: params.title,
        description: params.description,
        content: params.content,
        source: params.source,
      );

      // 3. Cache the result
      await _cacheDataSource.cacheInsight(params.cacheKey, model);

      return DataSuccess(model.toEntity());
    } catch (e) {
      return DataFailed(
        AppException(
          message: e.toString(),
          identifier: 'getArticleInsight',
        ),
      );
    }
  }
}
