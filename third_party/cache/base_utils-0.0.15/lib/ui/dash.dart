import 'package:flutter/material.dart';

class DashLine extends Decoration {
  final count;
  final strokeWidth;
  final spacing;
  final color;
  final strokeCap;
  final align;

  DashLine(
      {this.count = 2,
      this.strokeWidth = 1.0,
      this.spacing = 1.0,
      this.color = Colors.black,
      this.strokeCap = StrokeCap.square,
      this.align = Alignment.bottomCenter});

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return DashPainter(this,
        color: color,
        align: align,
        count: count,
        spacing: spacing,
        strokeCap: strokeCap,
        strokeWidth: strokeWidth);
  }
}

class DashPainter extends BoxPainter {
  final DashLine decoration;
  final int count;
  final double strokeWidth;
  final double spacing;
  final Color color;
  final StrokeCap strokeCap;
  final Alignment align;

  DashPainter(this.decoration,
      {this.count,
      this.strokeWidth,
      this.spacing,
      this.color,
      this.strokeCap,
      this.align})
      : assert(decoration != null),
        assert(count > 1),
        assert(strokeWidth > 0),
        assert(spacing > 0),
        assert(color != null),
        assert(strokeCap != null),
        assert(align != null),
        super();

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final w = configuration.size.width;
    final h = configuration.size.height;
    double dw = (w - spacing * (count - 1)) / count;
    double dx = offset.dx;
    double dy;
    if (align.y == -1.0) {
      //top
      dy = offset.dy + strokeWidth / 2;
    } else if (align.y == 0.0) {
      //center
      dy = offset.dy + (h - strokeWidth) / 2;
    } else {
      //bottom
      dy = offset.dy + h - strokeWidth / 2;
    }

    final Paint painter = Paint();
    painter.color = color;
    painter.strokeCap = strokeCap;
    painter.strokeJoin = StrokeJoin.bevel;
    painter.style = PaintingStyle.stroke;
    painter.strokeWidth = strokeWidth;
    for (int i = 0; i < count; i++) {
      canvas.drawLine(Offset(dx, dy), Offset(dx + dw, dy), painter);
      dx += dw + spacing;
    }
  }
}
