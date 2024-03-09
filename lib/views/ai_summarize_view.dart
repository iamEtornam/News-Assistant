import 'dart:developer';

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
  GenerateContentResponse? response;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        loading = true;
      });
      final newsManager = ref.read(_newsManager);

      response = await newsManager.summarize(article: widget.article.url ?? '');
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<GenerateContentResponse?>(
          future: Future.value(response),
          builder: (context, snapshot) {
            if (loading) {
              return const LoadingWidget();
            }

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: SvgPicture.asset(
                      Svgs.close,
                      width: 35,
                    )),
                actions: [
                  if (snapshot.data != null) ...{
                    IconButton(
                        onPressed: () async {
                          if (snapshot.data?.text == null) return;
                          await Clipboard.setData(ClipboardData(
                                  text: snapshot.data?.text ?? ''))
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
                  }
                ],
              ),
              floatingActionButton: snapshot.data == null
                  ? null
                  : FloatingActionButton(
                      onPressed: () async => showTranslationList(),
                      child: const Icon(Icons.translate),
                    ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: snapshot.data == null
                    ? Center(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.sentiment_dissatisfied),
                          Text(
                            '${snapshot.error ?? 'Couldn\t summarize article'}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ))
                    : SelectableText.rich(
                        TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 18), // Default text style
                          children: parseMarkdown(
                            snapshot.data?.text ?? '',
                          ),
                        ),
                      ),
              ),
            );
          }),
    );
  }

  showTranslationList() async {
    final language = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text('French'),
                  onTap: () => Navigator.pop(context, 'French'),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Spanish'),
                  onTap: () => Navigator.pop(context, 'Spanish'),
                )
              ],
            ),
          );
        });

    if (language == null) return;
    if (response?.text == null) return;
    setState(() {
      loading = true;
    });
    final translate = await ref
        .read(_newsManager)
        .translate(text: response?.text ?? '', language: language);
    log('translate: ${translate.text}');

    setState(() {
      response = translate;
      loading = false;
    });
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
