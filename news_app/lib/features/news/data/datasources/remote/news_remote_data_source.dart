import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/core/constants/app_constants.dart';
import 'package:news_app/features/news/data/models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews({int page = 1});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<NewsModel>> getNews({int page = 1}) async {
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}?apikey=${AppConstants.apiKey}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((json) => NewsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}