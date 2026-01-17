import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/models.dart';
import '../../state/providers.dart';

part 'favourites_providers.g.dart';

/// State for paginated favourites
class FavouritesState {
  const FavouritesState({
    this.result,
    this.pagination = const PaginationParams(pageSize: 50),
    this.isLoadingMore = false,
    this.error,
  });

  final PaginatedResult<Word>? result;
  final PaginationParams pagination;
  final bool isLoadingMore;
  final Object? error;

  List<Word> get words => result?.items ?? [];
  bool get hasMore => result?.hasMore ?? false;
  int get totalCount => result?.totalCount ?? 0;
  bool get isEmpty => words.isEmpty && !isLoadingMore;

  FavouritesState copyWith({
    PaginatedResult<Word>? result,
    PaginationParams? pagination,
    bool? isLoadingMore,
    Object? error,
    bool clearError = false,
  }) {
    return FavouritesState(
      result: result ?? this.result,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@riverpod
class PaginatedFavourites extends _$PaginatedFavourites {
  @override
  FavouritesState build() {
    // Return empty state initially, load will be triggered by screen
    return const FavouritesState();
  }

  /// Load initial page
  Future<void> loadInitial() async {
    state = state.copyWith(
      pagination: const PaginationParams(pageSize: 50),
      isLoadingMore: true,
      clearError: true,
    );

    try {
      final repo = ref.read(repositoryProvider);
      final result = await repo.retrieveFavouriteWordsPaginated(
        pagination: state.pagination,
      );

      state = state.copyWith(
        result: result,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e,
        isLoadingMore: false,
      );
    }
  }

  /// Reload favourites (call after toggling favourite)
  Future<void> reload() async {
    await loadInitial();
  }

  /// Load next page
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final repo = ref.read(repositoryProvider);
      final nextPagination = state.pagination.nextPage();

      final result = await repo.retrieveFavouriteWordsPaginated(
        pagination: nextPagination,
      );

      // Append new items to existing list
      final currentItems = state.words;
      final combinedResult = PaginatedResult<Word>(
        items: [...currentItems, ...result.items],
        totalCount: result.totalCount,
        page: result.page,
        pageSize: result.pageSize,
      );

      state = state.copyWith(
        result: combinedResult,
        pagination: nextPagination,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e,
        isLoadingMore: false,
      );
    }
  }
}
