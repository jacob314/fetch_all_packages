library stacked_slider;

import 'package:flutter/material.dart';

class StackedSlider extends StatefulWidget {
  final List<Widget> children;
  final double swipeMultiplier; // Velocity tuner. 0.001..0.009 is recommended
  final int initialIndex;
  final double height;
  final Function(int currentIndex) onChange;

  StackedSlider(
      {Key key,
      @required this.children,
      this.swipeMultiplier = 0.009,
      this.initialIndex = 0,
      this.height,
      this.onChange})
      : super(key: key);

  @override
  _StackedSliderState createState() => _StackedSliderState();
}

class _StackedSliderState extends State<StackedSlider>
    with SingleTickerProviderStateMixin {
  static const double headOffset = 0.0;
  static const double thirdOffset = 0.1;
  static const double secondOffset = 0.2;
  static const double firstOffset = 0.3;
  static const double tailOffset = 0.4;

  static const double headScale = 0.85;
  static const double thirdScale = 0.90;
  static const double secondScale = 0.95;
  static const double firstScale = 1.0;
  static const double tailScale = 1.05;

  int _currentIndex;
  double _offset = 0.0;

  List<Widget> _widgets;
  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _widgets = widget.children;
    _currentIndex = widget.initialIndex;

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150))
          ..addListener(() => setState(() => _offset = _animation.value))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                _offset >= 0 ? _currentIndex++ : _currentIndex--;
                _offset = 0.0;

                if (widget.onChange != null)
                  widget.onChange(_currentIndex % _widgets.length);
              });
            }
          });

    _curveAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getScale(double base) => base + _offset * 0.05;
  double _getOffset(double base) => base + _offset * 0.1;

  @override
  Widget build(BuildContext context) {
    var head = _widgets[(_currentIndex + 3) % _widgets.length];
    var third = _widgets[(_currentIndex + 2) % _widgets.length];
    var second = _widgets[(_currentIndex + 1) % _widgets.length];
    var first = _widgets[_currentIndex % _widgets.length];
    var tail =
        _widgets[(_widgets.length - 1 + _currentIndex) % _widgets.length];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: (details) {
        setState(() {
          _offset = (_offset + details.delta.dy * widget.swipeMultiplier)
              .clamp(-1.0, 1.0);
        });
      },
      onVerticalDragEnd: (details) {
        var tween = _offset >= 0
            ? Tween(begin: _offset, end: 1.0)
            : ReverseTween(Tween(begin: -1.0, end: _offset));
        _animation = tween.animate(_curveAnimation);
        _controller.forward(from: 0.0).orCancel;
      },
      child: _HeightSetter(
        height: widget.height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            _CarouselItem(
              offset: _getOffset(headOffset).clamp(0.0, 0.1),
              scale: _getScale(headScale),
              opacity: (0.0 + _offset).clamp(0.0, 1.0),
              ignoreGestures: true,
              child: head,
            ),
            _CarouselItem(
              offset: _getOffset(thirdOffset),
              scale: _getScale(thirdScale),
              opacity: (1.0 + _offset).clamp(0.0, 1.0),
              ignoreGestures: true,
              child: third,
            ),
            _CarouselItem(
              offset: _getOffset(secondOffset),
              scale: _getScale(secondScale),
              opacity: 1.0,
              ignoreGestures: true,
              child: second,
            ),
            _CarouselItem(
              offset: _getOffset(firstOffset),
              scale: _getScale(firstScale),
              opacity: (1.0 - _offset).clamp(0.0, 1.0),
              child: first,
            ),
            _offset != 0
                ? _CarouselItem(
                    offset: _getOffset(tailOffset),
                    scale: _getScale(tailScale),
                    opacity: (0.0 - _offset).clamp(0.0, 1.0),
                    ignoreGestures: true,
                    child: tail,
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }
}

class _CarouselItem extends StatelessWidget {
  final double offset;
  final double opacity;
  final double scale;
  final bool ignoreGestures;
  final Widget child;

  _CarouselItem(
      {Key key,
      this.offset,
      this.opacity,
      this.scale,
      this.ignoreGestures,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: Offset(0, offset),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: IgnorePointer(ignoring: ignoreGestures ?? false, child: child),
        ),
      ),
    );
  }
}

class _HeightSetter extends StatelessWidget {
  final double height;
  final Widget child;

  _HeightSetter({Key key, this.height, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return height != null
        ? Container(
            height: height,
            child: child,
          )
        : child;
  }
}
