import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:news_assistant/router.dart';
import 'package:news_assistant/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'News',
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      theme: customLightTheme,
      darkTheme: customDarkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
