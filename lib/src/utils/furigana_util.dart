String furiganaOriginalText(String text) {
  var originalText = '';
  while (text.isNotEmpty) {
    var idx = text.indexOf('{');
    if (idx >= 0) {
      if (idx > 0) {
        originalText += text.substring(0, idx);
        text = text.substring(idx);
      }

      idx = text.indexOf('}');
      if (idx < 1) {
        text = '';
        break;
      } else if (idx == 1) {
        text = text.substring(2);
        continue;
      }

      final split = text.substring(1, idx).split(';');
      originalText += split.isNotEmpty ? split[0] : '';
      text = text.substring(idx + 1);
    } else {
      originalText += text;
      text = '';
    }
  }

  return originalText;
}
