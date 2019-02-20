import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/widgets.dart' as widgets;

import 'component.dart';
import 'resizable.dart';
import '../text_config.dart';
import '../palette.dart';
import '../position.dart';

class TextBoxConfig {
  final double maxWidth;
  final double margin;
  final double timePerChar;
  final double dismissDelay;

  const TextBoxConfig({
    this.maxWidth: 200.0,
    this.margin: 8.0,
    this.timePerChar: 0.0,
    this.dismissDelay: 0.0,
  });
}

class TextBoxComponent extends PositionComponent with Resizable {
  Position p = Position.empty();

  String _text;
  TextConfig _config;
  TextBoxConfig _boxConfig;

  List<String> _lines;
  double _maxLineWidth = 0.0;
  double _lineHeight;

  double _lifeTime = 0.0;
  Image _cache;

  String get text => _text;

  TextConfig get config => _config;

  TextBoxConfig get boxConfig => _boxConfig;

  TextBoxComponent(String text,
      {TextConfig config = const TextConfig(),
      TextBoxConfig boxConfig = const TextBoxConfig()}) {
    _boxConfig = boxConfig;
    _config = config;
    _text = text;
    _lines = [''];
    text.split(' ').forEach((word) {
      String possibleLine = _lines.last + ' ' + word;
      widgets.TextPainter p = config.toTextPainter(possibleLine);
      if (_lineHeight == null) {
        _lineHeight = p.height;
      }
      if (p.width <= _boxConfig.maxWidth - 2 * _boxConfig.margin) {
        _lines.last = possibleLine;
        _updateMaxWidth(p.width);
      } else {
        _lines.add(word);
        _updateMaxWidth(config.toTextPainter(word).width);
      }
    });

    _cache = _redrawCache();
  }

  void _updateMaxWidth(double w) {
    if (w > _maxLineWidth) {
      _maxLineWidth = w;
    }
  }

  double get totalCharTime => _text.length * _boxConfig.timePerChar;

  bool get finished => _lifeTime > totalCharTime + _boxConfig.dismissDelay;

  int get currentChar => _boxConfig.timePerChar == 0.0
      ? _text.length - 1
      : math.min(_lifeTime ~/ _boxConfig.timePerChar, _text.length - 1);

  int get currentLine {
    int totalCharCount = 0;
    int _currentChar = currentChar;
    for (int i = 0; i < _lines.length; i++) {
      totalCharCount += _lines[i].length;
      if (totalCharCount > _currentChar) {
        return i;
      }
    }
    return _lines.length - 1;
  }

  double _withMargins(double size) => size + 2 * _boxConfig.margin;

  @override
  double get width => currentWidth;

  @override
  double get height => currentHeight;

  double get totalWidth => _withMargins(_maxLineWidth);

  double get totalHeight => _withMargins(_lineHeight * _lines.length);

  double getLineWidth(String line, int charCount) {
    return _withMargins(_config
        .toTextPainter(line.substring(0, math.min(charCount, line.length)))
        .width);
  }

  double get currentWidth {
    int i = 0;
    int totalCharCount = 0;
    int _currentChar = currentChar;
    int _currentLine = currentLine;
    return _lines.sublist(0, _currentLine + 1).map((line) {
      int charCount =
          (i < _currentLine) ? line.length : (_currentChar - totalCharCount);
      totalCharCount += line.length;
      i++;
      return getLineWidth(line, charCount);
    }).reduce(math.max);
  }

  double get currentHeight => _withMargins((currentLine + 1) * _lineHeight);

  void render(Canvas c) {
    prepareCanvas(c);
    c.drawImage(_cache, Offset.zero, BasicPalette.white.paint);
  }

  Image _redrawCache() {
    PictureRecorder recorder = new PictureRecorder();
    Canvas c = new Canvas(recorder,
        new Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()));
    _fullRender(c);
    return recorder.endRecording().toImage(width.toInt(), height.toInt());
  }

  void drawBackground(Canvas c) {}

  void _fullRender(Canvas c) {
    drawBackground(c);

    int _currentLine = currentLine;
    int charCount = 0;
    double dy = _boxConfig.margin;
    for (int line = 0; line < _currentLine; line++) {
      charCount += _lines[line].length;
      _config
          .toTextPainter(_lines[line])
          .paint(c, new Offset(_boxConfig.margin, dy));
      dy += _lineHeight;
    }
    int max = math.min(currentChar - charCount, _lines[_currentLine].length);
    _config
        .toTextPainter(_lines[_currentLine].substring(0, max))
        .paint(c, new Offset(_boxConfig.margin, dy));
  }

  void update(double dt) {
    int prevCurrentChar = currentChar;
    _lifeTime += dt;
    if (prevCurrentChar != currentChar) {
      _cache = _redrawCache();
    }
  }
}
