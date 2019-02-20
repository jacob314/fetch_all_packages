import 'dart:math';

import 'package:flutter/widgets.dart';

class ZoomableWidget extends StatefulWidget {
  ZoomableWidget({
    Key key,
    this.minScale: 0.7,
    this.maxScale: 1.4,
    this.enableZoom: true,
    this.panLimit: 1.0,
    this.singleFingerPan: true,
    this.multiFingersPan: true,
    this.enableRotate: false,
    this.child,
    this.onTap,
    this.zoomSteps: 0,
    this.autoCenter: false,
    this.bounceBackBoundary: true,
    this.enableFling: true,
    this.flingFactor: 1.0,
    this.onZoomChanged,
  })  : assert(minScale != null),
        assert(maxScale != null),
        assert(enableZoom != null),
        assert(panLimit != null),
        assert(singleFingerPan != null),
        assert(multiFingersPan != null),
        assert(enableRotate != null),
        assert(zoomSteps != null),
        assert(autoCenter != null),
        assert(bounceBackBoundary != null),
        assert(enableFling != null),
        assert(flingFactor != null);

  /// The minimum size for scaling.
  final double minScale;

  /// The maximum size for scaling.
  final double maxScale;

  /// Allow zooming the child widget.
  final bool enableZoom;

  /// Allow panning with one finger.
  final bool singleFingerPan;

  /// Allow panning with more than one finger.
  final bool multiFingersPan;

  /// Allow rotating the [image].
  final bool enableRotate;

  /// Create a boundary with the factor.
  final double panLimit;

  /// The child widget that is display.
  final Widget child;

  /// Tap callback for this widget.
  final VoidCallback onTap;

  /// Allow users to zoom with double tap steps by steps.
  final int zoomSteps;

  /// Center offset when zooming to min scale.
  final bool autoCenter;

  /// Enable the bounce-back boundary.
  final bool bounceBackBoundary;

  /// Allow fling image after pan.
  final bool enableFling;

  /// Greater value create greater fling distance.
  final double flingFactor;

