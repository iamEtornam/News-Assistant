import 'package:flutter/material.dart';
import 'package:news_assistant/models/news.dart';
import 'package:news_assistant/utils/util.dart';

class NewsAgencyHeader extends StatelessWidget {
  const NewsAgencyHeader({
    super.key,
    required this.imageSize,
    this.textColor, required this.articles,
  });

  final double imageSize;
  final Color? textColor;
  final Articles articles;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: SizedBox(
        height: 61,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: imageSize,
                    child: Text(
                articles.source!.name![0],
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  articles.source?.name ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: textColor, fontWeight: FontWeight.w900,fontSize: 20),
                ),
                Text(
                  getTimeAgo(DateTime.parse(articles.publishedAt!)),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: textColor, fontWeight: FontWeight.normal),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
