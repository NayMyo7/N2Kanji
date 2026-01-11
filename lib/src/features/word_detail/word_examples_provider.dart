import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'word_examples_service.dart';

final wordExamplesServiceProvider = Provider<WordExamplesService>((ref) {
  return WordExamplesService();
});

final wordExamplesProvider =
    FutureProvider.family<List<TatoebaExample>, ({String query, int limit})>((
      ref,
      params,
    ) {
      final service = ref.watch(wordExamplesServiceProvider);
      return service.fetchExamples(query: params.query, limit: params.limit);
    });
