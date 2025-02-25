import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_openai/dart_openai.dart';
import '../firebase/firebase_service.dart';
import '../premium/premium_manager.dart';
import '../tts/text_to_speech_service.dart';
import '../../features/news/data/repositories/openai_service_impl.dart';
import '../../features/news/domain/repositories/ai_service.dart';
import '../../features/news/data/datasources/news_local_data_source.dart';
import '../../features/news/data/datasources/news_remote_data_source.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/news/domain/usecases/get_top_headlines.dart';
import '../../features/news/domain/usecases/search_news.dart';
import '../../features/news/presentation/bloc/news_bloc.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - News
  // Bloc
  sl.registerFactory(
    () => NewsBloc(
      getTopHeadlines: sl(),
      searchNews: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => SearchNews(sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(
      client: sl(),
      apiKey: dotenv.get('NEWS_API_KEY', fallback: '')
    ),
  );

  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  sl.registerLazySingleton(
    () => ApiClient(
      baseUrl: 'https://newsapi.org/v2/',
      logger: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => Logger());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Firebase
  sl.registerLazySingleton(() => FirebaseService());

  // OpenAI
  OpenAI.apiKey = dotenv.get('OPENAI_API_KEY', fallback: '');
  sl.registerLazySingleton<AIService>(
    () => OpenAIServiceImpl(openAI: OpenAI.instance),
  );

  // Premium Features
  sl.registerLazySingleton(() => PremiumManager(sharedPreferences));

  // Text-to-Speech
  sl.registerLazySingleton(() => TextToSpeechService());
}
