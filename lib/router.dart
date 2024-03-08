import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_assistant/models/news.dart';
import 'package:news_assistant/views/ai_summarize_view.dart';
import 'package:news_assistant/views/home_view.dart';
import 'package:news_assistant/views/news_detail_view.dart';
import 'package:news_assistant/views/splash_view.dart';

class Routes {
  static ({String name, String path}) initialRoute = (name: '/', path: '/');
  static ({String name, String path}) home = (name: 'home', path: '/home');
  static ({String name, String path}) details =
      (name: 'details', path: 'details');
  static ({String name, String path}) summarize = (name: 'summarize', path: 'summarize');

}

final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    observers: [BotToastNavigatorObserver()],
    initialLocation: Routes.initialRoute.path,
    routes: <GoRoute>[
      GoRoute(
        path: Routes.initialRoute.path,
        name: Routes.initialRoute.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SplashView(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
          path: Routes.home.path,
          name: Routes.home.name,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const HomeView(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
          routes: [
            GoRoute(
              path: Routes.details.path,
              name: Routes.details.name,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: NewsDetailView(
                    articles: state.extra as Articles,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInOutCirc)
                          .animate(animation),
                      child: child,
                    );
                  },
                );
              },
              routes: [
                 GoRoute(
                    path: Routes.summarize.path,
                    name: Routes.summarize.name,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: AiSummarizeView(
                          article: state.extra as Articles,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: CurveTween(curve: Curves.easeInOutCirc)
                                .animate(animation),
                            child: child,
                          );
                        },
                      );
                    },
                  ),
              ]
            ),
          ]),
    ]);
