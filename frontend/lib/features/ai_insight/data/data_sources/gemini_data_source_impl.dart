import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/data_sources/ai_insight_data_sources.dart';
import 'package:news_app_clean_architecture/features/ai_insight/data/models/ai_insight_model.dart';

/// Google Gemini API implementation of [GeminiDataSource].
///
/// Sends article content to Gemini with a structured prompt requesting
/// perspective context analysis (not fact-checking). Parses the JSON
/// response into an [AiInsightModel].
class GeminiDataSourceImpl implements GeminiDataSource {
  final GenerativeModel _model;

  GeminiDataSourceImpl(this._model);

  /// The structured prompt that frames our request as media literacy
  /// analysis, NOT fact-checking. Based on research findings:
  /// - Grok's binary fact-check has 54.5% accuracy → avoid true/false
  /// - Readers want source context (Reuters DNR 2025)
  /// - Perspective framing builds more trust than verdicts
  static const String _systemPrompt = '''
You are a media literacy assistant. Your job is to help readers understand
news articles better — NOT to fact-check or declare things true/false.

Analyze the article and return a JSON object with these exact keys:
{
  "summaryBullets": ["bullet 1", "bullet 2", "bullet 3"],
  "tone": "neutral" | "critical" | "supportive" | "alarming" | "optimistic" | "analytical",
  "toneExplanation": "One sentence explaining the tone in context of the topic",
  "sourceContext": "Brief background on the publication and its typical editorial perspective. If unknown, say 'Source context not available for this publication.'",
  "emphasisAnalysis": "What angles does this article emphasize? What perspectives or context might be missing?"
}

Rules:
- summaryBullets: 3-5 bullet points covering key facts only (no opinions)
- tone: Pick ONE word from the list above
- toneExplanation: Reference specific word choices or framing that indicate the tone
- sourceContext: Be factual about the publication. Do not speculate.
- emphasisAnalysis: Be balanced. Note what IS covered and what MIGHT be missing.
- Return ONLY valid JSON. No markdown, no code fences, no explanation.
- If the article content is too short or unclear, still provide your best analysis.
''';

  @override
  Future<AiInsightModel> generateInsight({
    required String title,
    String? description,
    String? content,
    String? source,
  }) async {
    final articleText = _buildArticleText(title, description, content, source);

    final response = await _model.generateContent([
      Content.text('$_systemPrompt\n\nArticle to analyze:\n$articleText'),
    ]);

    final responseText = response.text;
    if (responseText == null || responseText.isEmpty) {
      throw Exception('Gemini returned empty response');
    }

    return _parseResponse(responseText);
  }

  String _buildArticleText(
    String title,
    String? description,
    String? content,
    String? source,
  ) {
    final buffer = StringBuffer();
    if (source != null && source.isNotEmpty) {
      buffer.writeln('Source: $source');
    }
    buffer.writeln('Title: $title');
    if (description != null && description.isNotEmpty) {
      buffer.writeln('Description: $description');
    }
    if (content != null && content.isNotEmpty) {
      buffer.writeln('Content: $content');
    }
    return buffer.toString();
  }

  /// Parses the Gemini response, handling common JSON formatting issues.
  AiInsightModel _parseResponse(String responseText) {
    // Strip markdown code fences if present (common Gemini behavior)
    var cleaned = responseText.trim();
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    cleaned = cleaned.trim();

    try {
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return AiInsightModel.fromJson(json);
    } catch (e) {
      throw FormatException(
        'Failed to parse Gemini response as JSON: $e\nRaw: $responseText',
      );
    }
  }
}
