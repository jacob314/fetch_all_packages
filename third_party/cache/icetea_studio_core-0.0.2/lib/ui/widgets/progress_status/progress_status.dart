import 'dart:math';

import 'package:flutter/material.dart';

class _ArcPainter extends CustomPainter {
  int percent;
  double strokeWidth;
  double textScaleFactor;
  Color foregroundColor;
  Color valueColor;
  Color textColor;

  _ArcPainter(this.percent, this.strokeWidth, this.textColor, this.foregroundColor, this.valueColor, this.textScaleFactor);

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    TextSpan span = new TextSpan(style: new TextStyle(color: textColor), text: '${percent}%');
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr, maxLines: 1, textScaleFactor: textScaleFactor);
    tp.layout();
    tp.paint(canvas, new Offset(size.width / 2 - tp.width / 2, size.width / 2 - tp.height / 2));

    Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    canvas.drawArc(
        rect,
        0.0,
        pi * 2,
        false,
        Paint()
          ..color = foregroundColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke);

    canvas.drawArc(
        rect,
        -pi / 2,
        percent * pi * 2 / 100,
        false,
        Paint()
          ..color = valueColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke);
  }
}

class ProgressStatusView extends StatefulWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final Color textColor;
  final int percent;
  final double radius;
  final double strokeWidth;
  final double textScaleFactor;

  ProgressStatusView({@required this.percent, @required this.radius, this.foregroundColor, this.strokeWidth, this.textColor, this.textScaleFactor, this.backgroundColor})
      : assert(percent != null),
        assert(radius != null);

  @override
  ProgressStatusState createState() {
    return new ProgressStatusState();
  }
}

class ProgressStatusState extends State<ProgressStatusView> {
  Color _renderColor;

  @override
  Widget build(BuildContext context) {
    if (widget.percent <= 0) {
      _renderColor = Theme.of(context).disabledColor;
    } else if (widget.percent < 50) {
      _renderColor = Theme.of(context).errorColor;
    } else if (widget.percent >= 50 && widget.percent < 90) {
      _renderColor = Theme.of(context).accentColor;
    } else {
      _renderColor = Theme.of(context).primaryColor;
    }

    return new Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: widget.backgroundColor ?? Colors.transparent,
      ),
      child: new SizedBox(
        width: widget.radius ?? 50.0,
        height: widget.radius ?? 50.0,
        child: new CustomPaint(
          painter: new _ArcPainter(
              widget.percent ?? 0,
              widget.strokeWidth ?? 20.0,
              _renderColor ?? Theme.of(context).disabledColor,
              widget.foregroundColor ?? Theme.of(context).disabledColor,
              _renderColor,
              widget.textScaleFactor ?? 1.0),
        ),
      ),
    );
  }
}
