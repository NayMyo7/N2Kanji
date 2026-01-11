import 'package:flutter/material.dart';

abstract final class AppSizes {
  static const double xxs = 2;
  static const double xs = 4;
  static const double s6 = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  static const double radiusSm = 10;

  static const double listTileHorizontalPadding = 16;
  static const double listTileVerticalPadding = 4;

  static const double trailingWidth = 28;
  static const double iconButtonBox = 24;
  static const double iconSizeSm = 16;

  static const VisualDensity compactIconDensity = VisualDensity.compact;
  static const BoxConstraints iconButtonTightConstraints =
      BoxConstraints.tightFor(width: iconButtonBox, height: iconButtonBox);
}
