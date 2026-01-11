import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _configured = false;

  Future<void> _ensureConfigured() async {
    if (_configured) return;

    // Web TTS support in flutter_tts is limited and platform-specific.
    if (kIsWeb) {
      _configured = true;
      return;
    }

    await _tts.setLanguage('ja-JP');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    _configured = true;
  }

  Future<void> stop() async {
    if (kIsWeb) return;
    await _tts.stop();
  }

  Future<void> speak(String text) async {
    final t = text.trim();
    if (t.isEmpty) return;

    await _ensureConfigured();
    if (kIsWeb) return;

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
