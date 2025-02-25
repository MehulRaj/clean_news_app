import 'package:equatable/equatable.dart';

class ArticleSummary extends Equatable {
  final String originalContent;
  final String summary;
  final DateTime generatedAt;
  final int wordCount;
  final double readingTime;

  const ArticleSummary({
    required this.originalContent,
    required this.summary,
    required this.generatedAt,
    required this.wordCount,
    required this.readingTime,
  });

  @override
  List<Object?> get props => [
        originalContent,
        summary,
        generatedAt,
        wordCount,
        readingTime,
      ];
}
