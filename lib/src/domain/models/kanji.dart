import '../../data/db/db_value_converters.dart';

class Kanji {
  const Kanji({
    required this.id,
    required this.day,
    required this.kanji,
    required this.onyomi,
    required this.kunyomi,
  });

  final int id;
  final int day;
  final String kanji;
  final String onyomi;
  final String kunyomi;

  factory Kanji.fromRow(Map<String, Object?> row) {
    return Kanji(
      id: DbValueConverter.toInt(row['ID']),
      day: DbValueConverter.toInt(row['DAY']),
      kanji: DbValueConverter.toStringValue(row['KANJI']),
      onyomi: DbValueConverter.toStringValue(row['ONYOMI']),
      kunyomi: DbValueConverter.toStringValue(row['KUNYOMI']),
    );
  }
}
