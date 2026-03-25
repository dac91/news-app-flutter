import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import '../../../../domain/entities/article.dart';

abstract class RemoteArticlesState extends Equatable {
  final List<ArticleEntity>? articles;
  final AppException? error;

  const RemoteArticlesState({this.articles, this.error});

  @override
  List<Object?> get props => [articles, error];
}

class RemoteArticlesLoading extends RemoteArticlesState {
  const RemoteArticlesLoading();
}

class RemoteArticlesDone extends RemoteArticlesState {
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const RemoteArticlesDone(
    List<ArticleEntity> articles, {
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  }) : super(articles: articles);

  RemoteArticlesDone copyWith({
    List<ArticleEntity>? articles,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return RemoteArticlesDone(
      articles ?? this.articles ?? [],
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [articles, currentPage, hasReachedMax, isLoadingMore];
}

class RemoteArticlesError extends RemoteArticlesState {
  const RemoteArticlesError(AppException error) : super(error: error);
}