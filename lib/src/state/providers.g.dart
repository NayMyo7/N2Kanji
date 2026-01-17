// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider extends $FunctionalProvider<
        AsyncValue<SharedPreferences>,
        SharedPreferences,
        FutureOr<SharedPreferences>>
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  SharedPreferencesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sharedPreferencesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'6c03b929f567eb6f97608f6208b95744ffee3bfd';

@ProviderFor(database)
final databaseProvider = DatabaseProvider._();

final class DatabaseProvider extends $FunctionalProvider<N2KanjiDatabase,
    N2KanjiDatabase, N2KanjiDatabase> with $Provider<N2KanjiDatabase> {
  DatabaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'databaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<N2KanjiDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  N2KanjiDatabase create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(N2KanjiDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<N2KanjiDatabase>(value),
    );
  }
}

String _$databaseHash() => r'b10b02b430f39ef09e5aa94b545311e96e1191fd';

@ProviderFor(repository)
final repositoryProvider = RepositoryProvider._();

final class RepositoryProvider extends $FunctionalProvider<N2KanjiRepository,
    N2KanjiRepository, N2KanjiRepository> with $Provider<N2KanjiRepository> {
  RepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'repositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$repositoryHash();

  @$internal
  @override
  $ProviderElement<N2KanjiRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  N2KanjiRepository create(Ref ref) {
    return repository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(N2KanjiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<N2KanjiRepository>(value),
    );
  }
}

String _$repositoryHash() => r'3f441c1ff14c95f0134a5a4a7ec69dfcc2fd2667';

@ProviderFor(WordStore)
final wordStoreProvider = WordStoreProvider._();

final class WordStoreProvider
    extends $AsyncNotifierProvider<WordStore, List<Word>> {
  WordStoreProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'wordStoreProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wordStoreHash();

  @$internal
  @override
  WordStore create() => WordStore();
}

String _$wordStoreHash() => r'9fcdfa3122dff42cf739a8f84cbfe248b7643c9a';

abstract class _$WordStore extends $AsyncNotifier<List<Word>> {
  FutureOr<List<Word>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Word>>, List<Word>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Word>>, List<Word>>,
        AsyncValue<List<Word>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(allWordsValue)
final allWordsValueProvider = AllWordsValueProvider._();

final class AllWordsValueProvider
    extends $FunctionalProvider<List<Word>?, List<Word>?, List<Word>?>
    with $Provider<List<Word>?> {
  AllWordsValueProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'allWordsValueProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$allWordsValueHash();

  @$internal
  @override
  $ProviderElement<List<Word>?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Word>? create(Ref ref) {
    return allWordsValue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Word>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Word>?>(value),
    );
  }
}

String _$allWordsValueHash() => r'7325825032cc7a9d8a63571eab636c9386e3a086';

@ProviderFor(favouriteWordsValue)
final favouriteWordsValueProvider = FavouriteWordsValueProvider._();

final class FavouriteWordsValueProvider
    extends $FunctionalProvider<List<Word>, List<Word>, List<Word>>
    with $Provider<List<Word>> {
  FavouriteWordsValueProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'favouriteWordsValueProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$favouriteWordsValueHash();

  @$internal
  @override
  $ProviderElement<List<Word>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Word> create(Ref ref) {
    return favouriteWordsValue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Word> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Word>>(value),
    );
  }
}

String _$favouriteWordsValueHash() =>
    r'21d6ac0943c544ab2080950e5f6d353d6b2568cc';

@ProviderFor(favouriteWords)
final favouriteWordsProvider = FavouriteWordsProvider._();

final class FavouriteWordsProvider extends $FunctionalProvider<
    AsyncValue<List<Word>>,
    AsyncValue<List<Word>>,
    AsyncValue<List<Word>>> with $Provider<AsyncValue<List<Word>>> {
  FavouriteWordsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'favouriteWordsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$favouriteWordsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Word>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<List<Word>> create(Ref ref) {
    return favouriteWords(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Word>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Word>>>(value),
    );
  }
}

String _$favouriteWordsHash() => r'697b8a10cd1479c85a9195b5672d5ae963f48643';

@ProviderFor(wordById)
final wordByIdProvider = WordByIdFamily._();

