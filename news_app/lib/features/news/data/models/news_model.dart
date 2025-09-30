import 'dart:convert';

import 'package:news_app/features/news/domain/entities/news_entity.dart';

class NewsModel extends News {
  const NewsModel({
    required super.articleId,
    required super.title,
    required super.link,
    required super.creator,
    required super.description,
    required super.content,
    required super.pubDate,
    required super.imageUrl,
    required super.sourceId,
    required super.sourceName,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      articleId: json['article_id'] ?? '',
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      creator: json['creator'] != null ? _parseCreator(json['creator']) : null,
      description: json['description'],
      content: json['content'],
      pubDate: json['pubDate'] ?? '',
      imageUrl: json['image_url'],
      sourceId: json['source_id'] ?? '',
      sourceName: json['source_name'] ?? '',
    );
  }

  static List<String>? _parseCreator(dynamic creator) {
    if (creator is List) {
      return creator.map((e) => e.toString()).toList();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'article_id': articleId,
      'title': title,
      'link': link,
      'creator': creator != null
          ? jsonEncode(creator)
          : null, 
      'description': description,
      'content': content,
      'pubDate': pubDate,
      'image_url': imageUrl,
      'source_id': sourceId,
      'source_name': sourceName,
    };
  }

  factory NewsModel.fromDbMap(Map<String, dynamic> map) {
    return NewsModel(
      articleId: map['article_id'] ?? '',
      title: map['title'] ?? '',
      link: map['link'] ?? '',
      creator: map['creator'] != null
          ? List<String>.from(jsonDecode(map['creator']))
          : null,
      description: map['description'],
      content: map['content'],
      pubDate: map['pubDate'] ?? '',
      imageUrl: map['image_url'],
      sourceId: map['source_id'] ?? '',
      sourceName: map['source_name'] ?? '',
    );
  }

  factory NewsModel.fromEntity(News news) {
    return NewsModel(
      articleId: news.articleId,
      title: news.title,
      link: news.link,
      creator: news.creator,
      description: news.description,
      content: news.content,
      pubDate: news.pubDate,
      imageUrl: news.imageUrl,
      sourceId: news.sourceId,
      sourceName: news.sourceName,
    );
  }
}
