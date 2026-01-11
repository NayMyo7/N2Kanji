import 'package:flutter/material.dart';

/// App color constants based on Sou Matome book palette.
abstract final class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF4F6D7A);
  static const Color secondary = Color(0xFFA14A4A);
  static const Color accent = Color(0xFF33CCAF);

  // Background colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF4F6F8);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;

  // Semantic colors
  static const Color error = secondary;
  static const Color divider = Color(0xFFE0E0E0);
  static const Color favouriteActive = Color(0xFFFFC107);
  static const Color favouriteInactive = Color(0xFFBDBDBD);

  // Kanji reading colors
  static const Color onyomiReading = Color(0xFF40C4FF);
  static const Color kunyomiReading = Color(0xFF33CCAF);
}
