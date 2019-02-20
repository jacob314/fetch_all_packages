import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import './circle.dart';
import './circle_painter.dart';

/**
 * Lock Widget
 */
class LockWidget extends StatefulWidget {
  final ValueChanged<String> completeCallback;
  final CircleAttribute attribute; // The normal attribute of the circle
  final LockState lockState;
  final double height;
  final Size screenSize;

  LockWidget(
      {@required this.completeCallback,
      this.attribute: CircleAttribute.normalAttribute,
      this.height: 300.0,
      this.lockState: LockState.normal})
      : screenSize = MediaQueryData.fromWindow(ui.window).size;

  @override
  State<StatefulWidget> createState() {
    return _LockWidgetState();
  }
}

class _LockWidgetState extends State<LockWidget> {
  Offset touchPoint = Offset.zero;
  List<Circle> circleList = List<Circle>();
  List<Circle> lineList = List<Circle>();

  bool _drawing = false;

  @override
  void initState() {
    super.initState();

    // Calculate and set the positions of the 9 circles
    final double itemWidth = widget.screenSize.width / 3;
    final double itemHeight = widget.height / 3;

    double x, y;
    for (int index = 0; index < 9; index++) {
      x = (index % 3 + 1) * itemWidth - itemWidth / 2;
      y = (index ~/ 3 + 1) * itemHeight - itemHeight / 2;
      circleList.add(Circle(offset: Offset(x, y), index: index.toString()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _clear();
  }

  @override
  void didUpdateWidget(LockWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_drawing == false && widget.lockState != oldWidget.lockState &&
        widget.lockState == LockState.normal) {
      _clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = Size(widget.screenSize.width, widget.height);

    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        _clear();
        _drawing = true;

        setState(() {

          RenderBox box = context.findRenderObject();
          touchPoint = box.globalToLocal(details.globalPosition);

          _testPosition(touchPoint);
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox box = context.findRenderObject();
          touchPoint = box.globalToLocal(details.globalPosition);

          _testPosition(touchPoint);
        });
      },
      onPanEnd: (DragEndDetails details) {
        _drawing = false;

        setState(() {

          // 如果无数据，则不做任何操作
          if (circleList.where((circle) => circle.selected).length == 0) {
            return;
          }

          if (widget.completeCallback != null) {
            final String password = _getPassword();
            widget.completeCallback(password);
          }
        });
      },
      child: CustomPaint(
        size: size,
        painter: CirclePainter(
            circleAttribute: widget.attribute,
            touchPoint: touchPoint,
            circleList: circleList,
            lockState: widget.lockState,
            lineList: lineList),
      ),
    );
  }

  Circle _getOuterCircle(Offset offset) {
    for (int i = 0; i < 9; i++) {
      var cross = offset - circleList[i].offset;
      if (cross.dx.abs() < widget.attribute.hitRadius &&
          cross.dy.abs() < widget.attribute.hitRadius) {
        return circleList[i];
      }
    }

    return null;
  }

  /**
   * Test the current point is in the range of the focus of any circle
   */
  void _testPosition(Offset touchPoint) {
    if (touchPoint.dy < 0) {
      touchPoint = Offset(touchPoint.dx, 0.0);
    }

    if (touchPoint.dy > widget.height) {
      touchPoint = Offset(touchPoint.dx, widget.height);
    }

    Circle circle = _getOuterCircle(touchPoint);
    if (circle != null) {
      if (!circle.selected) {
        lineList.add(circle);
        circle.state = CircleState.selected;
      }
    }
  }

  void _clear() {

    touchPoint = Offset.zero;
    lineList.clear();
    for (int i = 0; i < circleList.length; i++) {
      Circle circle = circleList[i];
      circle.state = CircleState.normal;
    }
  }

  String _getPassword() {
    return lineList
        .map((selectedItem) => selectedItem.index.toString())
        .toList()
        .fold("", (s, str) {
      return s + str;
    });
  }
}
