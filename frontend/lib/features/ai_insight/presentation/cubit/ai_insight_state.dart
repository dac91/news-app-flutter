import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';

/// States for the AI Insight feature.
///
/// Flow: Initial → Loading → Loaded | Error
abstract class AiInsightState extends Equatable {
  const AiInsightState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no insight requested yet.
class AiInsightInitial extends AiInsightState {
  const AiInsightInitial();
}

/// Insight is being fetched (from cache or Gemini API).
class AiInsightLoading extends AiInsightState {
  const AiInsightLoading();
}

/// Insight loaded successfully.
class AiInsightLoaded extends AiInsightState {
  final AiInsightEntity insight;

  const AiInsightLoaded({required this.insight});

  @override
  List<Object?> get props => [insight];
}

/// An error occurred while fetching the insight.
class AiInsightError extends AiInsightState {
  final AppException error;

  const AiInsightError({required this.error});

  @override
  List<Object?> get props => [error];
}
