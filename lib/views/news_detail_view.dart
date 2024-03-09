import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:news_assistant/components/news_agency_header.dart';
import 'package:news_assistant/models/news.dart';
import 'package:news_assistant/resources/resources.dart';
import 'package:news_assistant/router.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView(
      {super.key, required this.articles, required this.heroTag});

  final Articles articles;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        onBookmark: () {},
        onShare: () =>
            Share.share('Hey! Check out this article: ${articles.url}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(.2),
                    shape: const StadiumBorder()),
                onPressed: () =>
                    context.pushNamed(Routes.summarize.name, extra: articles),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(Svgs.stars,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'AI Summarize',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                )),
          ),
          SizedBox(
            height: 310,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewsAgencyHeader(imageSize: 25, articles: articles),
                Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13.75),
                    child: SizedBox(
                      height: 216,
                      child: Stack(
                        children: [
                          articles.urlToImage == null
                              ? Image.asset(
                                  Images.placeholder,
                                  fit: BoxFit.fill,
                                  height: 216,
                                  width: MediaQuery.sizeOf(context).width,
                                )
                              : CachedNetworkImage(
                                  imageUrl: articles.urlToImage!,
                                  fit: BoxFit.fill,
                                  height: 216,
                                  width: MediaQuery.sizeOf(context).width,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    Images.placeholder,
                                    fit: BoxFit.fill,
                                    height: 167,
                                    width: MediaQuery.sizeOf(context).width,
                                  ),
                                ),
                          Container(
                            height: 216,
                            width: MediaQuery.sizeOf(context).width,
                            color: Colors.black.withOpacity(.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text('NEWS HEADLINE',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 10),
          Text(articles.title!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  letterSpacing: 0,
                  height: 1.1)),
          const SizedBox(height: 10),
          Text(
            '''${articles.content ?? articles.description}''',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}

class AppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBar({super.key, required this.onShare, required this.onBookmark});

  final VoidCallback onShare;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(Svgs.back),
                  const SizedBox(width: 10),
                  RichText(
                      text: TextSpan(
                          text: 'Back to ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.normal),
                          children: [
                        TextSpan(
                          text: '\nHome',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        )
                      ])),
                ],
              ),
            ),
            const Spacer(),
            InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(Svgs.bookmark),
                )),
            InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(Svgs.share),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + 5 + (Platform.isAndroid ? 24 : 0));
}
