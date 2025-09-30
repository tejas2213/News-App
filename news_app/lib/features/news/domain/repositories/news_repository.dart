import 'package:news_app/features/news/domain/entities/news_entity.dart';

abstract class NewsRepository {
  Future<List<News>> getNews({int page = 1});
}