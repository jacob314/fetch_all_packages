import 'dart:math';

import 'package:flutter/material.dart';

class SinPoints extends StatefulWidget {
  SinPoints({
    Key key,
    this.pointBgColor = Colors.transparent,
    this.pointColor = const Color(0xff33b5e5),
    this.duration = const Duration(milliseconds: 750),
    this.running = true,
  }) : super(key: key);

  final Duration duration;
  final bool running;
  
  final Color pointBgColor;
  final Color pointColor;

  @override
  _SinPointsState createState() => _SinPointsState();
}

class _SinPointsState extends State<SinPoints>
    with SingleTickerProviderStateMixin {
  final Key _sinPointsKey = GlobalKey();
  final double _subAngle = 30;

  Tween<double> _tween;
  Animation _animation;
  AnimationController _animationController;

  double _leftPointAngle = 0;
  double _centerPointAngle = 0;
  double _rightPointAngle = 0;

  double _centerOffset = -1;
  double _rightOffset = -1;

  bool _leftPointStart = false;
  bool _centerPointStart = false;
  bool _rightPointStart = false;

  bool _centerStart = false;
  bool _rightStart = false;

  bool _requestStoped = false;

  bool _leftStoped = true;
  bool _centerStoped = true;
  bool _rightStoped = true;

  void _updateAngles() {
    _leftPointAngle = _leftPointStart ? _animation.value : 0;
        
    _centerPointStart = _centerPointStart || _leftPointAngle >= _subAngle;
    if (_centerPointStart && _centerOffset < 0) {
      _centerOffset = _subAngle;
    }
    _centerPointAngle = _centerPointStart ? (_leftPointAngle - _subAngle) : 0;
    if (_centerOffset > 0) {
      _centerPointAngle = _centerPointAngle - _centerOffset;
    }
    
    _centerStart = _centerStart || _centerPointAngle > 0;
    if (!_centerStart) {
      _centerPointAngle = max(_centerPointAngle, 0);
    }
        
    _rightPointStart = _rightPointStart || _centerPointAngle >= _subAngle;
    if (_rightPointStart && _rightOffset < 0) {
      _rightOffset = _subAngle * 2;
    }
    _rightPointAngle = _rightPointStart ? (_centerPointAngle - _subAngle) : 0;
    if (_rightOffset > 0) {
      _rightPointAngle = _rightPointAngle - _rightOffset;
    }
    
    _rightStart = _rightStart || _rightPointAngle > 0;
    if (!_rightStart) {
      _rightPointAngle = max(_rightPointAngle, 0);
    }
  }

  void _start() {
    _leftPointStart = true;
    _animationController.repeat(period: widget.duration);
    _leftStoped = false;
    _centerStoped = false;
    _rightStoped = false;
  }

  void _requestStart() {
    if (_leftPointStart) {
      return;
    }
    _requestStoped = false;
    _start();
  }

  void _stop() {
    _animationController.stop();
    _leftPointAngle = 0;
    _centerPointAngle = 0;
    _rightPointAngle = 0;
    _centerOffset = -1;
    _rightOffset = -1;
    _leftPointStart = false;
    _centerPointStart = false;
    _rightPointStart = false;
    _centerStart = false;
    _rightStart = false;
    _leftStoped = true;
    _centerStoped = true;
    _rightStoped = true;
  }

  void _requestStop() {
    _requestStoped = true;
  }

  bool _checkAnimationStop() {
    if (_requestStoped) {
      double la = _leftPointAngle.abs();
      double ca = _centerPointAngle.abs();
      double ra = _rightPointAngle.abs();
      // print('Angle: $la, $ca, $ra');
      _leftStoped = _leftStoped ||
          (la >= 0 && la < 10) ||
          (la > 170 && la <= 180) ||
          (la > 350 && la <= 360);
      if (_leftStoped) {
        _centerStoped = _centerStoped ||
            (ca >= 0 && ca < 10) ||
            (ca > 170 && ca <= 180) ||
            (ca > 350 && ca <= 360);
      }
      if (_centerStoped) {
        _rightStoped = _rightStoped ||
            (ra >= 0 && ra < 10) ||
            (ra > 170 && ra <= 180) ||
            (ra > 350 && ra <= 360);
      }
      if (_leftStoped) {
        _leftPointAngle = 0;
      }
      if (_centerStoped) {
        _centerPointAngle = 0;
      }
      if (_rightStoped) {
        _rightPointAngle = 0;
      }
    }
    return _leftStoped && _centerStoped && _rightStoped;
  }

  @override
  void initState() {
    super.initState();
    _tween = Tween(
      begin: 0,
      end: 360,
    );
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener((){
      // print('Value: ${_animation.value}');
      setState((){
        _updateAngles();
        if (_checkAnimationStop()) {
          _stop();
        }
      });
    });
    _animation = _animationController.drive(_tween);
  }

  @override
  void didUpdateWidget(SinPoints oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.running) {
      _requestStart();
    } else {
      _requestStop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('Angle: $_leftPointAngle, $_centerPointAngle, $_rightPointAngle');
    return CustomPaint(
      key: _sinPointsKey,
      painter: _SinPointsPainter(
        pointBgColor: widget.pointBgColor,
        pointColor: widget.pointColor,
        leftPointAngle: _leftPointAngle??0,
        centerPointAngle: _centerPointAngle??0,
        rightPointAngle: _rightPointAngle??0,
      ),
      child: Container(), // Size
    );
  }
}

class _SinPointsPainter extends CustomPainter {
  _SinPointsPainter({
    this.pointBgColor,
    this.pointColor,
    this.leftPointAngle = 0,
    this.centerPointAngle = 0,
    this.rightPointAngle = 0,
  }) : super() {
    _pointBgPaint = Paint()
      ..color = pointBgColor;
    _pointPaint = Paint()
      ..color = pointColor;
  }

  final Color pointBgColor;
  final Color pointColor;
  
  final double leftPointAngle;
  final double centerPointAngle;
  final double rightPointAngle;

  Offset _center;
  Offset _leftCenter;
  Offset _rightCenter;

  double _pointBgRadius;
  double _pointRadius;

  Paint _pointBgPaint;
  Paint _pointPaint;

  @override
  void paint(Canvas canvas, Size size) {
    _pointBgRadius = min(size.width, size.height) / 2;
    _pointRadius = _pointBgRadius * 0.15;
    _center = Offset(size.width / 2, size.height / 2);
    _leftCenter = Offset(_center.dx - _pointBgRadius * 0.47, _center.dy);
    _rightCenter = Offset(_center.dx + _pointBgRadius * 0.47, _center.dy);

    // canvas save
    canvas.save();
    
    // point bg
    canvas.drawCircle(
      _center,
      _pointBgRadius,
      _pointBgPaint);

    // left point
    canvas.drawCircle(
      Offset(_leftCenter.dx, _leftCenter.dy - _sin(leftPointAngle)),
      _pointRadius,
      _pointPaint);

    // center point
    canvas.drawCircle(
      Offset(_center.dx, _center.dy - _sin(centerPointAngle)),
      _pointRadius,
      _pointPaint);

    // right point
    canvas.drawCircle(
      Offset(_rightCenter.dx, _rightCenter.dy - _sin(rightPointAngle)),
      _pointRadius,
      _pointPaint);

    // canvas restore
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double _sin(double value) {
    return sin(value * pi / 180) * _pointRadius * 1.8;
  }
}
