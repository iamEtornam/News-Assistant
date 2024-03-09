import 'dart:convert';
import 'dart:developer';

import 'package:async/async.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart';
import 'package:news_assistant/models/news.dart';
import 'package:news_assistant/utils/util.dart';

abstract class NewsServices {
  Future<News> headlines({String country = 'gh'});
  Future<News> otherNews({String country = 'gh'});
  Future<GenerateContentResponse> summarize({required String articleuRL});
  Future<GenerateContentResponse> translate(
      {required String text, required String language});
}

class NewsServicesImpl extends NewsServices {
  final baseUrl = "https://newsapi.org/v2/";
  final apiKey = const String.fromEnvironment('NEWS-API-KEY');
  final memoizer = AsyncMemoizer<String>();
  final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: const String.fromEnvironment('GEMINI-API-KEY'),
    safetySettings: [
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none)
    ],
  );

  Future<String> fetchDataFromApi(Uri url) async {
    final response = await get(url);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('${body['message'] ?? response.statusCode}');
    }
  }

  @override
  Future<News> headlines({String country = 'us'}) async {
    try {
      final url =
          Uri.parse('$baseUrl/top-headlines?country=$country&apiKey=$apiKey');
      final response =
          await memoizer.runOnce(() async => fetchDataFromApi(url));
      final body = jsonDecode(response);

      return News.fromJson(body);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<News> otherNews({String country = 'us'}) async {
    try {
      final url = Uri.parse(
          '$baseUrl/everything?q=$country&sortBy=popularity&apiKey=$apiKey');
      final response =
          await memoizer.runOnce(() async => fetchDataFromApi(url));
      final body = jsonDecode(response);

      return News.fromJson(body);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GenerateContentResponse> summarize(
      {required String articleuRL}) async {
    try {
      final webContent = await getMainArticleContent(articleuRL);
      final String prompt =
          'Given the following article content, please generate a concise summary'
          ' highlighting the main points and key details. '
          'Ignore any non-relevant elements such as menus, promotions, and '
          'other unrelated information to the main article narrative: $webContent';
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);
      return response;
    } catch (e) {
      log('$e');
      throw Exception(e);
    }
  }

  @override
  Future<GenerateContentResponse> translate(
      {required String text, required String language}) async {
    try {
      final prompt = 'Translate the following text to $language: $text';
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
