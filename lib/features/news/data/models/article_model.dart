import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required String id,
    required String title,
    required String description,
    required String content,
    required String author,
    required String url,
    required String imageUrl,
    required DateTime publishedAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          content: content,
          author: author,
          url: url,
          imageUrl: imageUrl,
          publishedAt: publishedAt,
        );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['source']['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': {'id': id},
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'url': url,
      'urlToImage': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}
