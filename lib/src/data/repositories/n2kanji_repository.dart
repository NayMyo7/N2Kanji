import '../../domain/models/kanji.dart';
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
    final rows = await _db.rawQuery('SELECT * FROM WORD WHERE KANJI_ID=?', [kanjiId]);
    return rows.map(Word.fromRow).toList(growable: false);
  }

  Future<List<Word>> retrieveAllWord() async {
    final rows = await _db.rawQuery('SELECT * FROM WORD');
    return rows.map(Word.fromRow).toList(growable: false);
  }

  Future<List<Word>> retrieveFavouriteWord() async {
    final rows = await _db.rawQuery('SELECT * FROM WORD WHERE FAVOURITE=?', [1]);
    return rows.map(Word.fromRow).toList(growable: false);
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
