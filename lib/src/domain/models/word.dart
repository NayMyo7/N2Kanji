import '../../data/db/db_value_converters.dart';

class Word {
  const Word({
    required this.wordId,
    required this.kanjiId,
    required this.day,
    required this.kanji,
    required this.kana,
    required this.meaning,
    required this.english,
    required this.favourite,
  });

  final int wordId;
  final int kanjiId;
  final int day;
  final String kanji;
  final String kana;
  final String meaning;
  final String english;
  final int favourite;

  bool get isFavourite => favourite == 1;

  Word copyWith({int? favourite}) {
    return Word(
      wordId: wordId,
      kanjiId: kanjiId,
      day: day,
      kanji: kanji,
      kana: kana,
      meaning: meaning,
      english: english,
      favourite: favourite ?? this.favourite,
    );
  }

  factory Word.fromRow(Map<String, Object?> row) {
    return Word(
      wordId: DbValueConverter.toInt(row['ID']),
      kanjiId: DbValueConverter.toInt(row['KANJI_ID']),
      day: DbValueConverter.toInt(row['DAY']),
      kanji: DbValueConverter.toStringValue(row['KANJI']),
      kana: DbValueConverter.toStringValue(row['KANA']),
      meaning: DbValueConverter.toStringValue(row['MEANING']),
      english: DbValueConverter.toStringValue(row['ENGLISH']),
      favourite: DbValueConverter.toInt(row['FAVOURITE']),
    );
  }
}
