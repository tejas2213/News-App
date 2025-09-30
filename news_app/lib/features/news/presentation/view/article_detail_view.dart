import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/news/domain/entities/news_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailView extends ConsumerWidget {
  final News news;

  const ArticleDetailView({super.key, required this.news});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(news.sourceName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: news.imageUrl!,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    height: 150,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    height: 150,
                    width: double.infinity,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),

            const SizedBox(height: 16),
            Text(news.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            if (news.creator != null && news.creator!.isNotEmpty)
              Text(
                'By ${news.creator!.join(', ')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 8),
            Text(
              'Published: ${_formatDate(news.pubDate)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              news.description ?? 'No content available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _launchUrl(context, news.link),
              child: const Text('Read full article'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error launching URL: $e')));
      }
    }
  }
}
