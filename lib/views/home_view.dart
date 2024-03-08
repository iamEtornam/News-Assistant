import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_assistant/components/category_chip.dart';
import 'package:news_assistant/components/my_app_bar.dart';
import 'package:news_assistant/managers/news_manager.dart';
import 'package:news_assistant/models/news.dart';
import 'package:news_assistant/resources/resources.dart';
import 'package:news_assistant/router.dart';
import 'package:news_assistant/services/news_service.dart';
import 'package:news_assistant/services/services.dart';
import 'package:news_assistant/utils/util.dart';

final _newsService = getIt.get<NewsServices>();
final _newsManager =
    ChangeNotifierProvider<NewsManager>((ref) => NewsManager(_newsService));

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final scrollController = ScrollController();
  String categotySelected = 'All';
  @override
  Widget build(BuildContext context) {
    final newsManager = ref.read(_newsManager);

    return Scaffold(
      appBar: const MyAppBar(),
      body: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          FutureBuilder<News>(
              future: newsManager.getHeadlines(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return const LinearProgressIndicator();
                }

                final articles = snapshot.data?.articles ?? [];

                if (articles.isEmpty) {
                  return const Center(
                    child: Text('No articles found'),
                  );
                }

                final categories =
                    articles.map((e) => e.source!.name).toSet().toList();
                categories.insert(0, 'All');
                final displayArticles = articles.where((element) {
                  if (categotySelected == 'All') {
                    return true;
                  }
                  return element.source!.name == categotySelected;
                }).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 38,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              categories.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: CategoryChip(
                                      isSelected:
                                          categotySelected == categories[index],
                                      label: categories[index]!,
                                      onTap: () {
                                        setState(() {
                                          categotySelected = categories[index]!;
                                        });
                                      },
                                    ),
                                  ))),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      'Inbound Now!',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 265,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: MediaQuery.sizeOf(context).width / 1.2,
                              child: NewsCard(
                                article: displayArticles[index],
                                onTap: () => context.pushNamed(
                                    Routes.details.name,
                                    extra: displayArticles[index]),
                              ),
                            );
                          },
                          separatorBuilder: (__, _) => const SizedBox(
                                width: 10,
                              ),
                          itemCount: displayArticles.length),
                    ),
                  ],
                );
              }),
          const SizedBox(
            height: 18,
          ),
          Text(
            'Other News:',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 12),
          FutureBuilder<News>(
              future: newsManager.getOtherNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final articles = snapshot.data?.articles ?? [];

                if (articles.isEmpty) {
                  return const Center(
                    child: Text('No articles found'),
                  );
                }

                final displayArticles = articles.where((element) {
                  if (categotySelected == 'All') {
                    return true;
                  }
                  return element.source!.name == categotySelected;
                }).toList();
                return ListView.separated(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return NewsCard(
                        article: displayArticles[index],
                        onTap: () => context.pushNamed(Routes.details.name,
                            extra: displayArticles[index]),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10);
                    },
                    itemCount: 10);
              })
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.onTap,
    required this.article,
  });

  final VoidCallback onTap;
  final Articles article;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: .5,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Hero(
                tag: article.title!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13.75),
                  child: SizedBox(
                    height: 167,
                    child: Stack(
                      children: [
                        article.urlToImage == null
                            ? Image.asset(
                                Images.placeholder,
                                fit: BoxFit.fill,
                                height: 167,
                                width: MediaQuery.sizeOf(context).width,
                              )
                            : CachedNetworkImage(
                                imageUrl: article.urlToImage!,
                                fit: BoxFit.fill,
                                height: 167,
                                width: MediaQuery.sizeOf(context).width,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
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
                          height: 167,
                          width: MediaQuery.sizeOf(context).width,
                          color: Colors.black.withOpacity(.2),
                        ),
                        NewsAgencyHeader(
                          article: article,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '''${article.title}''',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: 0,
                    height: 1.1),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NewsAgencyHeader extends StatelessWidget {
  const NewsAgencyHeader({
    super.key,
    required this.article,
  });

  final Articles article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 29 / 2,
                child: Text(
                  article.source!.name![0],
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                article.source?.name ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Spacer(),
          Text(
            getTimeAgo(DateTime.parse(article.publishedAt!)),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
