import 'package:news_app/features/news/data/models/news_model.dart';

class News {
  final String articleId;
  final String title;
  final String link;
  final List<String>? creator;
  final String? description;
  final String? content;
  final String pubDate;
  final String? imageUrl;
  final String sourceId;
  final String sourceName;

  const News({
    required this.articleId,
    required this.title,
    required this.link,
    required this.creator,
    required this.description,
    required this.content,
    required this.pubDate,
    required this.imageUrl,
    required this.sourceId,
    required this.sourceName,
  });

  NewsModel toModel() {
    return NewsModel(
      articleId: articleId,
      title: title,
      link: link,
      creator: creator,
      description: description,
      content: content,
      pubDate: pubDate,
      imageUrl: imageUrl,
      sourceId: sourceId,
      sourceName: sourceName,
    );
  }

  News toEntity() {
    return News(
      articleId: articleId,
      title: title,
      link: link,
      creator: creator,
      description: description,
      content: content,
      pubDate: pubDate,
      imageUrl: imageUrl,
      sourceId: sourceId,
      sourceName: sourceName,
    );
  }
}