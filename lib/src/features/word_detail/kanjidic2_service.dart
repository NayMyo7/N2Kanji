import 'dart:convert';

import 'package:flutter/services.dart';

class KanjiDicEntry {
  const KanjiDicEntry({
    required this.literal,
    required this.meanings,
    required this.onyomi,
    required this.kunyomi,
  });

  final String literal;
  final List<String> meanings;
  final List<String> onyomi;
  final List<String> kunyomi;

  factory KanjiDicEntry.fromJson(String literal, Map<String, Object?> json) {
    List<String> asStringList(Object? v) {
      if (v == null) return const <String>[];
      if (v is String) {
        final s = v.trim();
        if (s.isEmpty ||
            s == 'N/A' ||
            s == 'N/A ' ||
            s == ' N/A' ||
            s == ' N/A ') {
          return const <String>[];
        }
        return <String>[s];
      }
      if (v is List) {
        return v
            .whereType<String>()
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty && e != 'N/A')
            .toList(growable: false);
      }
      return const <String>[];
    }

    // Support both our older slim schema and the new kanjidict2.json schema.
    final meanings = asStringList(json['meanings']);
    final onyomi = asStringList(json['on']);
    final kunyomi = asStringList(json['kun']);

    final meanings2 = meanings.isNotEmpty
        ? meanings
        : asStringList(json['meaning']);
    final onyomi2 = onyomi.isNotEmpty ? onyomi : asStringList(json['onyomi']);
    final kunyomi2 = kunyomi.isNotEmpty
        ? kunyomi
        : asStringList(json['kunyomi']);

    return KanjiDicEntry(
      literal: literal,
      meanings: meanings2,
      onyomi: onyomi2,
      kunyomi: kunyomi2,
    );
  }
}

class KanjiDicService {
  static Future<Map<String, KanjiDicEntry>>? _cache;

  Future<Map<String, KanjiDicEntry>> load() {
    _cache ??= _loadInternal();
    return _cache!;
  }

  Future<Map<String, KanjiDicEntry>> _loadInternal() async {
    final raw = await rootBundle.loadString('assets/kanjidict2.json');
    final data = jsonDecode(raw);
    if (data is! Map) return const <String, KanjiDicEntry>{};

    final out = <String, KanjiDicEntry>{};
    data.forEach((key, value) {
      if (key is! String || value is! Map) return;
      out[key] = KanjiDicEntry.fromJson(key, value.cast<String, Object?>());
    });

    return out;
  }
}
