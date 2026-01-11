import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

class KanjiStrokePainter extends CustomPainter {
  KanjiStrokePainter({
    required this.strokes,
    required this.viewBox,
    required this.activeStroke,
    required this.activeProgress,
    required this.completedColor,
    required this.guideColor,
    required this.activeColor,
    required this.strokeWidth,
    required this.showGuide,
    this.showStartDot = false,
    this.startDotColor = const Color(0x66000000),
    this.startDotRadius = 8,
  });

  final List<Path> strokes;
  final Rect viewBox;
  final int activeStroke;
  final double activeProgress;
  final Color completedColor;
  final Color guideColor;
  final Color activeColor;
  final double strokeWidth;
  final bool showGuide;
  final bool showStartDot;
  final Color startDotColor;
  final double startDotRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (strokes.isEmpty) return;

    final scaleX = size.width / viewBox.width;
    final scaleY = size.height / viewBox.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;
    final dx = (size.width - viewBox.width * scale) / 2;
    final dy = (size.height - viewBox.height * scale) / 2;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);
    canvas.translate(-viewBox.left, -viewBox.top);

    Paint strokePaint(Color color) {
      return Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = strokeWidth / scale
        ..color = color;
    }

    if (showGuide) {
      final guidePaint = strokePaint(guideColor);
      for (final p in strokes) {
        canvas.drawPath(p, guidePaint);
      }
    }

    final completedPaint = strokePaint(completedColor);
    final activePaint = strokePaint(activeColor);

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = startDotColor;

    for (var i = 0; i < strokes.length; i++) {
      if (i < activeStroke) {
        canvas.drawPath(strokes[i], completedPaint);
      } else if (i == activeStroke) {
        final metric = strokes[i].computeMetrics().firstOrNull;
        if (metric == null) continue;

        Offset? startPos;
        if (showStartDot) {
          startPos = metric.getTangentForOffset(0)?.position;
        }

        final length = metric.length;
        final end = (length * activeProgress).clamp(0.0, length);
        final partial = metric.extractPath(0, end);
        canvas.drawPath(partial, activePaint);

        if (showStartDot && startPos != null) {
          canvas.drawCircle(startPos, startDotRadius / scale, dotPaint);
        }
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant KanjiStrokePainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.activeStroke != activeStroke ||
        oldDelegate.activeProgress != activeProgress ||
        oldDelegate.completedColor != completedColor ||
        oldDelegate.guideColor != guideColor ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.showGuide != showGuide ||
        oldDelegate.showStartDot != showStartDot ||
        oldDelegate.startDotColor != startDotColor ||
        oldDelegate.startDotRadius != startDotRadius;
  }
}

extension on Iterable<PathMetric> {
  PathMetric? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
