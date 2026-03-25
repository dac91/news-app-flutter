import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';

import '../../../../domain/entities/article.dart';

abstract class LocalArticlesState extends Equatable {
  final List<ArticleEntity>? articles;

  const LocalArticlesState({this.articles});

  @override
  List<Object?> get props => [articles];
}

class LocalArticlesLoading extends LocalArticlesState {
  const LocalArticlesLoading();
}

class LocalArticlesDone extends LocalArticlesState {
  const LocalArticlesDone(List<ArticleEntity> articles)
      : super(articles: articles);
}

/// Error state for local database operations (e.g. read/write failures).
///
/// Previously missing — DB failures were silently swallowed, leaving the
/// UI stuck in a loading state with no feedback.
class LocalArticlesError extends LocalArticlesState {
  final AppException error;

  const LocalArticlesError(this.error);

  @override
  List<Object?> get props => [error];
}