import 'package:flutter/material.dart';

import '../features/practice/kanji_stroke_loader.dart';
import '../features/practice/kanji_stroke_painter.dart';

/// A widget that displays a kanji character with stroke animation.
/// Used in study_tab for animated stroke-by-stroke display.
class KanjiStrokePreview extends StatefulWidget {
  const KanjiStrokePreview({required this.character, super.key});

  final String character;

  @override
  State<KanjiStrokePreview> createState() => _KanjiStrokePreviewState();
}

class _KanjiStrokePreviewState extends State<KanjiStrokePreview>
    with SingleTickerProviderStateMixin {
  KanjiStrokeData? _data;
  bool _loading = true;
  late final AnimationController _controller;
  int _strokeIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 450),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _advanceStroke();
          }
        });
    _load();
  }

  @override
  void didUpdateWidget(covariant KanjiStrokePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.character != widget.character) {
      setState(() {
        _data = null;
        _loading = true;
        _strokeIndex = 0;
      });
      _controller.stop();
      _load();
    }
  }

  Future<void> _load() async {
    final loaded = await KanjiStrokeLoader.load(widget.character);
    if (!mounted) return;
    setState(() {
      _data = loaded;
      _loading = false;
      _strokeIndex = 0;
    });

    if (loaded != null && loaded.strokes.isNotEmpty) {
      _controller.forward(from: 0);
    }
  }

  void _advanceStroke() {
    final d = _data;
    if (d == null || d.strokes.isEmpty) return;
    if (_strokeIndex + 1 >= d.strokes.length) {
      setState(() {
        _strokeIndex = d.strokes.length;
      });
      _controller.stop();
      return;
    }

    setState(() {
      _strokeIndex += 1;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    if (_loading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: onPrimary.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '…',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: onPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      );
    }

    if (d == null || d.strokes.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Center(
              child: Text(
                widget.character,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: onPrimary.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '0 strokes',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: onPrimary.withValues(alpha: 0.95),
            ),
          ),
        ],
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _strokeIndex >= d.strokes.length
            ? 1.0
            : _controller.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 74,
              height: 74,
              child: CustomPaint(
                painter: KanjiStrokePainter(
                  strokes: d.strokes,
                  viewBox: d.viewBox,
                  activeStroke: _strokeIndex,
                  activeProgress: progress,
                  completedColor: onPrimary,
                  guideColor: Colors.transparent,
                  activeColor: onPrimary,
                  strokeWidth: 4.5,
                  showGuide: false,
                ),
                child: const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${d.strokes.length} strokes',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: onPrimary.withValues(alpha: 0.95),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A widget that displays a static kanji character with all strokes visible.
/// Used in kanji_practice_screen for non-animated display.
class KanjiStrokeStaticPreview extends StatefulWidget {
  const KanjiStrokeStaticPreview({required this.character, super.key});

  final String character;

  @override
  State<KanjiStrokeStaticPreview> createState() =>
      _KanjiStrokeStaticPreviewState();
}

class _KanjiStrokeStaticPreviewState extends State<KanjiStrokeStaticPreview> {
  KanjiStrokeData? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant KanjiStrokeStaticPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.character != widget.character) {
      setState(() {
        _data = null;
        _loading = true;
      });
      _load();
    }
  }

  Future<void> _load() async {
    final loaded = await KanjiStrokeLoader.load(widget.character);
    if (!mounted) return;
    setState(() {
      _data = loaded;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    if (_loading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: onPrimary.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '…',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: onPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      );
    }

    if (d == null || d.strokes.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Center(
              child: Text(
                widget.character,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: onPrimary.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '0 strokes',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: onPrimary.withValues(alpha: 0.95),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 74,
          height: 74,
          child: CustomPaint(
            painter: KanjiStrokePainter(
              strokes: d.strokes,
              viewBox: d.viewBox,
              activeStroke: d.strokes.length,
              activeProgress: 1.0,
              completedColor: onPrimary,
              guideColor: Colors.transparent,
              activeColor: onPrimary,
              strokeWidth: 4.5,
              showGuide: false,
            ),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${d.strokes.length} strokes',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: onPrimary.withValues(alpha: 0.95),
          ),
        ),
      ],
    );
  }
}
