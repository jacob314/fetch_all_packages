import 'package:flutter/material.dart';
import 'dart:math';

class GenericCircle extends CustomPainter {
  GenericCircle({
    this.circleColor,
    this.coveredColor,
    this.coveredPercent,
    this.circleWidth,
    this.otherVal,
    this.variance,
  });

  final Color circleColor;
  final Color coveredColor;
  final double coveredPercent;
  final double circleWidth;
  final String otherVal;
  final double variance;

  @override
  void paint(Canvas canvas, Size size) {
    // print('Size width ' + size.width.toString());
    // print('Size height ' + size.height.toString());

    final circle = Paint()
      ..color = circleColor
      // ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth;

    final coveredPath = Paint()
      ..color = coveredColor
      // ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth;

    final center = new Offset(size.width / 2, size.height / 2);

    //This is done to ensure that the cicle is in the height and width..
    //CircleWidth and some extra variance subtracted ensures that...
    final radius = min((size.width - circleWidth - variance) / 2,
        (size.height - circleWidth - variance) / 2);
    canvas.drawCircle(center, radius, circle); //Circle drawn.....

    final arcAngle =
        otherVal != null ? 2 * pi * 0 : 2 * pi * (coveredPercent / 100);

    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), pi / 2,
        arcAngle, false, coveredPath);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
