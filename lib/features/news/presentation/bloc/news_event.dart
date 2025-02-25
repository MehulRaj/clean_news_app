part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class GetTopHeadlinesEvent extends NewsEvent {
  final String country;
  final String? category;

  const GetTopHeadlinesEvent({
    required this.country,
    this.category,
  });

  @override
  List<Object?> get props => [country, category];
}

class SearchNewsEvent extends NewsEvent {
  final String query;
  final String? sortBy;

  const SearchNewsEvent({
    required this.query,
    this.sortBy,
  });

  @override
  List<Object?> get props => [query, sortBy];
}

class LoadMoreTopHeadlinesEvent extends NewsEvent {
  final String country;
  final String? category;
  final int page;

  const LoadMoreTopHeadlinesEvent({
    required this.country,
    this.category,
    required this.page,
  });

  @override
  List<Object?> get props => [country, category, page];
}

class LoadMoreSearchResultsEvent extends NewsEvent {
  final String query;
  final String? sortBy;
  final int page;

  const LoadMoreSearchResultsEvent({
    required this.query,
    this.sortBy,
    required this.page,
  });

  @override
  List<Object?> get props => [query, sortBy, page];
}
