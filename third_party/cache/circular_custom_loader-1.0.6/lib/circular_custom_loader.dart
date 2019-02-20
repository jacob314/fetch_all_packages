import 'package:flutter/material.dart';
import 'dart:math';

typedef CircularCustomLoader = Widget Function(
  double coveredPercent,
  String initVal,
  double width,
  double height,
  double circleWidth,
  Color circleColor,
  Color coveredCircleColor,
  String circleHeader,
  String unit,
  TextStyle coveredPercentStyle,
  TextStyle circleHeaderStyle,
);

class CircularLoader extends StatelessWidget {
  ///Display the progress in circle
  const CircularLoader({
    @required this.coveredPercent,
    this.initVal,
    @required this.width,
    @required this.height,
    @required this.circleWidth,
    @required this.circleColor,
    @required this.coveredCircleColor,
    @required this.circleHeader,
    @required this.unit,
    this.coveredPercentStyle,
    this.circleHeaderStyle,
  })  : assert(coveredPercent != null),
        assert(width != null),
        assert(height != null),
        assert(circleWidth != null),
        assert(circleColor != null),
        assert(coveredCircleColor != null),
        assert(circleHeader != null),
        assert(unit != null);

  ///Percentage to display in the circle and accordingly as the circle arc.
  ///0 to 100 only. e.g 90.0
  final double coveredPercent;

  ///If specified then, initial value supersedes the coveredPercent.
  ///For instance, initVal: '?'
  final String initVal;

  ///Give the width to the widget.
  ///Prefer height=width for optimum view.
  final double width;

  ///Give the height to the widget.
  ///Prefer height=width for optimum view.
  final double height;

  ///Give the circle width.
  final double circleWidth;

  ///Specify the complete arc circle color.
  final Color circleColor;

  ///Specify the covered arc circle color.
  final Color coveredCircleColor;

  ///Specifiy the circle Header. e.g Loading
  final String circleHeader;

  ///Specifiy the unit. e.g %
  final String unit;

  ///Style for displaying coveredPercent.
  final TextStyle coveredPercentStyle;

  ///Style for displaying circle Header.
  final TextStyle circleHeaderStyle;
  @override
  Widget build(BuildContext context) {
    double textPosRight;
    double textPosLeft;
    double textPostTop;
    final double variance = 5.0;

    textPosRight = width - (width - (circleWidth + variance));
    textPosLeft = circleWidth + variance;
    textPostTop =
        height / 2 - ((height / 2.5) - (circleWidth + (variance * 2)));

    return Container(
      width: width,
      height: height,
      child: Stack(
        alignment: const Alignment(0.1, 0.1),
        // overflow: Overflow.visible,
        children: <Widget>[
          SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              painter: GenericCircle(
                circleColor: circleColor,
                coveredColor: coveredCircleColor,
                coveredPercent: coveredPercent,
                otherVal: initVal,
                circleWidth: circleWidth,
                variance: 5.0,
              ),
            ),
          ),
          Positioned(
            right: textPosRight,
            left: textPosLeft,
            top: textPostTop,
            child: Container(
              child: Text(
                circleHeader,
                textAlign: TextAlign.center,
                style: circleHeaderStyle,
              ),
            ),
          ),
          Positioned(
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Text(
                      convertToString(coveredPercent, initVal),
                      style: coveredPercentStyle,
                    ),
                  ),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: textPostTop / 2,
                      fontWeight: FontWeight.w300,
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

  //Check for string value or if init Value
  String convertToString(double val, String initVal) {
    if (initVal != null) {
      return initVal;
    } else {
      return val.toInt().toString();
    }
  }
}

//Makes the loader circle...
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
