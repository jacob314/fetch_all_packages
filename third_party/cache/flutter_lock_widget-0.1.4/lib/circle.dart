import 'package:flutter/material.dart';

/**
 * The state of one circle
 */
enum CircleState { normal, selected }

/**
 * The State of LockWidget
 */
enum LockState { normal, error }

/**
 * Callback for finish the gesture action
 */
typedef LockCompleteCallback = bool Function(String);

/**
 * Circle model
 */
class Circle {
  final Offset offset; // position of the circle
  final String index; // index of the circle

  CircleState _state;

  Circle({this.offset, this.index}) : _state = CircleState.normal;

  // getter and setter for the _state;
  CircleState get state => _state;
  set state(CircleState state) => _state = state;

  bool get selected => _state == CircleState.selected;
}

/**
 * The basic attribute for the elements of gesture password
 */
class CircleAttribute {
  final Color normalColor;
  final Color errorColor;

  final double lineStrokeWidth;
  final double circleStrokeWidth;

  final double innerCircleRadius;
  final double outerCircleRadius;

  final double hitRadius; // The radius of area for circle selected

  static const CircleAttribute normalAttribute = CircleAttribute(
    normalColor: Colors.blue,
    errorColor: Colors.red,
  );

  const CircleAttribute(
      {this.normalColor,
      this.errorColor,
      this.lineStrokeWidth: 1.0,
      this.circleStrokeWidth: 1.0,
      this.innerCircleRadius: 10.0,
      this.outerCircleRadius: 30.0,
      this.hitRadius: 25.0});
}
