import 'package:flutter/material.dart';

import '../domain/models/word.dart';

/// Utility class for displaying word information in a SnackBar.
class WordInfoSnackBar {
  WordInfoSnackBar._();

  /// Shows a SnackBar with word's week, day, and ID information.
  static void show(BuildContext context, Word word) {
    final week = ((word.day - 1) ~/ 7) + 1;
    final dayOfWeek = ((word.day - 1) % 7) + 1;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Week $week / Day $dayOfWeek / No. ${word.wordId}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        width: 200,
      ),
    );
  }
}
