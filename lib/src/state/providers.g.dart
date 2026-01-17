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

String _$sharedPreferencesHash() => r'aa7ace48f3c0dce382957e3c6eac2449573583a9';

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

String _$databaseHash() => r'2788311c4f2389326ceb14fd48cf80b5fe67c67e';

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

String _$repositoryHash() => r'e3d94a51fd587fd63dd2e7b616729f2ceb48ee85';

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
