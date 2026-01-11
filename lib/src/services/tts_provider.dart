import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tts_service.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(service.stop);
  return service;
});
