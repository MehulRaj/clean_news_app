import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<List<ArticleModel>> getCachedNews();
  Future<void> cacheNews(List<ArticleModel> articles);
}

const CACHED_NEWS_KEY = 'CACHED_NEWS';

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final SharedPreferences sharedPreferences;

  NewsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ArticleModel>> getCachedNews() async {
    final jsonString = sharedPreferences.getString(CACHED_NEWS_KEY);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((article) => ArticleModel.fromJson(article))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheNews(List<ArticleModel> articles) async {
    final List<Map<String, dynamic>> jsonList =
        articles.map((article) => article.toJson()).toList();
    await sharedPreferences.setString(
      CACHED_NEWS_KEY,
      json.encode(jsonList),
    );
  }
}
