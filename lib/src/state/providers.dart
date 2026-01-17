import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/db/n2kanji_database.dart';
import '../data/repositories/n2kanji_repository.dart';
import '../domain/models/word.dart';

part 'providers.g.dart';

@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

@riverpod
N2KanjiDatabase database(Ref ref) {
  final db = N2KanjiDatabase();
  ref.onDispose(db.close);
  return db;
}

@riverpod
N2KanjiRepository repository(Ref ref) {
  return N2KanjiRepository(ref.watch(databaseProvider));
}

@riverpod
class WordStore extends _$WordStore {
  @override
  Future<List<Word>> build() async {
    return ref.watch(repositoryProvider).retrieveAllWord();
  }

  Future<void> toggleFavourite(Word word) async {
    final repo = ref.read(repositoryProvider);

    if (word.isFavourite) {
      await repo.removeFavourite(word.wordId);
    } else {
      await repo.markFavourite(word.wordId);
    }

    final current = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (current == null) {
      state = AsyncData(await repo.retrieveAllWord());
      return;
    }

    state = AsyncData(
      current
          .map(
            (w) => w.wordId == word.wordId
                ? w.copyWith(favourite: word.isFavourite ? 0 : 1)
                : w,
          )
          .toList(growable: false),
    );
  }
}

final allWordsValueProvider = Provider<List<Word>?>((ref) {
  return ref.watch(wordStoreProvider.select((v) => switch (v) {
        AsyncData(:final value) => value,
        _ => null,
      }));
});

final favouriteWordsValueProvider = Provider<List<Word>>((ref) {
  final words = ref.watch(allWordsValueProvider);
  if (words == null) return const <Word>[];
  return words.where((w) => w.isFavourite).toList(growable: false);
});

final favouriteWordsProvider = Provider<AsyncValue<List<Word>>>((ref) {
  final all = ref.watch(wordStoreProvider);
  return all.whenData(
    (words) => words.where((w) => w.isFavourite).toList(growable: false),
  );
});

final wordByIdProvider = Provider.family<AsyncValue<Word?>, int>((ref, wordId) {
  final all = ref.watch(wordStoreProvider);
  return all.whenData((words) {
    for (final w in words) {
      if (w.wordId == wordId) return w;
    }
    return null;
  });
});

final wordByIdValueProvider = Provider.family<Word?, int>((ref, wordId) {
  final words = ref.watch(wordStoreProvider.select((v) => switch (v) {
        AsyncData(:final value) => value,
        _ => null,
      }));
  if (words == null) return null;
  for (final w in words) {
    if (w.wordId == wordId) return w;
  }
  return null;
});

final wordsByKanjiProvider = Provider.family<AsyncValue<List<Word>>, int>((
  ref,
  kanjiId,
) {
  final all = ref.watch(wordStoreProvider);
  return all.whenData(
    (words) => words.where((w) => w.kanjiId == kanjiId).toList(growable: false),
  );
});

final wordsByKanjiValueProvider = Provider.family<List<Word>, int>((
  ref,
  kanjiId,
) {
  final words = ref.watch(allWordsValueProvider);
  if (words == null) return const <Word>[];
  return words.where((w) => w.kanjiId == kanjiId).toList(growable: false);
});

class LessonSelectionData {
  const LessonSelectionData({
    required this.week,
    required this.day,
    required this.position,
  });

  final int week;
  final int day;
  final int position;

  int get dayOfCourse => (week - 1) * 7 + day;

  LessonSelectionData copyWith({int? week, int? day, int? position}) {
    return LessonSelectionData(
      week: week ?? this.week,
      day: day ?? this.day,
      position: position ?? this.position,
    );
  }
}

@riverpod
class LessonSelection extends _$LessonSelection {
  static const _kWeek = 'WEEK';
  static const _kDay = 'DAY';
  static const _kPosition = 'POSITION';

  @override
  Future<LessonSelectionData> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return LessonSelectionData(
      week: prefs.getInt(_kWeek) ?? 1,
      day: prefs.getInt(_kDay) ?? 1,
      position: prefs.getInt(_kPosition) ?? 0,
    );
  }

  Future<void> setWeekDay(int week, int day) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setInt(_kWeek, week);
    await prefs.setInt(_kDay, day);
    await prefs.setInt(_kPosition, 0);
    state = AsyncData(LessonSelectionData(week: week, day: day, position: 0));
  }

  Future<void> setPosition(int position) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final current =
        state.value ?? const LessonSelectionData(week: 1, day: 1, position: 0);
    await prefs.setInt(_kPosition, position);
    state = AsyncData(current.copyWith(position: position));
  }
}
