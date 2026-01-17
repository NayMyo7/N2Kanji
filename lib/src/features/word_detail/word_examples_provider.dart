import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'word_examples_service.dart';

part 'word_examples_provider.g.dart';

@riverpod
WordExamplesService wordExamplesService(Ref ref) {
  return WordExamplesService();
}

@riverpod
Future<List<TatoebaExample>> wordExamples(
  Ref ref, {
  required String query,
  required int limit,
}) {
  final service = ref.watch(wordExamplesServiceProvider);
  return service.fetchExamples(query: query, limit: limit);
}
