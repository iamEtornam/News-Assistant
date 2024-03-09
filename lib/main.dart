import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_assistant/app.dart';
import 'package:news_assistant/services/services.dart';

void main() {
  setupInjector();
  runApp(const ProviderScope(child: App()));
}
