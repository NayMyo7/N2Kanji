/// Utility functions for converting database values to Dart types
class DbValueConverter {
  DbValueConverter._();

  /// Safely converts a database value to an integer
  static int toInt(Object? value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Safely converts a database value to a string
  static String toStringValue(Object? value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}
