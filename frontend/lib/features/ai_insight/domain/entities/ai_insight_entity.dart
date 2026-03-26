import 'package:equatable/equatable.dart';

/// Domain entity representing an AI-generated insight for a news article.
///
/// Contains a summary, tone analysis, political leaning, source context,
/// and emphasis analysis. This is a value object with no framework
/// dependencies (pure Dart).
///
/// Research backing for `politicalLeaning`:
/// - "Say where the information is from and the political view of the author"
///   — Female, 21, UK (Reuters DNR 2025)
/// - Ground News competitor provides "bias rating by outlet"; our advantage
///   is per-article analysis via Gemini.
class AiInsightEntity extends Equatable {
  /// 3-5 bullet point summary of the article's key facts.
  final List<String> summaryBullets;

  /// Tone classification: e.g. "neutral", "critical", "supportive".
  final String tone;

  /// One-sentence description of the tone in context.
  final String toneExplanation;

  /// Political leaning of the article's perspective.
  ///
  /// One of: "left", "center-left", "center", "center-right", "right",
  /// or "unknown" when the leaning cannot be determined.
  final String politicalLeaning;

  /// Background context about the source publication.
  final String sourceContext;

  /// Key angles the article emphasizes, and perspectives that may be absent.
  final String emphasisAnalysis;

  const AiInsightEntity({
    required this.summaryBullets,
    required this.tone,
    required this.toneExplanation,
    required this.politicalLeaning,
    required this.sourceContext,
    required this.emphasisAnalysis,
  });

  @override
  List<Object?> get props => [
        summaryBullets,
        tone,
        toneExplanation,
        politicalLeaning,
        sourceContext,
        emphasisAnalysis,
      ];
}
