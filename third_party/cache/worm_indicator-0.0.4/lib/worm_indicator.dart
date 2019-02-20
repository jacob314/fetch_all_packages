library worm_indicator;

import 'package:flutter/material.dart';
import 'dot.dart';

class WormIndicator extends StatefulWidget {
  WormIndicator({
    Key key,
    @required this.length,
    this.spacing = 8,
    this.size = 16,
    this.controller,
    this.color = const Color(0xff808080),
    this.indicatorColor = const Color(0xff35affc),
  }) : super(key: key);

  final int length;
  final size;
  final spacing;
  final PageController controller;
  final Color color;
  final Color indicatorColor;
  @override
  State<StatefulWidget> createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<WormIndicator> {
  Widget buildDot(color, index) {
    if ((widget.length % 2 == 1 && index == (widget.length ~/ 2)) ||
        index == -1) {
      return Container(
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
        ),
        decoration: BoxDecoration(
          color: color ?? Color(0xff35affc),
          shape: BoxShape.circle,
        ),
      );
    }

    if (widget.length % 2 == 1 && index < (widget.length ~/ 2)) {
      return Container(
        margin: EdgeInsets.only(right: widget.spacing.toDouble()),
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
        ),
        decoration: BoxDecoration(
          color: color ?? Color(0xff35affc),
          shape: BoxShape.circle,
        ),
      );
    }

    if (widget.length % 2 == 1 && index > (widget.length ~/ 2)) {
      return Container(
        margin: EdgeInsets.only(left: widget.spacing.toDouble()),
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
        ),
        decoration: BoxDecoration(
          // color: Color(0xff35affc),
          color: color ?? Color(0xff35affc),
          shape: BoxShape.circle,
        ),
      );
    }

    if ((widget.length % 2 == 0 && index < (widget.length ~/ 2)) ||
        index == -1) {
      return Container(
        margin: EdgeInsets.only(right: widget.spacing.toDouble()),
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
        ),
        decoration: BoxDecoration(
          color: color ?? Color(0xff35affc),
          shape: BoxShape.circle,
        ),
      );
    }

    if (widget.length % 2 == 0 && index > (widget.length ~/ 2)) {
      return Container(
        margin: EdgeInsets.only(left: widget.spacing.toDouble()),
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
        ),
        decoration: BoxDecoration(
          color: color ?? Color(0xff35affc),
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      child: Container(
        width: widget.size.toDouble(),
        height: widget.size.toDouble(),
      ),
      decoration: BoxDecoration(
        color: color ?? Color(0xff808080),
        shape: BoxShape.circle,
      ),
    );
  }

  List<Widget> _renderNormalDots() {
    var listDots = List<Widget>();
    for (int i = 0; i < widget.length; i++) {
      listDots.add(buildDot(widget.color ?? (0xff808080), i));
    }
    return listDots;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _renderNormalDots(),
            ),
          ),
          Container(
            child: DotInstance(
              length: widget.length,
              listenable: widget.controller,
              size: widget.size,
              spacing: widget.spacing,
              color: widget.indicatorColor,
            ),
          ),
        ],
      ),
    );
  }
}

