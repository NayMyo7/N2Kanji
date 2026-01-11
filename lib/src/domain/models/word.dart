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

  static int _asInt(Object? value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _asString(Object? value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  factory Word.fromRow(Map<String, Object?> row) {
    return Word(
      wordId: _asInt(row['ID']),
      kanjiId: _asInt(row['KANJI_ID']),
      day: _asInt(row['DAY']),
      kanji: _asString(row['KANJI']),
      kana: _asString(row['KANA']),
      meaning: _asString(row['MEANING']),
      english: _asString(row['ENGLISH']),
      favourite: _asInt(row['FAVOURITE']),
    );
  }
}
