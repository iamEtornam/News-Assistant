import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_assistant/components/news_agency_header.dart';
import 'package:news_assistant/resources/resources.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 310,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NewsAgencyHeader(imageSize: 25),
                ClipRRect(
                  borderRadius: BorderRadius.circular(13.75),
                  child: SizedBox(
                    height: 216,
                    child: Stack(
                      children: [
                        Image.asset(
                          Images.placeholder,
                          fit: BoxFit.cover,
                          height: 216,
                          width: MediaQuery.sizeOf(context).width,
                        ),
                        Container(
                          height: 216,
                          width: MediaQuery.sizeOf(context).width,
                          color: Colors.red.withOpacity(.2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text('GENERAL NEWS',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 10),
          Text(
              'Traffic in Philippines\' Capital City of Manila Worsens Despite Measures to Ease Congestion',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w900, fontSize: 24)),
          const SizedBox(height: 10),
          Text(
            '''MANILA, Philippines - Despite efforts to ease traffic congestion in the capital city of Manila, residents are reporting that traffic has only gotten worse. The government has implemented a number of measures in recent years, including the construction of new roadways and the implementation of a color-coded coding scheme for vehicles, but these efforts have done little to alleviate the problem.
According to a recent survey, the average commuter in Manila spends an average of three hours a day stuck in traffic. This has not only caused frustration and inconvenience for residents, but it is also taking a toll on the city's economy. Businesses are struggling to keep up with the high costs of transportation and delivery, and many residents are finding it difficult to make it to work on time.
The government has acknowledged the problem and is looking for new solutions to ease the traffic congestion. Some officials have suggested the implementation of a more comprehensive public transportation system, while others have proposed the construction of new flyovers and underpasses.
As the population and urbanization of Manila is growing rapidly, traffic congestion is becoming a major problem for the city. The government is doing efforts to ease the traffic but seems not enough to solve the problem. Hopefully, new solutions will be implemented soon to improve the quality of life for the residents of Manila.''',
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
  const AppBar({super.key});

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
