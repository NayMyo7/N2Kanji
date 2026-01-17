// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ttsService)
final ttsServiceProvider = TtsServiceProvider._();

final class TtsServiceProvider
    extends $FunctionalProvider<TtsService, TtsService, TtsService>
    with $Provider<TtsService> {
  TtsServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ttsServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ttsServiceHash();

  @$internal
  @override
  $ProviderElement<TtsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TtsService create(Ref ref) {
    return ttsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TtsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TtsService>(value),
    );
  }
}

String _$ttsServiceHash() => r'0368d32fcaab21675054355a723c27b57d6f7b98';
