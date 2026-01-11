import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

class KanjiStrokeData {
  const KanjiStrokeData({required this.strokes, required this.viewBox});

  final List<Path> strokes;
  final Rect viewBox;
}

class KanjiStrokeLoader {
  static String assetPathFor(String character) {
    final codePoint = character.runes.isEmpty ? 0 : character.runes.first;
    final hex = codePoint.toRadixString(16).padLeft(5, '0');
    return 'assets/kanjivg/$hex.svg';
  }

  static Future<KanjiStrokeData?> load(String character) async {
    final path = assetPathFor(character);
    try {
      final xml = await rootBundle.loadString(path);
      return _parse(xml);
    } catch (_) {
      return null;
    }
  }

  static KanjiStrokeData _parse(String xmlString) {
    final doc = XmlDocument.parse(xmlString);
    final svg = doc.findAllElements('svg').first;

    Rect viewBox = const Rect.fromLTWH(0, 0, 109, 109);
    final viewBoxAttr = svg.getAttribute('viewBox');
    if (viewBoxAttr != null) {
      final parts = viewBoxAttr
          .split(RegExp(r'\s+'))
          .where((p) => p.trim().isNotEmpty)
          .toList(growable: false);
      if (parts.length == 4) {
        final x = double.tryParse(parts[0]) ?? 0;
        final y = double.tryParse(parts[1]) ?? 0;
        final w = double.tryParse(parts[2]) ?? 109;
        final h = double.tryParse(parts[3]) ?? 109;
        viewBox = Rect.fromLTWH(x, y, w, h);
      }
    }

    final strokeElements = doc
        .findAllElements('path')
        .where((e) {
          final id = e.getAttribute('id') ?? '';
          return id.contains('-s');
        })
        .toList(growable: false);

    final strokes = <Path>[];
    for (final e in strokeElements) {
      final d = e.getAttribute('d');
      if (d == null || d.trim().isEmpty) continue;
      strokes.add(parseSvgPathData(d));
    }

    return KanjiStrokeData(strokes: strokes, viewBox: viewBox);
  }
}
