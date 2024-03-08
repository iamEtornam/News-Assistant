import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_assistant/resources/resources.dart';
import 'package:news_assistant/router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController contentCtrl;
  Animation<double>? animation;
  @override
  void initState() {
    super.initState();

    contentCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();

    contentCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.goNamed(Routes.home.name);
      }
    });
  }

  @override
  void dispose() {
    contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          const Spacer(),
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: contentCtrl, curve: Curves.easeInOut),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.125),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: contentCtrl,
                  curve: Curves.easeInOut,
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    Images.logo,
                    width: MediaQuery.sizeOf(context).width / 2,
                  ),
                  Text(
                    'News Assistant',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