final class WordByIdProvider extends $FunctionalProvider<AsyncValue<Word?>,
    AsyncValue<Word?>, AsyncValue<Word?>> with $Provider<AsyncValue<Word?>> {
  WordByIdProvider._(
      {required WordByIdFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'wordByIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wordByIdHash();

  @override
  String toString() {
    return r'wordByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<Word?>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<Word?> create(Ref ref) {
    final argument = this.argument as int;
    return wordById(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Word?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Word?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WordByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wordByIdHash() => r'1553a28fcf093a6ee8c459c1d2b51e2404853e72';

final class WordByIdFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<Word?>, int> {
  WordByIdFamily._()
      : super(
          retry: null,
          name: r'wordByIdProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WordByIdProvider call(
    int wordId,
  ) =>
      WordByIdProvider._(argument: wordId, from: this);

  @override
  String toString() => r'wordByIdProvider';
}

@ProviderFor(wordByIdValue)
final wordByIdValueProvider = WordByIdValueFamily._();

final class WordByIdValueProvider
    extends $FunctionalProvider<Word?, Word?, Word?> with $Provider<Word?> {
  WordByIdValueProvider._(
      {required WordByIdValueFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'wordByIdValueProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wordByIdValueHash();

  @override
  String toString() {
    return r'wordByIdValueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Word?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Word? create(Ref ref) {
    final argument = this.argument as int;
    return wordByIdValue(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Word? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Word?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WordByIdValueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wordByIdValueHash() => r'e5aff3221d32eb574ec34323d59bd9a95afa35c3';

final class WordByIdValueFamily extends $Family
    with $FunctionalFamilyOverride<Word?, int> {
  WordByIdValueFamily._()
      : super(
          retry: null,
          name: r'wordByIdValueProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WordByIdValueProvider call(
    int wordId,
  ) =>
      WordByIdValueProvider._(argument: wordId, from: this);

  @override
  String toString() => r'wordByIdValueProvider';
}

@ProviderFor(wordsByKanji)
final wordsByKanjiProvider = WordsByKanjiFamily._();

final class WordsByKanjiProvider extends $FunctionalProvider<
    AsyncValue<List<Word>>,
    AsyncValue<List<Word>>,
    AsyncValue<List<Word>>> with $Provider<AsyncValue<List<Word>>> {
  WordsByKanjiProvider._(
      {required WordsByKanjiFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'wordsByKanjiProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wordsByKanjiHash();

  @override
  String toString() {
    return r'wordsByKanjiProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Word>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<List<Word>> create(Ref ref) {
    final argument = this.argument as int;
    return wordsByKanji(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Word>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Word>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WordsByKanjiProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wordsByKanjiHash() => r'a95c62137dc3136d828f40086c39344fa0220e82';

final class WordsByKanjiFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<List<Word>>, int> {
  WordsByKanjiFamily._()
      : super(
          retry: null,
          name: r'wordsByKanjiProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WordsByKanjiProvider call(
    int kanjiId,
  ) =>
      WordsByKanjiProvider._(argument: kanjiId, from: this);

  @override
  String toString() => r'wordsByKanjiProvider';
}

@ProviderFor(wordsByKanjiValue)
final wordsByKanjiValueProvider = WordsByKanjiValueFamily._();

final class WordsByKanjiValueProvider
    extends $FunctionalProvider<List<Word>, List<Word>, List<Word>>
    with $Provider<List<Word>> {
  WordsByKanjiValueProvider._(
      {required WordsByKanjiValueFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'wordsByKanjiValueProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wordsByKanjiValueHash();

  @override
  String toString() {
    return r'wordsByKanjiValueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Word>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Word> create(Ref ref) {
    final argument = this.argument as int;
    return wordsByKanjiValue(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Word> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Word>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WordsByKanjiValueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wordsByKanjiValueHash() => r'e2654d3de872a908c93f530641c8f806a87195f2';

final class WordsByKanjiValueFamily extends $Family
    with $FunctionalFamilyOverride<List<Word>, int> {
  WordsByKanjiValueFamily._()
      : super(
          retry: null,
          name: r'wordsByKanjiValueProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WordsByKanjiValueProvider call(
    int kanjiId,
  ) =>
      WordsByKanjiValueProvider._(argument: kanjiId, from: this);

  @override
  String toString() => r'wordsByKanjiValueProvider';
}

@ProviderFor(LessonSelection)
final lessonSelectionProvider = LessonSelectionProvider._();

final class LessonSelectionProvider
    extends $AsyncNotifierProvider<LessonSelection, LessonSelectionData> {
  LessonSelectionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'lessonSelectionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lessonSelectionHash();

  @$internal
  @override
  LessonSelection create() => LessonSelection();
}

String _$lessonSelectionHash() => r'7f35b7b11db6e4b0892fd04464743b0deb0f6d57';

abstract class _$LessonSelection extends $AsyncNotifier<LessonSelectionData> {
  FutureOr<LessonSelectionData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<LessonSelectionData>, LessonSelectionData>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<LessonSelectionData>, LessonSelectionData>,
        AsyncValue<LessonSelectionData>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
