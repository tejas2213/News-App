import 'package:flutter_riverpod/legacy.dart';
import 'package:news_app/features/news/domain/usecases/get_news.dart';
import 'package:news_app/features/news/presentation/providers/news_state.dart';

class NewsNotifier extends StateNotifier<NewsState> {
  final GetNews getNews;

  NewsNotifier({
    required this.getNews,
  }) : super(NewsState.initial());

  Future<void> fetchNews({int page = 1}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      final result = await getNews(page: page);
      state = state.copyWith(
        news: [...state.news, ...result],
        isLoading: false,
        currentPage: page,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshNews() async {
    state = state.copyWith(isLoading: true);
    final result = await getNews(page: 1);
    state = NewsState(
      news: result,
      isLoading: false,
      currentPage: 1,
    );
  }
}