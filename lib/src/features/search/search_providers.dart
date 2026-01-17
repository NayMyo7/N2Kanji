import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/models.dart';
import '../../state/providers.dart';

part 'search_providers.g.dart';

/// State for paginated search
class SearchState {
  const SearchState({
    this.result,
    this.filters = const WordSearchFilters(),
    this.pagination = const PaginationParams(pageSize: 50),
    this.isLoadingMore = false,
    this.error,
  });

  final PaginatedResult<Word>? result;
  final WordSearchFilters filters;
  final PaginationParams pagination;
  final bool isLoadingMore;
  final Object? error;

  List<Word> get words => result?.items ?? [];
  bool get hasMore => result?.hasMore ?? false;
  int get totalCount => result?.totalCount ?? 0;
  bool get isEmpty => words.isEmpty && !isLoadingMore;

  SearchState copyWith({
    PaginatedResult<Word>? result,
    WordSearchFilters? filters,
    PaginationParams? pagination,
    bool? isLoadingMore,
    Object? error,
    bool clearError = false,
  }) {
    return SearchState(
      result: result ?? this.result,
      filters: filters ?? this.filters,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@riverpod
class PaginatedSearch extends _$PaginatedSearch {
  @override
  SearchState build() {
    return const SearchState();
  }

  /// Load initial page with filters
  Future<void> search({
    String? query,
    int? week,
    int? day,
    bool? favouritesOnly,
  }) async {
    final filters = WordSearchFilters(
      query: query?.trim().toLowerCase(),
      week: week,
      day: day,
      favouritesOnly: favouritesOnly ?? false,
    );

    state = state.copyWith(
      filters: filters,
      pagination: const PaginationParams(pageSize: 50),
      isLoadingMore: true,
      clearError: true,
    );

    try {
      final repo = ref.read(repositoryProvider);
      final result = await repo.retrieveWordsPaginated(
        pagination: state.pagination,
        filters: filters,
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

  /// Load next page
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final repo = ref.read(repositoryProvider);
      final nextPagination = state.pagination.nextPage();

      final result = await repo.retrieveWordsPaginated(
        pagination: nextPagination,
        filters: state.filters,
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

  /// Update filters and reset pagination
  Future<void> updateFilters({
    String? query,
    int? week,
    int? day,
    bool? favouritesOnly,
  }) async {
    await search(
      query: query,
      week: week,
      day: day,
      favouritesOnly: favouritesOnly,
    );
  }

  /// Clear all filters and reset
  Future<void> clearFilters() async {
    await search();
  }
}
