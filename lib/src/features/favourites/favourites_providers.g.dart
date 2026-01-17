// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourites_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaginatedFavourites)
final paginatedFavouritesProvider = PaginatedFavouritesProvider._();

final class PaginatedFavouritesProvider
    extends $NotifierProvider<PaginatedFavourites, FavouritesState> {
  PaginatedFavouritesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'paginatedFavouritesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$paginatedFavouritesHash();

  @$internal
  @override
  PaginatedFavourites create() => PaginatedFavourites();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavouritesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavouritesState>(value),
    );
  }
}

String _$paginatedFavouritesHash() =>
    r'ce8d93f8f1590037b3c5a3c06382924e8d47746b';

abstract class _$PaginatedFavourites extends $Notifier<FavouritesState> {
  FavouritesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FavouritesState, FavouritesState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FavouritesState, FavouritesState>,
        FavouritesState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