  /// When the scale value changed, the callback will be invoked.
  final ValueChanged<double> onZoomChanged;

  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget>
    with TickerProviderStateMixin {
  double _zoom = 1.0;
  double _previousZoom = 1.0;
  Offset _previousPanOffset = Offset.zero;
  Offset _panOffset = Offset.zero;
  Offset _zoomOriginOffset = Offset.zero;
  double _rotation = 0.0;
  double _previousRotation = 0.0;

  Size _containerSize = Size.zero;

  AnimationController _resetZoomController;
  AnimationController _resetPanController;
  AnimationController _resetRotateController;
  AnimationController _bounceController;
  AnimationController _flingController;
  Animation<double> _zoomAnimation;
  Animation<Offset> _panOffsetAnimation;
  Animation<double> _rotateAnimation;
  Animation<Offset> _bounceAnimation;
  Animation<Offset> _flingAnimation;

  @override
  void initState() {
    _resetZoomController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _resetPanController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _resetRotateController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _bounceController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _flingController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    _resetZoomController.dispose();
    _resetPanController.dispose();
    _resetRotateController.dispose();
    _bounceController.dispose();
    _flingController.dispose();
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails details) {
    _bounceController.stop();
    _flingController.stop();
    setState(() {
      _zoomOriginOffset = details.focalPoint;
      _previousPanOffset = _panOffset;
      _previousZoom = _zoom;
      _previousRotation = _rotation;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    Size _boundarySize =
        Size(_containerSize.width / 2, _containerSize.height / 2);
    Size _marginSize = Size(100.0, 100.0);
    if (widget.enableRotate) {
      setState(() =>
          _rotation = (_previousRotation + details.rotation).clamp(-pi, pi));
    }
    if (widget.enableZoom && details.scale != 1.0) {
      setState(() {
        _zoom = (_previousZoom * details.scale)
            .clamp(widget.minScale, widget.maxScale);
        if (widget.onZoomChanged != null) widget.onZoomChanged(_zoom);
      });
    }
    if ((widget.singleFingerPan && details.scale == 1.0) ||
        (widget.multiFingersPan && details.scale != 1.0)) {
      Offset _panRealOffset = (details.focalPoint -
              _zoomOriginOffset +
              _previousPanOffset * _previousZoom) /
          _zoom;

      if (widget.panLimit == 0.0) {
        _panOffset = _panRealOffset;
      } else {
        Offset _baseOffset = Offset(
            _panRealOffset.dx.clamp(
              -_boundarySize.width / _zoom * widget.panLimit,
              _boundarySize.width / _zoom * widget.panLimit,
            ),
            _panRealOffset.dy.clamp(
              -_boundarySize.height / _zoom * widget.panLimit,
              _boundarySize.height / _zoom * widget.panLimit,
            ));

        Offset _marginOffset = _panRealOffset - _baseOffset;
        double _widthFactor = sqrt(_marginOffset.dx.abs()) / _marginSize.width;
        double _heightFactor =
            sqrt(_marginOffset.dy.abs()) / _marginSize.height;
        _marginOffset = Offset(
          _marginOffset.dx * _widthFactor * 2,
          _marginOffset.dy * _heightFactor * 2,
        );
        _panOffset = _baseOffset + _marginOffset;
      }
      setState(() {});
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    Size _boundarySize =
        Size(_containerSize.width / 2, _containerSize.height / 2);
    final Offset velocity = details.velocity.pixelsPerSecond;
    final double magnitude = velocity.distance;
    if (magnitude > 800.0 * _zoom && widget.enableFling) {
      final Offset direction = velocity / magnitude;
      final double distance = (Offset.zero & context.size).shortestSide;
      final Offset endOffset =
          _panOffset + direction * distance * widget.flingFactor * 0.5;
      _flingAnimation = Tween(
          begin: _panOffset,
          end: Offset(
              endOffset.dx.clamp(
                -_boundarySize.width / _zoom * widget.panLimit,
                _boundarySize.width / _zoom * widget.panLimit,
              ),
              endOffset.dy.clamp(
                -_boundarySize.height / _zoom * widget.panLimit,
                _boundarySize.height / _zoom * widget.panLimit,
              ))).animate(_flingController)
        ..addListener(() => setState(() => _panOffset = _flingAnimation.value));

      _flingController
        ..value = 0.0
        ..fling(velocity: magnitude / 1000.0);
    } else {
      Offset _borderOffset = Offset(
        _panOffset.dx.clamp(
          -_boundarySize.width / _zoom * widget.panLimit,
          _boundarySize.width / _zoom * widget.panLimit,
        ),
        _panOffset.dy.clamp(
          -_boundarySize.height / _zoom * widget.panLimit,
          _boundarySize.height / _zoom * widget.panLimit,
        ),
      );
      if (_zoom == widget.minScale && widget.autoCenter) {
        _borderOffset = Offset.zero;
      }
      _bounceAnimation = Tween(begin: _panOffset, end: _borderOffset).animate(
        CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
      )..addListener(() => setState(() => _panOffset = _bounceAnimation.value));
      _bounceController.forward(from: 0.0);
    }
  }

  void _handleDoubleTap() {
    double _stepLength = 0.0;

    if (widget.zoomSteps > 0)
      _stepLength = (widget.maxScale - 1.0) / widget.zoomSteps;

    double _tmpZoom = _zoom + _stepLength;
    if (_tmpZoom > widget.maxScale || _stepLength == 0.0) _tmpZoom = 1.0;
    _zoomAnimation = Tween(begin: _tmpZoom, end: _zoom).animate(
      CurvedAnimation(parent: _resetZoomController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {
          _zoom = _zoomAnimation.value;
          if (widget.onZoomChanged != null) widget.onZoomChanged(_zoom);
        });
      });
    if (_tmpZoom == 1.0) {
      _panOffsetAnimation = Tween(begin: Offset.zero, end: _panOffset).animate(
        CurvedAnimation(parent: _resetPanController, curve: Curves.easeInOut),
      )..addListener(() {
          setState(() => _panOffset = _panOffsetAnimation.value);
        });
      _resetPanController.reverse(from: 1.0);
    }

    if (_zoom < 0)
      _resetZoomController.forward(from: 1.0);
    else
      _resetZoomController.reverse(from: 1.0);

    _rotateAnimation = Tween(begin: _rotation, end: 0.0).animate(
      CurvedAnimation(parent: _resetRotateController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {
          _rotation = _rotateAnimation.value;
        });
      });
    _resetRotateController.forward(from: 0.0);

    setState(() {
      _previousZoom = _tmpZoom;
      if (_tmpZoom == 1.0) {
        _zoomOriginOffset = Offset.zero;
        _previousPanOffset = Offset.zero;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return Container();

    return CustomMultiChildLayout(
      delegate: _ZoomableWidgetLayout(),
      children: <Widget>[
        LayoutId(
          id: _ZoomableWidgetLayout.painter,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints box) {
            _containerSize = Size(box.minWidth, box.minHeight);
            return Transform(
              alignment: Alignment.center,
              origin: Offset(-_panOffset.dx, -_panOffset.dy),
              transform: Matrix4.identity()
                ..translate(_panOffset.dx, _panOffset.dy)
                ..scale(_zoom, _zoom),
              child: Transform.rotate(
                angle: _rotation,
                child: widget.child,
              ),
            );
          }),
        ),
        LayoutId(
          id: _ZoomableWidgetLayout.gestureContainer,
          child: GestureDetector(
            child: Container(color: Color(0)),
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onScaleEnd: widget.bounceBackBoundary ? _onScaleEnd : null,
            onDoubleTap: _handleDoubleTap,
            onTap: widget.onTap,
          ),
        ),
      ],
    );
  }
}

class _ZoomableWidgetLayout extends MultiChildLayoutDelegate {
  _ZoomableWidgetLayout();

  static final String gestureContainer = 'gesturecontainer';
  static final String painter = 'painter';

  @override
  void performLayout(Size size) {
    layoutChild(gestureContainer,
        BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(gestureContainer, Offset.zero);
    layoutChild(painter,
        BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(painter, Offset.zero);
  }

  @override
  bool shouldRelayout(_ZoomableWidgetLayout oldDelegate) => false;
}
