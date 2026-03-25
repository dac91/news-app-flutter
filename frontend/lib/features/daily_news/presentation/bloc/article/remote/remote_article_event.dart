import 'package:equatable/equatable.dart';

abstract class RemoteArticlesEvent extends Equatable {
  const RemoteArticlesEvent();

  @override
  List<Object?> get props => [];
}

class GetArticles extends RemoteArticlesEvent {
  final String? category;
  final String? query;

  const GetArticles({this.category, this.query});

  @override
  List<Object?> get props => [category, query];
}

/// Loads the next page of articles (infinite scroll).
class LoadMoreArticles extends RemoteArticlesEvent {
  const LoadMoreArticles();
}
