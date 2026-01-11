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

  factory Kanji.fromRow(Map<String, Object?> row) {
    return Kanji(
      id: _asInt(row['ID']),
      day: _asInt(row['DAY']),
      kanji: _asString(row['KANJI']),
      onyomi: _asString(row['ONYOMI']),
      kunyomi: _asString(row['KUNYOMI']),
    );
  }
}
