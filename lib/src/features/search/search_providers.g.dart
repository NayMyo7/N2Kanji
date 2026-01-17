// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaginatedSearch)
final paginatedSearchProvider = PaginatedSearchProvider._();

final class PaginatedSearchProvider
    extends $NotifierProvider<PaginatedSearch, SearchState> {
  PaginatedSearchProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'paginatedSearchProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$paginatedSearchHash();

  @$internal
  @override
  PaginatedSearch create() => PaginatedSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchState>(value),
    );
  }
}

String _$paginatedSearchHash() => r'b28601d1f0b76239508ba006c1ff079ae8290f26';

abstract class _$PaginatedSearch extends $Notifier<SearchState> {
  SearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchState, SearchState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SearchState, SearchState>, SearchState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
