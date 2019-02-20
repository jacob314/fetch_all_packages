library floating_bubble;

import 'dart:async';
import 'package:flutter/widgets.dart';

/// A floating widget, will automatically stick to the sides of the screen.
/// It is recommended to use a Floating action button
///
/// ```dart
/// Stack(
///   children: <Widget>[
///     MyPage(),
///     FloatingBubble(
///       child: PreferredSize(
///         child: FloatingActionButton(
///           child: Icon(Icons.exit_to_app),
///             heroTag: "FloatingButton",
///             onPressed: () => Navigator.of(context).pop(),
///           ),
///         preferredSize: Size(64.0, 64.0),
///       ),
///     )
///   ],
/// ),
/// ```
class FloatingBubble extends StatefulWidget {
  /// The child that is floating, *must* be a PreferredSizeWidget
  /// If you know how to get the size of a child without putting it in the tree
  /// Please open an issue
  final PreferredSizeWidget child;

  /// Creates a floating widget, will automatically stick to the sides of the screen.
  /// It is recommended to use a Floating action button
  ///
  /// ```dart
  /// Stack(
  ///   children: <Widget>[
  ///     MyPage(),
  ///     FloatingBubble(
  ///       child: PreferredSize(
  ///         child: FloatingActionButton(
  ///           child: Icon(Icons.exit_to_app),
  ///             heroTag: "FloatingButton",
  ///             onPressed: () => Navigator.of(context).pop(),
  ///           ),
  ///         preferredSize: Size(64.0, 64.0),
  ///       ),
  ///     )
  ///   ],
  /// ),
  /// ```
  const FloatingBubble({this.child});

  @override
  _FloatingBubbleState createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<FloatingBubble> {
  Offset _position;
  Duration _duration;

  @override
  Widget build(BuildContext context) => AnimatedPositioned(
      child: Draggable(
        child: widget.child,
        feedback: widget.child,
        childWhenDragging: const Offstage(),
        onDraggableCanceled: (v, o) async {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          final childWidth = widget.child.preferredSize.width;
          final childHeight = widget.child.preferredSize.height;
          final screenPadding = MediaQuery.of(context).padding;

          setState(() {
            _position = o;
            _duration = Duration.zero;
          });

          Future.delayed(
              const Duration(milliseconds: 16),
              () => setState(() {
                    if (o.dy <= (screenHeight * 0.15)) {
                      _position = Offset(
                          o.dx <= screenWidth * 0.02
                              ? screenWidth * 0.02
                              : o.dx >= screenWidth - childWidth
                                  ? screenWidth - childWidth
                                  : o.dx,
                          screenPadding.top + childHeight / 2);
                    } else if (o.dy >= (screenHeight * 0.85)) {
                      _position = Offset(
                          o.dx <= screenWidth * 0.02
                              ? screenWidth * 0.02
                              : o.dx >= screenWidth - childWidth
                                  ? screenWidth - childWidth
                                  : o.dx,
                          screenHeight - screenPadding.bottom - childHeight);
                    } else {
                      if (o.dx + (v.pixelsPerSecond.dx / 10) <
                          screenWidth / 2) {
                        _position = Offset(screenPadding.left + 8, o.dy);
                      } else {
                        _position = Offset(
                            screenWidth - screenPadding.right - childWidth,
                            o.dy);
                      }
                    }
                    _duration = const Duration(seconds: 1);
                  }));
        },
      ),
      duration: _duration ?? const Duration(microseconds: 1),
      curve: const ElasticOutCurve(),
      top: _position?.dy ?? MediaQuery.of(context).size.height * 0.60,
      left: _position?.dx ??
          MediaQuery.of(context).size.width -
              MediaQuery.of(context).padding.right -
              widget.child.preferredSize.width);
}
