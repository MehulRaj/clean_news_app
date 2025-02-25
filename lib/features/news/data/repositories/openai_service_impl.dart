import 'package:dartz/dartz.dart';
import 'package:dart_openai/dart_openai.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/article_summary.dart';
import '../../domain/repositories/ai_service.dart';

class OpenAIServiceImpl implements AIService {
  final OpenAI openAI;

  OpenAIServiceImpl({required this.openAI});

  @override
  Future<Either<Failure, ArticleSummary>> summarizeArticle(String content) async {
    try {
      final response = await openAI.chat.create(
        model: 'gpt-3.5-turbo',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(
              'You are a professional news summarizer. Create a concise summary of the following article.',
            )],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(content)],
          ),
        ],
      );

      final summary = response.choices.first.message.content?.first.text ?? '';
      final wordCount = summary.split(' ').length;
      final readingTime = wordCount / 200; // Average reading speed: 200 words/minute

      return Right(
        ArticleSummary(
          originalContent: content,
          summary: summary.toString(),
          generatedAt: DateTime.now(),
          wordCount: wordCount,
          readingTime: readingTime,
        ),
      );
    } catch (e) {
      return Left(const AIFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPersonalizedRecommendations(
    List<String> userInterests,
    List<String> readArticles,
  ) async {
    try {
      final response = await openAI.chat.create(
        model: 'gpt-3.5-turbo',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(
              'You are a news recommendation system. Based on the user\'s interests and reading history, suggest relevant news categories and topics.',
            )],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text('''
              User Interests: ${userInterests.join(', ')}
              Recently Read: ${readArticles.join(', ')}
              Suggest 5 most relevant topics or categories for this user.
            ''')],
          ),
        ],
      );

      final List<String> recommendations = (response.choices.first.message.content
          ?.first.text?.split('\n') ?? [])
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim())
          .cast<String>()
          .toList();

      return Right(recommendations);
    } catch (e) {
      return Left(const AIFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> analyzeUserPreferences(
    List<String> readArticles,
    List<String> interactions,
  ) async {
    try {
      final response = await openAI.chat.create(
        model: 'gpt-3.5-turbo',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(
              'You are a user preference analyzer. Analyze the user\'s reading history and interactions to determine their category preferences.',
            )],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text('''
              Read Articles: ${readArticles.join(', ')}
              Interactions: ${interactions.join(', ')}
              Analyze and provide category weights as percentages.
            ''')],
          ),
        ],
      );

      // Parse the response into category weights
      final weights = <String, double>{};
      final lines = response.choices.first.message.content?.first.text?.split('\n') ?? [];
      for (var line in lines) {
        if (line.contains(':')) {
          final parts = line.split(':');
          final category = parts[0].trim();
          final weight = double.tryParse(parts[1].trim().replaceAll('%', '')) ?? 0;
          weights[category] = weight / 100;
        }
      }

      return Right(weights);
    } catch (e) {
      return Left(const AIFailure());
    }
  }
}
