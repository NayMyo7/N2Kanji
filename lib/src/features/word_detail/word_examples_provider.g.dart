// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_examples_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wordExamplesService)
final wordExamplesServiceProvider = WordExamplesServiceProvider._();

final class WordExamplesServiceProvider extends $FunctionalProvider<
    WordExamplesService,
    WordExamplesService,
    WordExamplesService> with $Provider<WordExamplesService> {
  WordExamplesServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'wordExamplesServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wordExamplesServiceHash();

  @$internal
  @override
  $ProviderElement<WordExamplesService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WordExamplesService create(Ref ref) {
    return wordExamplesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WordExamplesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WordExamplesService>(value),
    );
  }
}

String _$wordExamplesServiceHash() =>
    r'29d5573a92bbc92b48fbb6e8414d8685e60908f4';

@ProviderFor(wordExamples)
final wordExamplesProvider = WordExamplesFamily._();

final class WordExamplesProvider extends $FunctionalProvider<
        AsyncValue<List<TatoebaExample>>,
        List<TatoebaExample>,
        FutureOr<List<TatoebaExample>>>
    with
        $FutureModifier<List<TatoebaExample>>,
        $FutureProvider<List<TatoebaExample>> {
  WordExamplesProvider._(
      {required WordExamplesFamily super.from,
      required ({
        String query,
        int limit,
      })
          super.argument})
      : super(
          retry: null,
          name: r'wordExamplesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wordExamplesHash();

  @override
  String toString() {
    return r'wordExamplesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TatoebaExample>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<TatoebaExample>> create(Ref ref) {
    final argument = this.argument as ({
      String query,
      int limit,
    });
    return wordExamples(
      ref,
      query: argument.query,
      limit: argument.limit,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WordExamplesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wordExamplesHash() => r'720c0ad7dce40eeac9a17c7c2e06d8d8abc1db02';

final class WordExamplesFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<TatoebaExample>>,
            ({
              String query,
              int limit,
            })> {
  WordExamplesFamily._()
      : super(
          retry: null,
          name: r'wordExamplesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WordExamplesProvider call({
    required String query,
    required int limit,
  }) =>
      WordExamplesProvider._(argument: (
        query: query,
        limit: limit,
      ), from: this);

  @override
  String toString() => r'wordExamplesProvider';
}
