import 'package:base_utils/utils/logging_utils.dart';
import 'package:base_utils/utils/number_utils.dart';
import 'package:flutter/material.dart';

class ScalelessText extends Text {
  static double defaultScaleFactor = 1.0;

  String data;

  TextStyle style;

  TextDirection textDirection;

  TextAlign textAlign;

  Locale locale;

  bool softWrap;

  TextOverflow overflow;

  double textScaleFactor = defaultScaleFactor;

  int maxLines;

  String semanticsLabel;

  ScalelessText(
    this.data, {
    Key key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  }) : super(data,
            key: key,
            style: style,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaleFactor: textScaleFactor,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel);

  static initScaleFactor(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    double designWidth = 375.0;
    defaultScaleFactor =
        roundToPrecision2(defaultScaleFactor * (width / designWidth));
//    log("Width: $width, Design: $designWidth");
//    log("Ratio: ${width / designWidth}");
//    log("New scale factor: $defaultScaleFactor");
  }
}
