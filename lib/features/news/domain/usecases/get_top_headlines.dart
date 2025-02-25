import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlines {
  final NewsRepository repository;

  GetTopHeadlines(this.repository);

  Future<Either<Failure, List<Article>>> call(TopHeadlinesParams params) async {
    return await repository.getTopHeadlines(
      country: params.country,
      category: params.category,
      page: params.page,
    );
  }
}

class TopHeadlinesParams extends Equatable {
  final String country;
  final String? category;
  final int page;

  const TopHeadlinesParams({
    required this.country,
    this.category,
    this.page = 1,
  });

  @override
  List<Object?> get props => [country, category, page];
}
