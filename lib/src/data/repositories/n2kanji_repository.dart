import '../../domain/models/kanji.dart';
import '../../domain/models/paginated_result.dart';
import '../../domain/models/word.dart';
import '../db/n2kanji_database.dart';

class N2KanjiRepository {
  N2KanjiRepository(this._db);

  final N2KanjiDatabase _db;

  Future<List<Kanji>> retrieveKanji(int day) async {
    final rows = await _db.rawQuery('SELECT * FROM KANJI WHERE DAY=?', [day]);
    return rows.map(Kanji.fromRow).toList(growable: false);
  }

  Future<List<Word>> retrieveWord(int kanjiId) async {
    final rows =
        await _db.rawQuery('SELECT * FROM WORD WHERE KANJI_ID=?', [kanjiId]);
    return rows.map(Word.fromRow).toList(growable: false);
  }

  /// Retrieve all words - kept for backward compatibility but consider using paginated version
  Future<List<Word>> retrieveAllWord() async {
    final rows = await _db.rawQuery('SELECT * FROM WORD');
    return rows.map(Word.fromRow).toList(growable: false);
  }

  /// Retrieve paginated words with optional search filters
  Future<PaginatedResult<Word>> retrieveWordsPaginated({
    required PaginationParams pagination,
    WordSearchFilters filters = const WordSearchFilters(),
  }) async {
    final whereConditions = <String>[];
    final whereArgs = <Object?>[];

    // Build WHERE clause based on filters
    if (filters.favouritesOnly) {
      whereConditions.add('FAVOURITE = ?');
      whereArgs.add(1);
    }

    if (filters.week != null) {
      // Calculate day range for the week
      final startDay = (filters.week! - 1) * 7 + 1;
      final endDay = filters.week! * 7;
      whereConditions.add('DAY BETWEEN ? AND ?');
      whereArgs.addAll([startDay, endDay]);
    }

    if (filters.day != null) {
      // Day filter (1-7 for day of week)
      whereConditions.add('((DAY - 1) % 7) + 1 = ?');
      whereArgs.add(filters.day);
    }

    if (filters.query != null && filters.query!.isNotEmpty) {
      final searchQuery = '%${filters.query!.toLowerCase()}%';
      whereConditions.add(
        '(LOWER(KANJI) LIKE ? OR LOWER(KANA) LIKE ? OR LOWER(MEANING) LIKE ? OR LOWER(ENGLISH) LIKE ?)',
      );
      whereArgs.addAll([searchQuery, searchQuery, searchQuery, searchQuery]);
    }

    final whereClause =
        whereConditions.isEmpty ? '' : 'WHERE ${whereConditions.join(' AND ')}';

    // Get total count
    final countResult = await _db.rawQuery(
      'SELECT COUNT(*) as count FROM WORD $whereClause',
      whereArgs,
    );
    final totalCount = countResult.first['count'] as int;

    // Get paginated results
    final rows = await _db.rawQuery(
      'SELECT * FROM WORD $whereClause ORDER BY ID LIMIT ? OFFSET ?',
      [...whereArgs, pagination.limit, pagination.offset],
    );

    final items = rows.map(Word.fromRow).toList(growable: false);

    return PaginatedResult(
      items: items,
      totalCount: totalCount,
      page: pagination.page,
      pageSize: pagination.pageSize,
    );
  }

  /// Retrieve favourite words - kept for backward compatibility
  Future<List<Word>> retrieveFavouriteWord() async {
    final rows =
        await _db.rawQuery('SELECT * FROM WORD WHERE FAVOURITE=?', [1]);
    return rows.map(Word.fromRow).toList(growable: false);
  }

  /// Retrieve paginated favourite words
  Future<PaginatedResult<Word>> retrieveFavouriteWordsPaginated({
    required PaginationParams pagination,
  }) async {
    return retrieveWordsPaginated(
      pagination: pagination,
      filters: const WordSearchFilters(favouritesOnly: true),
    );
  }

  /// Get total word count (useful for UI)
  Future<int> getTotalWordCount() async {
    final result = await _db.rawQuery('SELECT COUNT(*) as count FROM WORD');
    return result.first['count'] as int;
  }

  /// Get favourite word count
  Future<int> getFavouriteWordCount() async {
    final result = await _db.rawQuery(
      'SELECT COUNT(*) as count FROM WORD WHERE FAVOURITE=?',
      [1],
    );
    return result.first['count'] as int;
  }

  Future<void> markFavourite(int id) async {
    await _db.update(
      'WORD',
      {'FAVOURITE': 1},
      where: 'ID=?',
      whereArgs: [id],
    );
  }

  Future<void> removeFavourite(int id) async {
    await _db.update(
      'WORD',
      {'FAVOURITE': 0},
      where: 'ID=?',
      whereArgs: [id],
    );
  }
}
