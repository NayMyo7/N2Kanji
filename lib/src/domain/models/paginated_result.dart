/// Represents a paginated result from a database query
class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;

  bool get hasMore => (page * pageSize) < totalCount;
  int get totalPages => (totalCount / pageSize).ceil();
  bool get isFirstPage => page == 1;
  bool get isLastPage => !hasMore;
}

/// Parameters for paginated queries
class PaginationParams {
  const PaginationParams({
    this.page = 1,
    this.pageSize = 50,
  });

  final int page;
  final int pageSize;

  int get offset => (page - 1) * pageSize;
  int get limit => pageSize;

  PaginationParams copyWith({int? page, int? pageSize}) {
    return PaginationParams(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  PaginationParams nextPage() => copyWith(page: page + 1);
  PaginationParams previousPage() => copyWith(page: page > 1 ? page - 1 : 1);
  PaginationParams reset() => const PaginationParams();
}

/// Search filters for word queries
class WordSearchFilters {
  const WordSearchFilters({
    this.query,
    this.week,
    this.day,
    this.favouritesOnly = false,
  });

  final String? query;
  final int? week;
  final int? day;
  final bool favouritesOnly;

  bool get hasFilters =>
      query != null || week != null || day != null || favouritesOnly;

  WordSearchFilters copyWith({
    String? query,
    int? week,
    int? day,
    bool? favouritesOnly,
  }) {
    return WordSearchFilters(
      query: query ?? this.query,
      week: week ?? this.week,
      day: day ?? this.day,
      favouritesOnly: favouritesOnly ?? this.favouritesOnly,
    );
  }

  WordSearchFilters clearFilters() => const WordSearchFilters();
}
