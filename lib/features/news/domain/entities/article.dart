import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String description;
  final String content;
  final String author;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;

  const Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        author,
        url,
        imageUrl,
        publishedAt,
      ];
}
