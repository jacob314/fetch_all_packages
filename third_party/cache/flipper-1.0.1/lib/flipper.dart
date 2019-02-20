library flipper;

import 'dart:math';

import 'package:flutter/material.dart';

enum Turn { obverse, reverse }
enum Direction { right, left }

typedef OnFlipCallback = Function(Turn turn);

class Flipper extends StatefulWidget {
  final Turn initState;
  final OnFlipCallback onFlipCallback;
  final Widget obverseChild;
  final Widget reverseChild;
  final double flipThreshold;
  final Duration duration;
  final bool ignoreSwipe;

  Flipper({
    Key key,
    @required this.obverseChild,
    @required this.reverseChild,
    this.onFlipCallback,
    this.initState = Turn.obverse,
    this.flipThreshold = 0,
    this.duration = const Duration(milliseconds: 300),
    this.ignoreSwipe = false,
  }) : super(key: key);

  @override
  FlipperState createState() => FlipperState();
}

class FlipperState extends State<Flipper> with TickerProviderStateMixin {
  AnimationController _flipController;
  Animation<double> _flip;

  double _offset = 0.0;

  Turn _state;
  Turn get state => _state;

  @override
  void initState() {
    super.initState();

    _state = widget.initState;

    _flipController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..addListener(() => setState(() => _offset = _flip?.value ?? 0.0))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _offset = 0.0;
        }
      });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void flipCard(Direction direction) => _flipCard(direction, _offset);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0003)
        ..rotateY(_offset),
      child: GestureDetector(
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: Stack(
          children: <Widget>[
            AnimatedOpacity(
              duration: widget.duration,
              curve: Threshold(0.5),
              opacity: state == Turn.obverse ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: state != Turn.obverse,
                child: widget.obverseChild,
              ),
            ),
            AnimatedOpacity(
              duration: widget.duration,
              curve: Threshold(0.5),
              opacity: state == Turn.reverse ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: state != Turn.reverse,
                child: widget.reverseChild,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (widget.ignoreSwipe) return;
    if (_flipController.status == AnimationStatus.forward) return;

    setState(() => _offset += details.delta.dx * -0.003);
  }

  void _onDragEnd(DragEndDetails details) {
    if (widget.ignoreSwipe) return;
    if (_flipController.status == AnimationStatus.forward) return;

    bool thresholdPass = _offset.abs() > widget.flipThreshold;
    if (thresholdPass) {
      _flipCard(_offset < 0 ? Direction.right : Direction.left, _offset);
      if (widget.onFlipCallback != null) widget.onFlipCallback(_state);
    } else {
      _restoreCard(_offset);
    }
  }

  void _restoreCard(double offset) {
    _flip = Tween(begin: offset, end: 0.0).animate(_flipController);
    _flipController.forward(from: 0.0).orCancel;
  }

  void _flipCard(Direction direction, double beginOffset) {
    var coef = direction == Direction.left ? 1.0 : -1.0;
    var tween = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween(
          begin: beginOffset,
          end: pi * coef / 2,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween(
          begin: 3 * pi * coef / 2,
          end: 2 * pi * coef,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
    ]);

    _state = _state == Turn.obverse ? Turn.reverse : Turn.obverse;
    _flip = tween.animate(_flipController);
    _flipController.forward(from: 0.0).orCancel;
  }
}
