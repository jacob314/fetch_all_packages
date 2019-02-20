/*
*
* Copyright 2018 Diogo Nunes
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
*/

library rotation_detector;

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RotationDetector extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;

  RotationDetector({this.child, this.width, this.height});

  @override
  _RotationDetector createState() => new _RotationDetector();
}

class _RotationDetector extends State<RotationDetector>
    with SingleTickerProviderStateMixin {
  double angle = 0.0;

  Offset lastPan = Offset.zero;
  AnimationController flingAnimation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onPanUpdate: onPanUpdate,
      child: Transform.rotate(
        angle: angle,
        child: widget.child,
      ),
    );
  }

  void onPanUpdate(DragUpdateDetails pan) {
    RenderBox box = context.findRenderObject();
    var localOffset = box.globalToLocal(pan.globalPosition);
    var converted = _normalizeAngle(localOffset);
    var px = converted.dx;
    var py = converted.dy;
    if (pan.delta.dx == 0.0 && pan.delta.dy == 0.0) {
      return;
    }
    var angle1 = _getAngle(px, py);
    var angle2 = _getAngle(px + pan.delta.dx, py + pan.delta.dy);

    var deltaAngle = (angle1 - angle2);

    var q = _getQuadrant(localOffset);
    double nAngle = 0.0;
    switch (q) {
      case _CircleQuadrant.III:
      case _CircleQuadrant.II:
        nAngle = angle + deltaAngle;
        break;
      case _CircleQuadrant.I:
      case _CircleQuadrant.IV:
        nAngle = angle - deltaAngle;
        break;
      default:
        break;
    }
    setState(() => angle = nAngle);
  }

  double _getAngle(double px, double py) {
    var a = sqrt(pow(px, 2) + pow(py, 2));
    var b = px;
    if (a == 0) return 0.0;
    return asin(b / a);
  }

  Offset _normalizeAngle(Offset offset) {
    var width = widget.width;
    var height = widget.height;

    var px = offset.dx;
    var py = offset.dy;

    var quadrante = _getQuadrant(offset);
    switch (quadrante) {
      case _CircleQuadrant.I:
        return offset;
        break;
      case _CircleQuadrant.II:
        return Offset(px, py - height);
        break;
      case _CircleQuadrant.III:
        return Offset(px - width, py - height);
        break;
      case _CircleQuadrant.IV:
        return Offset(px - width, py);
        break;
      default:
        return Offset.zero;
    }
  }

  _CircleQuadrant _getQuadrant(Offset offset) {
    var ox = widget.width / 2;
    var oy = widget.height / 2;
    var px = offset.dx;
    var py = offset.dy;
    if (px < ox && py < oy) {
      return _CircleQuadrant.I;
    } else if (px < ox && py >= oy) {
      return _CircleQuadrant.II;
    } else if (px >= ox && py >= oy) {
      return _CircleQuadrant.III;
    } else if (px > ox && py < oy) {
      return _CircleQuadrant.IV;
    } else {
      assert(false);
      return null;
    }
  }
}

enum _CircleQuadrant { I, II, III, IV }
