import 'package:news_app/features/news/domain/entities/news_entity.dart';

class NewsState {
  final List<News> news;
  final bool isLoading;
  final int currentPage;

  NewsState({
    required this.news,
    required this.isLoading,
    required this.currentPage,
  });

  factory NewsState.initial() {
    return NewsState(
      news: [],
      isLoading: false,
      currentPage: 1,
    );
  }

  NewsState copyWith({
    List<News>? news,
    bool? isLoading,
    int? currentPage,
  }) {
    return NewsState(
      news: news ?? this.news,
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}