import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/params/get_insight_params.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/repository/ai_insight_repository.dart';

/// Fetches an AI-powered perspective context insight for a news article.
///
/// Delegates to [AiInsightRepository] which handles cache-first logic
/// (Firestore cache → Gemini API fallback).
class GetArticleInsightUseCase
    implements UseCase<DataState<AiInsightEntity>, GetInsightParams> {
  final AiInsightRepository _repository;

  GetArticleInsightUseCase(this._repository);

  @override
  Future<DataState<AiInsightEntity>> call({
    GetInsightParams? params,
  }) {
    if (params == null) {
      throw ArgumentError('GetInsightParams must not be null');
    }
    return _repository.getArticleInsight(params);
  }
}
