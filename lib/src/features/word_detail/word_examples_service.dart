import 'dart:convert';

import 'package:http/http.dart' as http;

class TatoebaExample {
  const TatoebaExample({required this.japanese, required this.english});

  final String japanese;
  final String english;
}

class WordExamplesService {
  Future<List<TatoebaExample>> fetchExamples({
    required String query,
    int limit = 5,
  }) async {
    final uri = Uri.https('tatoeba.org', '/eng/api_v0/search', <String, String>{
      'from': 'jpn',
      'to': 'eng',
      'query': query,
      'trans_filter': 'limit',
      'trans_to': 'eng',
      'trans_link': 'direct',
      'limit': limit.toString(),
    });

    final res = await http.get(uri);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    if (data is! Map<String, Object?>) {
      return const <TatoebaExample>[];
    }

    final results = data['results'];
    if (results is! List) {
      return const <TatoebaExample>[];
    }

    final examples = <TatoebaExample>[];
    for (final item in results) {
      if (examples.length >= limit) break;
      if (item is! Map) continue;
      final jp = item['text'];
      if (jp is! String || jp.trim().isEmpty) continue;

      final translations = item['translations'];
      final en = _extractFirstEnglish(translations);
      if (en.trim().isEmpty) continue;

      examples.add(TatoebaExample(japanese: jp, english: en));
    }

    return examples;
  }

  String _extractFirstEnglish(Object? translations) {
    if (translations is! List) return '';

    for (final group in translations) {
      if (group is! List) continue;
      for (final t in group) {
        if (t is! Map) continue;
        final lang = t['lang'];
        final text = t['text'];
        if (lang == 'eng' && text is String) {
          return text;
        }
      }
    }

    return '';
  }
}
