import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_top_headlines.dart';
import '../../domain/usecases/search_news.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;
  final SearchNews searchNews;

  NewsBloc({
    required this.getTopHeadlines,
    required this.searchNews,
  }) : super(NewsInitial()) {
    on<GetTopHeadlinesEvent>(_onGetTopHeadlines);
    on<SearchNewsEvent>(_onSearchNews);
    on<LoadMoreTopHeadlinesEvent>(_onLoadMoreTopHeadlines);
    on<LoadMoreSearchResultsEvent>(_onLoadMoreSearchResults);
  }

  Future<void> _onGetTopHeadlines(
    GetTopHeadlinesEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    final result = await getTopHeadlines(
      TopHeadlinesParams(
        country: event.country,
        category: event.category,
      ),
    );

    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (articles) => emit(NewsLoaded(articles: articles)),
    );
  }

  Future<void> _onSearchNews(
    SearchNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    final result = await searchNews(
      SearchNewsParams(
        query: event.query,
        sortBy: event.sortBy,
      ),
    );

    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (articles) => emit(NewsLoaded(articles: articles)),
    );
  }

  Future<void> _onLoadMoreTopHeadlines(
    LoadMoreTopHeadlinesEvent event,
    Emitter<NewsState> emit,
  ) async {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      final result = await getTopHeadlines(
        TopHeadlinesParams(
          country: event.country,
          category: event.category,
          page: event.page,
        ),
      );

      result.fold(
        (failure) => emit(NewsError(message: failure.message)),
        (newArticles) => emit(
          NewsLoaded(
            articles: [...currentState.articles, ...newArticles],
          ),
        ),
      );
    }
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResultsEvent event,
    Emitter<NewsState> emit,
  ) async {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      final result = await searchNews(
        SearchNewsParams(
          query: event.query,
          sortBy: event.sortBy,
          page: event.page,
        ),
      );

      result.fold(
        (failure) => emit(NewsError(message: failure.message)),
        (newArticles) => emit(
          NewsLoaded(
            articles: [...currentState.articles, ...newArticles],
          ),
        ),
      );
    }
  }
}
