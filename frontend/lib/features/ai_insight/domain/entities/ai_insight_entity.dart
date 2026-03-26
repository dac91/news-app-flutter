import 'package:equatable/equatable.dart';

/// Domain entity representing an AI-generated insight for a news article.
///
/// Contains a summary, tone analysis, source context, and emphasis analysis.
/// This is a value object with no framework dependencies (pure Dart).
class AiInsightEntity extends Equatable {
  /// 3-5 bullet point summary of the article's key facts.
  final List<String> summaryBullets;

  /// Tone classification: e.g. "neutral", "critical", "supportive".
  final String tone;

  /// One-sentence description of the tone in context.
  final String toneExplanation;

  /// Background context about the source publication.
  final String sourceContext;

  /// Key angles the article emphasizes, and perspectives that may be absent.
  final String emphasisAnalysis;

  const AiInsightEntity({
    required this.summaryBullets,
    required this.tone,
    required this.toneExplanation,
    required this.sourceContext,
    required this.emphasisAnalysis,
  });

  @override
  List<Object?> get props => [
        summaryBullets,
        tone,
        toneExplanation,
        sourceContext,
        emphasisAnalysis,
      ];
}
