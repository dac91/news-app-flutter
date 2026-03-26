import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/features/ai_insight/domain/entities/ai_insight_entity.dart';

/// Data model for AI insights with serialization support.
///
/// Extends [AiInsightEntity] to add JSON serialization for Firestore
/// caching and Gemini API response parsing.
class AiInsightModel extends Equatable {
  final List<String> summaryBullets;
  final String tone;
  final String toneExplanation;
  final String politicalLeaning;
  final String sourceContext;
  final String emphasisAnalysis;

  const AiInsightModel({
    required this.summaryBullets,
    required this.tone,
    required this.toneExplanation,
    required this.politicalLeaning,
    required this.sourceContext,
    required this.emphasisAnalysis,
  });

  /// Creates an [AiInsightModel] from a JSON map (Firestore or parsed API).
  factory AiInsightModel.fromJson(Map<String, dynamic> json) {
    return AiInsightModel(
      summaryBullets: (json['summaryBullets'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tone: json['tone'] as String? ?? 'unknown',
      toneExplanation: json['toneExplanation'] as String? ?? '',
      politicalLeaning: json['politicalLeaning'] as String? ?? 'unknown',
      sourceContext: json['sourceContext'] as String? ?? '',
      emphasisAnalysis: json['emphasisAnalysis'] as String? ?? '',
    );
  }

  /// Creates an [AiInsightModel] from the domain entity.
  factory AiInsightModel.fromEntity(AiInsightEntity entity) {
    return AiInsightModel(
      summaryBullets: entity.summaryBullets,
      tone: entity.tone,
      toneExplanation: entity.toneExplanation,
      politicalLeaning: entity.politicalLeaning,
      sourceContext: entity.sourceContext,
      emphasisAnalysis: entity.emphasisAnalysis,
    );
  }

  /// Converts to a JSON map for Firestore storage.
  Map<String, dynamic> toJson() {
    return {
      'summaryBullets': summaryBullets,
      'tone': tone,
      'toneExplanation': toneExplanation,
      'politicalLeaning': politicalLeaning,
      'sourceContext': sourceContext,
      'emphasisAnalysis': emphasisAnalysis,
    };
  }

  /// Converts to the domain entity.
  AiInsightEntity toEntity() {
    return AiInsightEntity(
      summaryBullets: summaryBullets,
      tone: tone,
      toneExplanation: toneExplanation,
      politicalLeaning: politicalLeaning,
      sourceContext: sourceContext,
      emphasisAnalysis: emphasisAnalysis,
    );
  }

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
