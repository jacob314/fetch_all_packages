import 'package:flutter/material.dart';
import 'package:custom_loader/circle.dart';

class CustomLoader extends StatefulWidget {
  ///Display the progress in circle
  const CustomLoader({
    Key key,
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
  }) : super(key: key);

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
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  //Widget one postions...
  double textPosRight;
  double textPosLeft;
  double textPostTop;
  final double variance = 5.0;
  double percentTextFontSize;

  //End widget one positions...

  @override
  Widget build(BuildContext context) {
    calculateHeaderTextPositions(variance);

    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: const Alignment(0.1, 0.1),
        // overflow: Overflow.visible,
        children: <Widget>[
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: CustomPaint(
              painter: GenericCircle(
                circleColor: widget.circleColor,
                coveredColor: widget.coveredCircleColor,
                coveredPercent: widget.coveredPercent,
                otherVal: widget.initVal,
                circleWidth: widget.circleWidth,
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
                widget.circleHeader,
                textAlign: TextAlign.center,
                style: widget.circleHeaderStyle,
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
                      convertToString(widget.coveredPercent, widget.initVal),
                      style: widget.coveredPercentStyle,
                    ),
                  ),
                  Text(
                    widget.unit,
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

  //Calculate the positions...
  void calculateHeaderTextPositions(variance) {
    textPosRight =
        widget.width - (widget.width - (widget.circleWidth + variance));

    textPosLeft = widget.circleWidth + variance;

    textPostTop = widget.height / 2 -
        ((widget.height / 2.5) - (widget.circleWidth + (variance * 2)));
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
