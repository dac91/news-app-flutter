abstract class RemoteArticlesEvent {
  const RemoteArticlesEvent();
}

class GetArticles extends RemoteArticlesEvent {
  final String? category;
  final String? query;

  const GetArticles({this.category, this.query});
}

/// Loads the next page of articles (infinite scroll).
class LoadMoreArticles extends RemoteArticlesEvent {
  const LoadMoreArticles();
}
