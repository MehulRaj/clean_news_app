import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/article_summary.dart';

abstract class AIService {
  Future<Either<Failure, ArticleSummary>> summarizeArticle(String content);
  Future<Either<Failure, List<String>>> getPersonalizedRecommendations(
    List<String> userInterests,
    List<String> readArticles,
  );
  Future<Either<Failure, Map<String, double>>> analyzeUserPreferences(
    List<String> readArticles,
    List<String> interactions,
  );
}
