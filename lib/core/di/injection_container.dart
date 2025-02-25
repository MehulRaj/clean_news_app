import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      apiKey: dotenv.env['NEWS_API_KEY'] ?? ''
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
}
