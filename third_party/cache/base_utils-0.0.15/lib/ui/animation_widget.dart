import 'package:base_utils/utils/logging_utils.dart';
import 'package:flutter/material.dart';

class FadeInWidget extends StatefulWidget {
  final Widget child;

  final Duration duration;

  FadeInWidget({this.child, this.duration = const Duration(milliseconds: 400)});

  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget> {
  double _opacity;

  @override
  void initState() {
    super.initState();
    _opacity = 0.0;
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.duration,
      curve: Curves.easeInOut,
      child: widget.child,
    );
  }
}

class RotateWidget extends StatefulWidget {
  final Widget child;
  final double angle;

  RotateWidget({this.child, this.angle});

  @override
  _RotateWidgetState createState() => _RotateWidgetState();
}

class _RotateWidgetState extends State<RotateWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _currentAngle;
  double _previousAngle;
  Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350))
          ..forward(from: 0.00);
    _currentAngle = widget.angle;
    super.initState();
  }

  @override
  void didUpdateWidget(RotateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.angle != widget.angle) {
      _previousAngle = _currentAngle;
      _currentAngle = widget.angle;
      _animation = Tween<double>(begin: _previousAngle, end: _currentAngle)
          .animate(_controller);
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_previousAngle == null) {
      return Transform.rotate(
        angle: _currentAngle,
        child: widget.child,
      );
    } else {
      return RotationTransition(
        turns: _animation,
        child: widget.child,
      );
    }
  }
}

class SlideWidget extends StatefulWidget {
  final Widget child;

  final Duration duration;

  final Offset offset;

  SlideWidget(
      {this.child,
      this.duration = const Duration(milliseconds: 400),
      this.offset = const Offset(0.0, -0.05)});
  @override
  _SlideWidgetState createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward(from: 0.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: widget.offset, end: Offset.zero)
          .animate(_controller),
      child: widget.child,
    );
  }
}
