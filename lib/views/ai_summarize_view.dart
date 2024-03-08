import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:news_assistant/managers/news_manager.dart';
import 'package:news_assistant/models/news.dart';
import 'package:news_assistant/resources/resources.dart';
import 'package:news_assistant/services/news_service.dart';
import 'package:news_assistant/services/services.dart';
import 'package:news_assistant/utils/util.dart';
import 'package:rive/rive.dart';

final _newsService = getIt.get<NewsServices>();
final _newsManager =
    ChangeNotifierProvider<NewsManager>((ref) => NewsManager(_newsService));

class AiSummarizeView extends ConsumerStatefulWidget {
  const AiSummarizeView({super.key, required this.article});

  final Articles article;

  @override
  ConsumerState<AiSummarizeView> createState() => _AiSummarizeViewState();
}

class _AiSummarizeViewState extends ConsumerState<AiSummarizeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final newsManager = ref.read(_newsManager);

    return Scaffold(
      body: FutureBuilder<GenerateContentResponse>(
          future: newsManager.summarize(article: widget.article.url ?? ''),
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: SvgPicture.asset(
                      Svgs.close,
                      width: 35,
                    )),
                actions: [
                  IconButton(
                      onPressed: () async {
                        if(snapshot.data?.text == null) return;
                        await Clipboard.setData(
                                ClipboardData(text: snapshot.data?.text ?? ''))
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  content: Text('Copied to clipboard!')));
                        });
                      },
                      icon: const Icon(Icons.copy_rounded))
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<GenerateContentResponse>(
                    future: newsManager.summarize(
                        article: widget.article.url ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                        return const LoadingWidget();
                      }
                      return SelectableText.rich(
                        TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 18), // Default text style
                          children: parseMarkdown(
                            snapshot.data?.text ?? '',
                          ),
                        ),
                      );
                    }),
              ),
            );
          }),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        const Center(
          child: SizedBox(
              width: 300,
              height: 300,
              child: RiveAnimation.asset(
                RiveAssets.aiTalk,
              )),
        ),
        const SizedBox(height: 25),
        Text(
          'Get ready for some magic!',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 10),
        Text(
          'Crafting an article summary...',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
        ),
        const SizedBox(height: 25),
        const SizedBox(
            width: 40, height: 40, child: CircularProgressIndicator()),
        const Spacer(),
        const Spacer(),
      ],
    );
  }
}
