// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(kanjiList)
final kanjiListProvider = KanjiListProvider._();

final class KanjiListProvider extends $FunctionalProvider<
        AsyncValue<List<Kanji>>, List<Kanji>, FutureOr<List<Kanji>>>
    with $FutureModifier<List<Kanji>>, $FutureProvider<List<Kanji>> {
  KanjiListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'kanjiListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$kanjiListHash();

  @$internal
  @override
  $FutureProviderElement<List<Kanji>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Kanji>> create(Ref ref) {
    return kanjiList(ref);
  }
}

String _$kanjiListHash() => r'd550e39674bae47e2158eff9b011bab2f58b8a00';

@ProviderFor(SelectedKanjiId)
final selectedKanjiIdProvider = SelectedKanjiIdProvider._();

final class SelectedKanjiIdProvider
    extends $AsyncNotifierProvider<SelectedKanjiId, int?> {
  SelectedKanjiIdProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedKanjiIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedKanjiIdHash();

  @$internal
  @override
  SelectedKanjiId create() => SelectedKanjiId();
}

String _$selectedKanjiIdHash() => r'a5bdc2407f2740dc7798709044b95c97377ba693';

abstract class _$SelectedKanjiId extends $AsyncNotifier<int?> {
  FutureOr<int?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int?>, int?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int?>, int?>,
        AsyncValue<int?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(dayWords)
final dayWordsProvider = DayWordsProvider._();

final class DayWordsProvider extends $FunctionalProvider<
    AsyncValue<List<Word>>,
    AsyncValue<List<Word>>,
    AsyncValue<List<Word>>> with $Provider<AsyncValue<List<Word>>> {
  DayWordsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dayWordsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dayWordsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Word>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<List<Word>> create(Ref ref) {
    return dayWords(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Word>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Word>>>(value),
    );
  }
}

String _$dayWordsHash() => r'334993ba6ab47956ecb893d57471249138522f72';
