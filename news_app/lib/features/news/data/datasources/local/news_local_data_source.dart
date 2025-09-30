import 'package:news_app/features/news/data/database/app_database.dart';
import 'package:news_app/features/news/data/models/news_model.dart';

abstract class NewsLocalDataSource {
  Future<List<NewsModel>> getSavedNews();
  Future<void> saveNews(NewsModel news);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final AppDatabase database;

  NewsLocalDataSourceImpl({required this.database});

  @override
  Future<List<NewsModel>> getSavedNews() async {
    return await database.getNews();
  }

  @override
  Future<void> saveNews(NewsModel news) async {
    await database.insertNews(news);
  }
}