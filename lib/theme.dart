import 'package:flutter/material.dart';
import 'package:news_assistant/components/color_schemes.dart';

ThemeData get customLightTheme {
  return ThemeData.light().copyWith(colorScheme: lightColorScheme);
}

ThemeData get customDarkTheme {
  return ThemeData.dark().copyWith(colorScheme: darkColorScheme);
}
