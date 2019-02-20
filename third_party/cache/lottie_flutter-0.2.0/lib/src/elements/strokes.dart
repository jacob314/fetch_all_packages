import 'dart:ui' show StrokeCap, StrokeJoin;
import 'package:lottie_flutter/src/animatables.dart';
import 'package:lottie_flutter/src/drawing/drawing.dart';
import 'package:lottie_flutter/src/drawing/drawing_layers.dart';
import 'package:lottie_flutter/src/drawing/elements/strokes.dart';
import 'package:lottie_flutter/src/elements/shapes.dart';

import 'package:lottie_flutter/src/parsers/element_parsers.dart';
import 'package:lottie_flutter/src/values.dart';

abstract class Stroke extends Shape {
  final StrokeCap _capType;
  final StrokeJoin _joinType;
  final LineDashGroup _lineDashGroup;
  final AnimatableDoubleValue _width;
  final AnimatableIntegerValue _opacity;

  Stroke.fromMap(dynamic map, double scale, double durationFrames)
      : _opacity = parseOpacity(map, durationFrames),
        _width = parseWidth(map, scale, durationFrames),
        _capType = parseCapType(map),
        _joinType = parseJoinType(map),
        _lineDashGroup = parseLineDash(map, scale, durationFrames),
        super.fromMap(map);
}

class ShapeStroke extends Stroke {
  final AnimatableColorValue _color;

  ShapeStroke.fromMap(dynamic map, double scale, double durationFrames)
      : _color = parseColor(map, durationFrames),
        super.fromMap(map, scale, durationFrames);

  AnimatableColorValue get color => _color;

  @override
  AnimationDrawable toDrawable(Repaint repaint, BaseLayer layer) =>
      new ShapeStrokeDrawable(
          name,
          _capType,
          _joinType,
          _lineDashGroup.lineDashPattern,
          repaint,
          _opacity.createAnimation(),
          _width.createAnimation(),
          _lineDashGroup?.offset?.createAnimation(),
          _color.createAnimation(),
          layer);
}

class GradientStroke extends Stroke {
  final AnimatableGradientColorValue _gradientColor;
  final AnimatablePointValue _start;
  final AnimatablePointValue _end;
  final GradientType _type;

  GradientStroke.fromMap(dynamic map, double scale, double durationFrames)
      : _gradientColor = parseGradient(map, durationFrames),
        _type = parseGradientType(map),
        _start = parseStartPoint(map, scale, durationFrames),
        _end = parseEndPoint(map, scale, durationFrames),
        super.fromMap(map, scale, durationFrames);

  @override
  AnimationDrawable toDrawable(Repaint repaint, BaseLayer layer) =>
      new GradientStrokeDrawable(
          name,
          _capType,
          _joinType,
          _lineDashGroup.lineDashPattern,
          repaint,
          _opacity.createAnimation(),
          _width.createAnimation(),
          _lineDashGroup.offset.createAnimation(),
          _type,
          _gradientColor.createAnimation(),
          _start.createAnimation(),
          _end.createAnimation(),
          layer);
}
