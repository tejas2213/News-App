import 'package:news_app/features/news/data/datasources/local/news_local_data_source.dart';
import 'package:news_app/features/news/data/datasources/remote/news_remote_data_source.dart';
import 'package:news_app/features/news/data/models/news_model.dart';
import 'package:news_app/features/news/domain/entities/news_entity.dart';
import 'package:news_app/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<News>> getNews({int page = 1}) async {
    try {
      final news = await remoteDataSource.getNews(page: page);
      await _cacheNews(news);
      return news;
    } catch (e) {
      final cachedNews = await localDataSource.getSavedNews();
      return cachedNews.map((model) => model.toEntity()).toList();
    }
  }

  Future<void> _cacheNews(List<News> news) async {
    for (final item in news) {
      await localDataSource.saveNews(NewsModel.fromEntity(item));
    }
  }
}

