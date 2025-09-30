import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/entities/news_entity.dart';
import 'package:news_app/features/news/presentation/widgets/article_item.dart';

class NewsList extends StatelessWidget {
  final List<News> news;
  final bool isLoading;
  final ScrollController scrollController;
  final Function(News) onTap;

  const NewsList({
    super.key,
    required this.news,
    required this.isLoading,
    required this.scrollController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: news.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == news.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final article = news[index];

        return ArticleItem(
          news: article,
          onTap: () => onTap(article),
        );
      },
    );
  }
}