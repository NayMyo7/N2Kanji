import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _configured = false;

  Future<void> _ensureConfigured() async {
    if (_configured) return;

    await _tts.setLanguage('ja-JP');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    _configured = true;
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> speak(String text) async {
    final t = text.trim();
    if (t.isEmpty) return;

    await _ensureConfigured();

    // Prevent overlapping speech.
    await _tts.stop();
    await _tts.speak(t);
  }

  String sanitizeKana(String kana) {
    // Remove helper kana in parentheses like: (な), (に), etc.
    // Also remove full-width parentheses.
    final stripped = kana
        .replaceAll(RegExp(r'\([^)]*\)'), '')
        .replaceAll(RegExp(r'（[^）]*）'), '')
        .replaceAll('　', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return stripped;
  }
}
