import 'package:flutter/material.dart';

class FuriganaText extends StatelessWidget {
  const FuriganaText(
    this.text, {
    super.key,
    this.baseStyle,
    this.furiganaStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? baseStyle;
  final TextStyle? furiganaStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final defaultBaseStyle = DefaultTextStyle.of(context).style;
    final base = baseStyle ?? defaultBaseStyle;
    final baseFontSize = (base.fontSize ?? 14).toDouble();
    final ruby = furiganaStyle ?? base.copyWith(fontSize: baseFontSize * 0.6);

    final tokens = _parse(text);
    final hasRuby = tokens.any(
      (t) => t.reading != null && t.reading!.isNotEmpty,
    );
    if (!hasRuby) {
      return Text(
        text,
        style: base,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // Multi-line safe ruby layout.
    // Each token is rendered as a single unit (ruby stacked above base) inside one Wrap.
    // This prevents ruby/base desync when the text wraps.
    final tokenWidgets = <Widget>[];

    for (final token in tokens) {
      final baseText = token.base;
      final rubyText = token.reading;

      final baseWidth = _measureTextWidth(baseText, base);
      final rubyWidth = rubyText == null
          ? 0.0
          : _measureTextWidth(rubyText, ruby);
      final w = (baseWidth > rubyWidth ? baseWidth : rubyWidth) + 1.0;

      tokenWidgets.add(
        SizedBox(
          width: w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: rubyText == null
                    ? SizedBox(
                        height: (ruby.fontSize ?? baseFontSize * 0.6) * 1.2,
                      )
                    : Text(
                        rubyText,
                        style: ruby,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        softWrap: false,
                      ),
              ),
              Center(
                child: Text(
                  baseText,
                  style: base,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      alignment: _wrapAlignment(textAlign),
      spacing: 0,
      runSpacing: 0,
      children: tokenWidgets,
    );
  }
}

double _measureTextWidth(String text, TextStyle style) {
  if (text.isEmpty) return 0;
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout();
  return painter.size.width;
}

WrapAlignment _wrapAlignment(TextAlign? textAlign) {
  switch (textAlign) {
    case TextAlign.center:
      return WrapAlignment.center;
    case TextAlign.end:
    case TextAlign.right:
      return WrapAlignment.end;
    default:
      return WrapAlignment.start;
  }
}

class _FuriganaToken {
  const _FuriganaToken({required this.base, this.reading});

  final String base;
  final String? reading;
}

List<_FuriganaToken> _parse(String input) {
  // Format: "{漢字;かんじ}" mixed with plain text.
  // We keep behavior similar to Android FuriganaView markup.
  final tokens = <_FuriganaToken>[];

  var text = input;
  while (text.isNotEmpty) {
    final open = text.indexOf('{');
    if (open < 0) {
      tokens.add(_FuriganaToken(base: text));
      break;
    }

    if (open > 0) {
      tokens.add(_FuriganaToken(base: text.substring(0, open)));
      text = text.substring(open);
    }

    final close = text.indexOf('}');
    if (close < 0) {
      // Unbalanced, treat rest as plain.
      tokens.add(_FuriganaToken(base: text));
      break;
    }

    final inner = text.substring(1, close);
    final parts = inner.split(';');
    final base = parts.isNotEmpty ? parts[0] : '';
    final reading = parts.length >= 2 ? parts[1] : null;

    if (base.isNotEmpty) {
      tokens.add(
        _FuriganaToken(
          base: base,
          reading: (reading?.isEmpty ?? true) ? null : reading,
        ),
      );
    }

    text = text.substring(close + 1);
  }

  return tokens;
}
