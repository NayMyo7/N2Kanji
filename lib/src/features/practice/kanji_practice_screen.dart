import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../widgets/widgets.dart';
import '../word_detail/kanjidic2_service.dart';
import 'kanji_stroke_loader.dart';
import 'kanji_stroke_painter.dart';

class KanjiPracticeScreen extends StatefulWidget {
  const KanjiPracticeScreen({required this.character, super.key});

  final String character;

  @override
  State<KanjiPracticeScreen> createState() => _KanjiPracticeScreenState();
}

class _KanjiPracticeScreenState extends State<KanjiPracticeScreen>
    with SingleTickerProviderStateMixin {
  KanjiStrokeData? _data;
  KanjiDicEntry? _kanjiInfo;
  bool _loading = true;

  late final AnimationController _controller;
  int _strokeOrderIndex = 0;
  bool _autoPlay = true;

  int _practiceIndex = 0;
  List<Offset> _currentStroke = <Offset>[];
  Color _inkColor = Colors.black;
  Timer? _errorTimer;
  Size _handwritingSize = Size.zero;
  bool _showHandwritingInstruction = true;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 800),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _nextStroke(auto: true);
          }
        });

    _load();
  }

  Future<void> _load() async {
    final loaded = await KanjiStrokeLoader.load(widget.character);
    final kanjiDic = await KanjiDicService().load();
    if (!mounted) return;
    setState(() {
      _data = loaded;
      _kanjiInfo = kanjiDic[widget.character];
      _loading = false;
      _strokeOrderIndex = 0;
      _practiceIndex = 0;
      _currentStroke = <Offset>[];
      _inkColor = Colors.black;
    });

    if (_autoPlay && loaded != null && loaded.strokes.isNotEmpty) {
      _play();
    }
  }

  void _play() {
    if (_data == null || _data!.strokes.isEmpty) return;
    if (_strokeOrderIndex >= _data!.strokes.length) {
      setState(() => _strokeOrderIndex = 0);
    }
    _controller.forward(from: 0);
  }

  void _togglePlay() {
    setState(() => _autoPlay = !_autoPlay);
    if (_autoPlay) {
      _play();
    } else {
      _controller.stop();
    }
  }

  void _nextStroke({required bool auto}) {
    final d = _data;
    if (d == null || d.strokes.isEmpty) return;

    if (!auto) {
      _controller.stop();
    }

    if (_strokeOrderIndex + 1 >= d.strokes.length) {
      setState(() => _strokeOrderIndex = d.strokes.length);
      _controller.stop();
      return;
    }

    setState(() {
      _strokeOrderIndex += 1;
    });

    if (_autoPlay) {
      _controller.forward(from: 0);
    }
  }

  void _prevStroke() {
    final d = _data;
    if (d == null || d.strokes.isEmpty) return;
    _controller.stop();
    setState(() {
      _strokeOrderIndex = (_strokeOrderIndex - 1).clamp(0, d.strokes.length);
    });
  }

  void _resetAnimation() {
    final d = _data;
    if (d == null || d.strokes.isEmpty) return;
    _controller.stop();
    setState(() => _strokeOrderIndex = 0);
    if (_autoPlay) _controller.forward(from: 0);
  }

  void _clearPractice() {
    _errorTimer?.cancel();
    setState(() {
      _currentStroke = <Offset>[];
      _inkColor = Colors.black;
    });
  }

  void _resetPractice() {
    final d = _data;
    if (d == null || d.strokes.isEmpty) return;
    _errorTimer?.cancel();
    setState(() {
      _practiceIndex = 0;
      _currentStroke = <Offset>[];
      _inkColor = Colors.black;
    });
  }

  void _undoPractice() {
    final d = _data;
    if (d == null || d.strokes.isEmpty) return;
    _errorTimer?.cancel();
    setState(() {
      _practiceIndex = (_practiceIndex - 1).clamp(0, d.strokes.length - 1);
      _currentStroke = <Offset>[];
      _inkColor = Colors.black;
    });
  }

  void _nextPractice() {
    final d = _data;
    if (d == null || d.strokes.isEmpty) return;
    _errorTimer?.cancel();
    setState(() {
      _practiceIndex = (_practiceIndex + 1).clamp(0, d.strokes.length);
      _currentStroke = <Offset>[];
      _inkColor = Colors.black;
    });
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Offset _toCanvas(Offset p, Rect viewBox, Size size) {
    final scaleX = size.width / viewBox.width;
    final scaleY = size.height / viewBox.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;
    final dx = (size.width - viewBox.width * scale) / 2;
    final dy = (size.height - viewBox.height * scale) / 2;
    return Offset(
      dx + (p.dx - viewBox.left) * scale,
      dy + (p.dy - viewBox.top) * scale,
    );
  }

  List<Offset> _resamplePolyline(List<Offset> pts, int n) {
    if (pts.length < 2) return pts;
    final dists = <double>[0];
    var total = 0.0;
    for (var i = 1; i < pts.length; i++) {
      total += (pts[i] - pts[i - 1]).distance;
      dists.add(total);
    }
    if (total == 0) return List<Offset>.filled(n, pts.first);
    final step = total / (n - 1);
    final out = <Offset>[pts.first];
    var target = step;
    var j = 1;
    while (out.length < n - 1) {
      while (j < dists.length - 1 && dists[j] < target) {
        j++;
      }
      final prevD = dists[j - 1];
      final nextD = dists[j];
      final t = nextD == prevD ? 0.0 : (target - prevD) / (nextD - prevD);
      final p = Offset.lerp(pts[j - 1], pts[j], t) ?? pts[j];
      out.add(p);
      target += step;
    }
    out.add(pts.last);
    return out;
  }

  List<Offset> _samplePath(Path path, Rect viewBox, Size size, int n) {
    final metrics = path.computeMetrics().toList(growable: false);
    if (metrics.isEmpty) return const <Offset>[];
    final metric = metrics.first;
    final out = <Offset>[];
    for (var i = 0; i < n; i++) {
      final t = i / (n - 1);
      final pos = metric.getTangentForOffset(metric.length * t)?.position;
      if (pos == null) continue;
      out.add(_toCanvas(pos, viewBox, size));
    }
    return out;
  }

  bool _validateStroke(List<Offset> userStroke, KanjiStrokeData data, int idx) {
    if (userStroke.length < 6) return false;
    if (_handwritingSize == Size.zero) return false;
    if (idx < 0 || idx >= data.strokes.length) return false;

    final targetPts = _samplePath(
      data.strokes[idx],
      data.viewBox,
      _handwritingSize,
      32,
    );
    if (targetPts.length < 2) return false;

    final userPts = _resamplePolyline(userStroke, 32);

    // 1) start proximity
    final startDist = (userPts.first - targetPts.first).distance;
    final diag = math.sqrt(
      _handwritingSize.width * _handwritingSize.width +
          _handwritingSize.height * _handwritingSize.height,
    );
    final startThreshold = diag * 0.06;
    if (startDist > startThreshold) return false;

    // 2) direction check
    final uDir = (userPts.last - userPts.first);
    final tDir = (targetPts.last - targetPts.first);
    final uLen = uDir.distance;
    final tLen = tDir.distance;
    if (uLen < 1 || tLen < 1) return false;
    final cos = (uDir.dx * tDir.dx + uDir.dy * tDir.dy) / (uLen * tLen);
    if (cos < 0.55) return false;

    // 3) shape distance (mean)
    var sum = 0.0;
    for (var i = 0; i < math.min(userPts.length, targetPts.length); i++) {
      sum += (userPts[i] - targetPts[i]).distance;
    }
    final mean = sum / math.min(userPts.length, targetPts.length);
    final meanThreshold = diag * 0.05;
    return mean <= meanThreshold;
  }

  void _onStrokeEnd() {
    final d = _data;
    if (d == null || d.strokes.isEmpty) return;
    if (_practiceIndex >= d.strokes.length) {
      _clearPractice();
      return;
    }

    final ok = _validateStroke(_currentStroke, d, _practiceIndex);
    if (ok) {
      _errorTimer?.cancel();
      setState(() {
        _inkColor = Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.85);
      });

      _errorTimer = Timer(const Duration(milliseconds: 180), () {
        if (!mounted) return;
        setState(() {
          _practiceIndex += 1;
          _currentStroke = <Offset>[];
          _inkColor = Colors.black;
        });
      });
      return;
    }

    _errorTimer?.cancel();
    setState(() {
      _inkColor = AppColors.secondary.withValues(alpha: 0.75);
    });
    _errorTimer = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _currentStroke = <Offset>[];
        _inkColor = Colors.black;
      });
    });
  }

  Widget _buildKanjiDetailHeader() {
    final meanings = _kanjiInfo?.meanings ?? const <String>[];
    final on = _kanjiInfo?.onyomi ?? const <String>[];
    final kun = _kanjiInfo?.kunyomi ?? const <String>[];

    return Container(
      height: 130,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Kanji stroke preview
          SizedBox(
            width: 120,
            child: Center(
              child: KanjiStrokeStaticPreview(character: widget.character),
            ),
          ),
          // Right side: Meaning, Onyomi, Kunyomi
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Line 1: Onyomi
                  if (on.isNotEmpty)
                    Text(
                      on.join(' / '),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onyomiReading,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  // Line 2: Kunyomi
                  if (kun.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        kun.join(' / '),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.kunyomiReading,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  // Line 3: Meanings
                  if (meanings.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        meanings.join(', '),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Kanji')),
      body: _loading
          ? const LoadingIndicator()
          : (_data == null || _data!.strokes.isEmpty)
          ? const EmptyState(
              message: 'Stroke data not found for this character.',
              icon: Icons.info_outline,
            )
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  _buildKanjiDetailHeader(),
                  const TabBar(
                    tabs: [
                      Tab(text: 'Stroke Order'),
                      Tab(text: 'Handwriting'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppSizes.lg),
                          child: Column(
                            children: [
                              Expanded(
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, _) {
                                    final d = _data!;
                                    final activeStroke = _strokeOrderIndex
                                        .clamp(0, d.strokes.length);
                                    final activeProgress = _controller.value;

                                    return CustomPaint(
                                      painter: KanjiStrokePainter(
                                        strokes: d.strokes,
                                        viewBox: d.viewBox,
                                        activeStroke: activeStroke,
                                        activeProgress: activeProgress,
                                        completedColor: theme
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.85),
                                        guideColor: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.12),
                                        activeColor: theme.colorScheme.primary,
                                        strokeWidth: 10,
                                        showGuide: true,
                                        showStartDot: true,
                                        startDotColor: const Color(
                                          0xFF1E88E5,
                                        ).withValues(alpha: 0.45),
                                        startDotRadius: 9,
                                      ),
                                      child: const SizedBox.expand(),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: AppSizes.md),
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Reset',
                                    onPressed: _resetAnimation,
                                    icon: const Icon(Icons.restart_alt),
                                  ),
                                  IconButton(
                                    tooltip: 'Previous stroke',
                                    onPressed: _prevStroke,
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Stroke ${(_strokeOrderIndex + 1).clamp(1, _data!.strokes.length)} / ${_data!.strokes.length}',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Next stroke',
                                    onPressed: () => _nextStroke(auto: false),
                                    icon: const Icon(Icons.chevron_right),
                                  ),
                                  IconButton(
                                    tooltip: _autoPlay ? 'Pause' : 'Play',
                                    onPressed: _togglePlay,
                                    icon: Icon(
                                      _autoPlay
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSizes.lg),
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: CustomPaint(
                                        painter: KanjiStrokePainter(
                                          strokes: _data!.strokes,
                                          viewBox: _data!.viewBox,
                                          activeStroke: _practiceIndex,
                                          activeProgress: 1,
                                          completedColor: theme
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 1.0),
                                          guideColor: theme.colorScheme.primary
                                              .withValues(alpha: 0.08),
                                          activeColor:
                                              _showHandwritingInstruction
                                              ? theme.colorScheme.primary
                                                    .withValues(alpha: 0.28)
                                              : Colors.transparent,
                                          strokeWidth: 14,
                                          showGuide: true,
                                          showStartDot:
                                              _showHandwritingInstruction,
                                          startDotColor: const Color(
                                            0xFF1E88E5,
                                          ).withValues(alpha: 0.45),
                                          startDotRadius: 9,
                                        ),
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          _handwritingSize = Size(
                                            constraints.maxWidth,
                                            constraints.maxHeight,
                                          );

                                          final d = _data;
                                          final completed =
                                              d == null ||
                                              _practiceIndex >=
                                                  d.strokes.length;

                                          return GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onPanStart: completed
                                                ? null
                                                : (d) {
                                                    _errorTimer?.cancel();
                                                    setState(() {
                                                      _inkColor = Colors.black;
                                                      _currentStroke = <Offset>[
                                                        d.localPosition,
                                                      ];
                                                    });
                                                  },
                                            onPanUpdate: completed
                                                ? null
                                                : (d) {
                                                    setState(() {
                                                      _currentStroke = <Offset>[
                                                        ..._currentStroke,
                                                        d.localPosition,
                                                      ];
                                                    });
                                                  },
                                            onPanEnd: completed
                                                ? null
                                                : (_) => _onStrokeEnd(),
                                            child: CustomPaint(
                                              painter: _UserInkPainter(
                                                points: _currentStroke,
                                                color: _inkColor.withValues(
                                                  alpha: 0.65,
                                                ),
                                                strokeWidth: 6,
                                              ),
                                              child: const SizedBox.expand(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSizes.md),
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Restart',
                                    onPressed: _resetPractice,
                                    icon: const Icon(Icons.restart_alt),
                                  ),
                                  IconButton(
                                    tooltip: 'Previous stroke',
                                    onPressed: _undoPractice,
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _practiceIndex >= _data!.strokes.length
                                          ? 'Completed'
                                          : 'Stroke ${(_practiceIndex + 1).clamp(1, _data!.strokes.length)} / ${_data!.strokes.length}',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Next stroke',
                                    onPressed: _nextPractice,
                                    icon: const Icon(Icons.chevron_right),
                                  ),
                                  IconButton(
                                    tooltip: _showHandwritingInstruction
                                        ? 'Hide instruction'
                                        : 'Show instruction',
                                    onPressed: () {
                                      setState(() {
                                        _showHandwritingInstruction =
                                            !_showHandwritingInstruction;
                                      });
                                    },
                                    icon: Icon(
                                      _showHandwritingInstruction
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}

class _UserInkPainter extends CustomPainter {
  const _UserInkPainter({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..color = color;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _UserInkPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
