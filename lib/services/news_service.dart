import 'dart:convert';

import 'package:http/http.dart';
import 'package:news_assistant/models/news.dart';

abstract class NewsServices {
  Future<News> headlines({String country = 'us'});
  Future<News> otherNews({String country = 'us'});
}

class NewsServicesImpl extends NewsServices {
  final baseUrl = "https://newsapi.org/v2/";
  final apiKey = const String.fromEnvironment('NEWS-API-KEY');
  @override
  Future<News> headlines({String country = 'us'}) async {
    final url =
        Uri.parse('$baseUrl/top-headlines?country=$country&apiKey=$apiKey');
    final response = await get(url);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return News.fromJson(body);
    } else {
      throw Exception('${body['message'] ?? response.statusCode}');
    }
  }

  @override
  Future<News> otherNews({String country = 'us'}) async {
        final url =
        Uri.parse('$baseUrl/everything?q=$country&sortBy=popularity&apiKey=$apiKey');
    final response = await get(url);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return News.fromJson(body);
    } else {
      throw Exception('${body['message'] ?? response.statusCode}');
    }
  }
}
