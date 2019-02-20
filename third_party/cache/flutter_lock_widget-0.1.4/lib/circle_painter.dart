import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './circle.dart';

/**
 * 绘制手势密码
 * 
 * 该类只负责绘制手势密码，并得到最终手势密码回传，不做任何逻辑处理
 */
class CirclePainter extends CustomPainter {
  final Offset touchPoint;
  final List<Circle> circleList;
  final List<Circle> lineList;
  final CircleAttribute circleAttribute;
  final LockState lockState;

  final Color backgroundColor;

  Paint _normalInnerCirclePaint;
  Paint _normalOuterCirclePaint;
  Paint _normalLinePaint;

  Paint _errorInnerCirclePaint;
  Paint _errorOuterCirclePaint;
  Paint _errorLinePaint;

  CirclePainter(
      {this.circleAttribute,
      this.touchPoint,
      this.circleList,
      this.lineList,
      this.lockState: LockState.normal,
      this.backgroundColor: Colors.white}) {
    _normalOuterCirclePaint = Paint()
      ..color = circleAttribute.normalColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleAttribute.circleStrokeWidth;

    _normalInnerCirclePaint = Paint()
      ..color = circleAttribute.normalColor
      ..style = PaintingStyle.fill;

    _errorInnerCirclePaint = Paint()
      ..color = circleAttribute.errorColor
      ..style = PaintingStyle.fill;

    _errorOuterCirclePaint = Paint()
      ..color = circleAttribute.errorColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleAttribute.circleStrokeWidth;

    _normalLinePaint = Paint()
      ..color = circleAttribute.normalColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleAttribute.circleStrokeWidth;

    _errorLinePaint = Paint()
      ..color = circleAttribute.errorColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleAttribute.circleStrokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 画线
    if (lineList.length > 0) {
      final Paint linePaint =
          lockState == LockState.normal ? _normalLinePaint : _errorLinePaint;

      for (int i = 0; i < lineList.length; i++) {
        canvas.drawLine(
            lineList[i].offset,
            i == (lineList.length - 1) ? touchPoint : lineList[i + 1].offset,
            linePaint);
      }
    }

    final Paint outerCirclePaint = lockState == LockState.normal
        ? _normalOuterCirclePaint
        : _errorOuterCirclePaint;
    final Paint innerCirclePaint = lockState == LockState.normal
        ? _normalInnerCirclePaint
        : _errorInnerCirclePaint;
    // 画圆
    for (int i = 0; i < circleList.length; i++) {
      Circle circle = circleList[i];

      // 选中时，画外圆 + 内圆
      // 未选中时，只画外圆
      if (circle.selected) {
        canvas.drawCircle(
            circle.offset, circleAttribute.outerCircleRadius, outerCirclePaint);
        canvas.drawCircle(
            circle.offset, circleAttribute.innerCircleRadius, innerCirclePaint);
      } else {
        canvas.drawCircle(circle.offset, circleAttribute.outerCircleRadius,
            _normalOuterCirclePaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
