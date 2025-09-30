import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/features/news/data/database/app_database.dart';
import 'package:news_app/features/news/data/datasources/local/news_local_data_source.dart';
import 'package:news_app/features/news/data/datasources/remote/news_remote_data_source.dart';
import 'package:news_app/features/news/data/repositories/news_repository_impl.dart';
import 'package:news_app/features/news/domain/repositories/news_repository.dart';
import 'package:news_app/features/news/domain/usecases/get_news.dart';
import 'package:news_app/features/news/presentation/providers/news_notifier.dart';
import 'package:news_app/features/news/presentation/providers/news_state.dart';

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  return NewsNotifier(
    getNews: ref.read(getNewsProvider),
  );
});

// Providers for use cases
final getNewsProvider = Provider<GetNews>((ref) {
  return GetNews(ref.read(newsRepositoryProvider));
});

// Repository provider
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    remoteDataSource: ref.read(newsRemoteDataSourceProvider),
    localDataSource: ref.read(newsLocalDataSourceProvider),
  );
});

// Data source providers
final newsRemoteDataSourceProvider = Provider<NewsRemoteDataSource>((ref) {
  return NewsRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});

final newsLocalDataSourceProvider = Provider<NewsLocalDataSource>((ref) {
  return NewsLocalDataSourceImpl(database: ref.read(appDatabaseProvider));
});

final httpClientProvider = Provider((ref) => http.Client());
final appDatabaseProvider = Provider((ref) => AppDatabase.instance);