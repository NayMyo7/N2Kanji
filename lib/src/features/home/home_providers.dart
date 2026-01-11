import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/kanji.dart';
import '../../domain/models/word.dart';
import '../../state/providers.dart';

final kanjiListProvider = FutureProvider<List<Kanji>>((ref) async {
  final selection = await ref.watch(lessonSelectionProvider.future);
  return ref.watch(repositoryProvider).retrieveKanji(selection.dayOfCourse);
});

class SelectedKanjiIdNotifier extends AsyncNotifier<int?> {
  static const _kPrefix = 'SELECTED_KANJI_ID_DAY_';

  @override
  Future<int?> build() async {
    final selection = await ref.watch(lessonSelectionProvider.future);
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getInt('$_kPrefix${selection.dayOfCourse}');
  }

  Future<void> setSelectedId(int? kanjiId) async {
    final selection = await ref.watch(lessonSelectionProvider.future);
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final key = '$_kPrefix${selection.dayOfCourse}';

    if (kanjiId == null) {
      await prefs.remove(key);
      state = const AsyncData(null);
      return;
    }

    await prefs.setInt(key, kanjiId);
    state = AsyncData(kanjiId);
  }
}

final selectedKanjiIdProvider =
    AsyncNotifierProvider<SelectedKanjiIdNotifier, int?>(
      SelectedKanjiIdNotifier.new,
    );

final dayWordsProvider = Provider<AsyncValue<List<Word>>>((ref) {
  final selection = ref.watch(lessonSelectionProvider);
  final all = ref.watch(wordStoreProvider);

  return selection.when(
    data: (s) {
      return all.whenData(
        (words) =>
            words.where((w) => w.day == s.dayOfCourse).toList(growable: false),
      );
    },
    error: (e, st) => AsyncValue.error(e, st),
    loading: () => const AsyncValue.loading(),
  );
});
