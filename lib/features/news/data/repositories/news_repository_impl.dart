import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlines({
    required String country,
    String? category,
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final articles = await remoteDataSource.getTopHeadlines(
          country: country,
          category: category,
          page: page,
        );
        if (page == 1) {
          await localDataSource.cacheNews(articles);
        }
        return Right(articles);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localArticles = await localDataSource.getCachedNews();
        return Right(localArticles);
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<Article>>> searchNews({
    required String query,
    String? sortBy,
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final articles = await remoteDataSource.searchNews(
          query: query,
          sortBy: sortBy,
          page: page,
        );
        return Right(articles);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getCachedNews() async {
    try {
      final localArticles = await localDataSource.getCachedNews();
      return Right(localArticles);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
