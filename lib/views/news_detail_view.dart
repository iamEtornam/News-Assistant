import 'package:flutter/material.dart';
import 'package:news_assistant/components/category_chip.dart';
import 'package:news_assistant/components/my_app_bar.dart';
import 'package:news_assistant/resources/resources.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [],
      ),
    );
  }
}
