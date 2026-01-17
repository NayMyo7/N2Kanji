import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tts_service.dart';

part 'tts_provider.g.dart';

@riverpod
TtsService ttsService(Ref ref) {
  final service = TtsService();
  ref.onDispose(service.stop);
  return service;
}
