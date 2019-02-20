/*
*    Copyright 2018 Andrew Gu
*
*  Licensed under the Apache License, Version 2.0 (the "License");
*  you may not use this file except in compliance with the License.
*  You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing, software
*  distributed under the License is distributed on an "AS IS" BASIS,
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*  See the License for the specific language governing permissions and
*  limitations under the License.
*/

import 'package:flutter/widgets.dart';

typedef bool SwipableCallbackFunction(SwipableInfo swipe, DragEndDetails event);
typedef double SwipableTweenDoubleFunction(SwipableInfo swipe);
typedef Offset SwipableTweenOffsetFunction(SwipableInfo swipe);

/// Widget in [Swipable] library, detects gestures and calls event handlers.
class Swipable extends StatefulWidget {
  /// The primary transformable [Widget] in the foreground.
  final Widget child;

  /// Event handler callback [Function]s, given [SwipableInfo] state and
  /// [DragEndDetails].
  final SwipableCallbackFunction onSwipe, onFling;

  /// Event handler callback [Function], given [SwipableInfo]state and
  /// drag event details.
  final Function onAction;

  /// Animation functions, returns a [double] based off [SwipableInfo] state.
  final SwipableTweenDoubleFunction tweenOpacity, tweenRotation, tweenScale;

  /// Animation functions, returns an [Offset] based off [SwipableInfo] state.
  final SwipableTweenOffsetFunction tweenTranslation;

  /// Event detection parameters for [SwipableCallbackFunction]s.
  final double maxFlingVelocity, minFlingDistance, minFlingVelocity;

  Swipable({
    Key key,
    SwipableCallbackFunction onSwipe,
    SwipableCallbackFunction onFling,
    Function onAction,
    SwipableTweenDoubleFunction tweenOpacity,
    SwipableTweenDoubleFunction tweenRotation,
    SwipableTweenDoubleFunction tweenScale,
    SwipableTweenOffsetFunction tweenTranslation,
    double maxFlingVelocity = double.infinity,
    double minFlingDistance = 0.0,
    double minFlingVelocity = 0.0,
    Widget child,
  })  : child = child ?? new Placeholder(),
        onSwipe = onSwipe ?? ((swipe, event) => true),
        onFling = onFling ?? ((swipe, event) => true),
        onAction = onAction ?? ((swipe, event) => true),
        tweenOpacity = tweenOpacity ?? ((swipe) => 1.0),
        tweenRotation = tweenRotation ?? ((swipe) => 0.0),
        tweenScale = tweenScale ?? ((swipe) => 1.0),
        tweenTranslation = tweenTranslation ?? ((swipe) => Offset(0.0, 0.0)),
        maxFlingVelocity = maxFlingVelocity.abs(),
        minFlingDistance = minFlingDistance.abs(),
        minFlingVelocity = minFlingVelocity.abs(),
        super(key: key);

  @override
  _SwipableState createState() => new _SwipableState();
}

/// State of the [Swipable] widget that contains the current [SwipableInfo].
class _SwipableState extends State<Swipable> {
  SwipableInfo swipe = new SwipableInfo();

  /// Initiates the [SwipeInfo] when the pointer is down and begins dragging
  /// in the horizontal direction.
  void swipeStart(DragStartDetails event) {
    widget.onAction(swipe, event);
    setState(() {
      swipe.startPosition = event.globalPosition.dx;
    });
  }

  /// Updates the [SwipeInfo] when the pointer is down and moves.
  void swipeUpdate(DragUpdateDetails event) {
    widget.onAction(swipe, event);
    setState(() {
      swipe.position = event.globalPosition.dx;
    });
  }

  /// Resets [SwipeInfo] state on pointer up.
  void swipeEnd(DragEndDetails event) {
    // Event Handlers
    widget.onAction(swipe, event);
    double vel = event.primaryVelocity.abs();
    if (swipe.delta.abs() >= widget.minFlingDistance &&
        vel >= widget.minFlingVelocity &&
        vel <= widget.maxFlingVelocity) {
      if (widget.onFling(swipe, event)) widget.onSwipe(swipe, event);
    } else {
      widget.onSwipe(swipe, event);
    }

    // Resets [SwipeInfo] state
    setState(() {
      swipe.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    swipe.contextWidth = MediaQuery.of(context).size.width;

    return new GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: new Transform.scale(
        scale: widget.tweenScale(swipe),
        child: new Transform.translate(
          offset: widget.tweenTranslation(swipe),
          child: new Transform.rotate(
            angle: widget.tweenRotation(swipe),
            child: new Opacity(
              opacity: widget.tweenOpacity(swipe),
              child: widget.child,
            ),
          ),
        ),
      ),
      onHorizontalDragStart: swipeStart,
      onHorizontalDragUpdate: swipeUpdate,
      onHorizontalDragEnd: swipeEnd,
    );
  }
}

class SwipableInfo {
  /// The current location of the pointer along the x-axis.
  double _position;

  /// The location of the pointer along the x-axis when the gesture was
  /// initiated.
  double _startPosition;

  /// The previous location of the pointer along the x-axis.
  double _lastPosition;

  /// The width of the provided [BuildContext], used to calculate fractional
  /// values.
  double contextWidth;

  SwipableInfo() {
    _startPosition = _lastPosition = _position = 0.0;
    contextWidth = 0.0;
  }

  /// The current location of the pointer along the x-axis.
  double get position => _position;

  /// The location of the pointer along the x-axis when the gesture was
  /// initiated.
  double get startPosition => _startPosition;

  /// The previous location of the pointer along the x-axis.
  double get lastPosition => _lastPosition;

  /// Sets values from a reset [SwipeInfo] when the pointer is down and begins
  /// swiping.
  set startPosition(double value) {
    _startPosition = _lastPosition = _position = value;
  }

  /// Sets values from an active [SwipeInfo] owhen the pointer is down and its
  /// location changes.
  set position(double value) {
    _lastPosition = _position;
    _position = value;
  }

  /// The fraction of `contextWidth` represented by `position`.
  double get fractionalPosition => _position / contextWidth;

  /// The difference between `pointer` and `startPosition`.
  double get delta => _position - startPosition;

  /// The fraction of `contextWidth` represented by `delta`.
  double get fractionalDelta => delta / contextWidth;

  /// The difference between `pointer` and `lastPosition`.
  double get velocity => _position - _lastPosition;

  /// The fraction of `contextWidth` represented by `velocity`.
  double get fractionalVelocity => velocity / contextWidth;

  /// Resets the state of the [SwipableInfo] so all positions are `0.0`. Should
  /// not be used except internally.
  void reset() {
    _startPosition = _lastPosition = _position = 0.0;
  }

  String toString() {
    return 'SwipableInfo(position: $position, startPosition: $startPosition, ' +
        'lastPosition: $lastPosition, contextWidth: $contextWidth, ' +
        'fractionalPosition: $fractionalPosition, delta: $delta, ' +
        'fractionalDelta: $fractionalDelta)';
  }
}
