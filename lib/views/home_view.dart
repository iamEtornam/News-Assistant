import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_assistant/components/category_chip.dart';
import 'package:news_assistant/components/my_app_bar.dart';
import 'package:news_assistant/resources/resources.dart';
import 'package:news_assistant/router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final scrollController = ScrollController();
  String categotySelected = 'General';
  final categories = [
    'General',
    'Sports',
    'Business',
    'Entertainment',
    'Health',
    'Science',
    'Technology',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 37,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    categories.length,
                    (index) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CategoryChip(
                            isSelected: categotySelected == categories[index],
                            label: categories[index],
                            onTap: () {
                              setState(() {
                                categotySelected = categories[index];
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
          NewsCard(
            onTap: () {},
          ),
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
          ListView.separated(
              controller: scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return NewsCard(
                  onTap: () {
                    context.pushNamed(
                      Routes.details.name,
                      pathParameters: {
                        'id': index.toString(),
                      }
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              itemCount: 10)
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

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
              ClipRRect(
                borderRadius: BorderRadius.circular(13.75),
                child: SizedBox(
                  height: 167,
                  child: Stack(
                    children: [
                      Image.asset(
                        Images.placeholder,
                        fit: BoxFit.fill,
                        height: 167,
                        width: MediaQuery.sizeOf(context).width,
                      ),
                      Container(
                        height: 167,
                        width: MediaQuery.sizeOf(context).width,
                        color: Colors.red.withOpacity(.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 29 / 2,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'CNN Philippines',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '10 minutes ago',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Traffic in Philippines\' Capital City of Manila Worsens Despite Measures to Ease Congestion',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
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
