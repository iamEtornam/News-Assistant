import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

String getTimeAgo(DateTime referenceTime) {
  final now = DateTime.now();
  final difference = now.difference(referenceTime);
  final inSeconds = difference.inSeconds.abs();

  if (inSeconds < 60) {
    return "just now";
  } else if (inSeconds < 3600) {
    final minutes = (inSeconds / 60).floor();
    final plural = minutes > 1 ? "minutes" : "minute";
    return "$minutes $plural ago";
  } else if (inSeconds < 86400) {
    final hours = (inSeconds / 3600).floor();
    final plural = hours > 1 ? "hours" : "hour";
    return "$hours $plural ago";
  } else if (inSeconds < 604800) {
    // Less than a week
    final days = (inSeconds / 86400).floor();
    final plural = days > 1 ? "days" : "day";
    return "$days $plural ago";
  } else if (inSeconds < 2592000) {
    // Less than a month (approx 4 weeks)
    final weeks = (inSeconds / 604800).floor();
    final plural = weeks > 1 ? "weeks" : "week";
    return "$weeks $plural ago";
  } else if (referenceTime.year == now.year) {
    final months = now.month - referenceTime.month;
    if (months == 1) {
      return "last month";
    } else {
      return "$months months ago";
    }
  } else {
    final years = now.year - referenceTime.year;
    final plural = years > 1 ? "years" : "year";
    return "$years $plural ago";
  }
}

List<TextSpan> parseMarkdown(String text) {
  List<TextSpan> spans = [];
  RegExp exp = RegExp(r'\*\*(.*?)\*\*');
  String tempText = text;

  while (exp.hasMatch(tempText)) {
    final match = exp.firstMatch(tempText);
    if (match != null) {
      final beforeText = tempText.substring(0, match.start);
      final boldText = match.group(1);

      if (beforeText.isNotEmpty) {
        spans.add(TextSpan(text: beforeText));
        spans.add(const TextSpan(text: '\n\n'));
      }
      if (boldText != null) {
        spans.add(
          TextSpan(
            text: boldText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      tempText = tempText.substring(match.end);
    }
  }

  if (tempText.isNotEmpty) {
    spans.add(TextSpan(text: tempText));
  }

  return spans;
}

Future<String?> getMainArticleContent(String url) async {
  try {
    // Send a GET request to the URL
    var response = await http.get(Uri.parse(url));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the HTML content of the page
      var document = parser.parse(response.body);

      // Define CSS selectors for common elements to ignore
      var selectorsToIgnore = [
        'header', 'footer', 'nav', 'aside', 'script', 'style', 'iframe',
        '.menu', '.popup', '.promotion', '.advertisement', '.related'
        // Add more selectors if needed
      ];

      // Remove elements matching the specified selectors
      for (var selector in selectorsToIgnore) {
        document.querySelectorAll(selector).forEach((element) {
          element.remove(); // Remove the element from the document
        });
      }

      // Extract and return the text content of the remaining elements
      return document.body?.text;
    } else {
      print('Failed to fetch the webpage. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return null;
}
