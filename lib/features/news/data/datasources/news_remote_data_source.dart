import '../../../../core/network/api_client.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({
    required String country,
    String? category,
    int page = 1,
  });

  Future<List<ArticleModel>> searchNews({
    required String query,
    String? sortBy,
    int page = 1,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient client;
  final String apiKey;

  NewsRemoteDataSourceImpl({
    required this.client,
    required this.apiKey,
  });

  @override
  Future<List<ArticleModel>> getTopHeadlines({
    required String country,
    String? category,
    int page = 1,
  }) async {
    final response = await client.get(
      'top-headlines',
      queryParameters: {
        'country': country,
        if (category != null) 'category': category,
        'page': page,
        'apiKey': apiKey,
      },
    );

    return (response.data['articles'] as List)
        .map((article) => ArticleModel.fromJson(article))
        .toList();
  }

  @override
  Future<List<ArticleModel>> searchNews({
    required String query,
    String? sortBy,
    int page = 1,
  }) async {
    final response = await client.get(
      'everything',
      queryParameters: {
        'q': query,
        if (sortBy != null) 'sortBy': sortBy,
        'page': page,
        'apiKey': apiKey,
      },
    );

    return (response.data['articles'] as List)
        .map((article) => ArticleModel.fromJson(article))
        .toList();
  }
}
