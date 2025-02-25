import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getTopHeadlines({
    required String country,
    String? category,
    int page = 1,
  });

  Future<Either<Failure, List<Article>>> searchNews({
    required String query,
    String? sortBy,
    int page = 1,
  });

  Future<Either<Failure, List<Article>>> getCachedNews();
}
