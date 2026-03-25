import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

/// Parameters for fetching articles with optional filters.
class GetArticleParams {
  final String? category;
  final String? query;
  final int? page;
  final int? pageSize;

  const GetArticleParams({this.category, this.query, this.page, this.pageSize});
}

class GetArticleUseCase
    implements UseCase<DataState<List<ArticleEntity>>, GetArticleParams?> {
  final ArticleRepository _articleRepository;

  GetArticleUseCase(this._articleRepository);

  @override
  Future<DataState<List<ArticleEntity>>> call({GetArticleParams? params}) {
    return _articleRepository.getNewsArticles(
      category: params?.category,
      query: params?.query,
      page: params?.page,
      pageSize: params?.pageSize,
    );
  }
}