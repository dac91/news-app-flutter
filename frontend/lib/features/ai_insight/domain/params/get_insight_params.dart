import 'package:equatable/equatable.dart';

/// Parameters for the [GetArticleInsightUseCase].
///
/// Encapsulates the article fields needed by the AI model to generate
/// a perspective context insight. Uses a cache key derived from the
/// article URL for Firestore deduplication.
class GetInsightParams extends Equatable {
  final String title;
  final String? description;
  final String? content;
  final String? source;
  final String? url;

  const GetInsightParams({
    required this.title,
    this.description,
    this.content,
    this.source,
    this.url,
  });

  /// Generates a deterministic cache key from the article URL.
  /// Falls back to a hash of the title if no URL is available.
  String get cacheKey {
    if (url != null && url!.isNotEmpty) {
      // Use a simple hash of the URL for the Firestore document ID
      return url!.hashCode.toRadixString(16);
    }
    return title.hashCode.toRadixString(16);
  }

  @override
  List<Object?> get props => [title, description, content, source, url];
}
