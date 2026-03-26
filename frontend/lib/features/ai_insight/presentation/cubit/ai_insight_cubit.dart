import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/params/get_insight_params.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/usecases/get_article_insight_usecase.dart';
import 'package:news_app_clean_architecture/features/ai_insight/presentation/cubit/ai_insight_state.dart';

/// Cubit that manages the AI Insight panel state.
///
/// Exposes a single [getInsight] method that accepts article fields
/// and emits Loading → Loaded | Error states.
class AiInsightCubit extends Cubit<AiInsightState> {
  final GetArticleInsightUseCase _getArticleInsightUseCase;

  AiInsightCubit({
    required GetArticleInsightUseCase getArticleInsightUseCase,
  })  : _getArticleInsightUseCase = getArticleInsightUseCase,
        super(const AiInsightInitial());

  /// Fetches an AI insight for the given article.
  ///
  /// Emits [AiInsightLoading] immediately, then either [AiInsightLoaded]
  /// or [AiInsightError] based on the result.
  Future<void> getInsight({
    required String title,
    String? description,
    String? content,
    String? source,
    String? url,
  }) async {
    emit(const AiInsightLoading());

    try {
      final result = await _getArticleInsightUseCase.call(
        params: GetInsightParams(
          title: title,
          description: description,
          content: content,
          source: source,
          url: url,
        ),
      );

      if (result is DataSuccess) {
        emit(AiInsightLoaded(insight: result.data!));
      } else {
        emit(AiInsightError(
          error: result.error ??
              const AppException(
                message: 'Failed to generate insight',
                identifier: 'getInsight',
              ),
        ));
      }
    } catch (e) {
      emit(AiInsightError(
        error: AppException(
          message: e.toString(),
          identifier: 'getInsight',
        ),
      ));
    }
  }
}
