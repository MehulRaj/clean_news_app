import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class SearchNews {
  final NewsRepository repository;

  SearchNews(this.repository);

  Future<Either<Failure, List<Article>>> call(SearchNewsParams params) async {
    return await repository.searchNews(
      query: params.query,
      sortBy: params.sortBy,
      page: params.page,
    );
  }
}

class SearchNewsParams extends Equatable {
  final String query;
  final String? sortBy;
  final int page;

  const SearchNewsParams({
    required this.query,
    this.sortBy,
    this.page = 1,
  });

  @override
  List<Object?> get props => [query, sortBy, page];
}
