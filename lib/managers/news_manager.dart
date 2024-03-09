import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:news_assistant/models/news.dart';
import 'package:news_assistant/services/news_service.dart';

class NewsManager extends ChangeNotifier {
  final NewsServices newsServices;

  NewsManager(this.newsServices);

  Future<News> getHeadlines({String country = 'us'}) async {
    return await newsServices.headlines(country: country);
  }

  Future<News> getOtherNews({String country = 'us'}) async {
    return await newsServices.otherNews(country: country);
  }

  Future<GenerateContentResponse> summarize({required String article}) async {
    return await newsServices.summarize(articleuRL: article);
  }

  Future <GenerateContentResponse> translate(
      {required String text, required String language}) async {
    return await newsServices.translate(text: text, language: language);
  }
}
