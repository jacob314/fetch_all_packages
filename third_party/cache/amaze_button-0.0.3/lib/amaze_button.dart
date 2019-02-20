library amaze_button;

import 'dart:async';
import 'package:flutter/material.dart';

typedef Future<Null> FutureCallback();

/// Make future amazing!
class FutureAmazeButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  // final Future<Null> futureCall;
  final FutureCallback futureCall;

  FutureAmazeButton({this.child, this.onTap, this.futureCall});

  /// yuhu..
  @override
  FutureAmazeButtonState createState() => new FutureAmazeButtonState();
}

class FutureAmazeButtonState extends State<FutureAmazeButton>
    with TickerProviderStateMixin {
  AnimationController _circularProgressController;
  AnimationController _buttonController;

  @override
  void initState() {
    super.initState();

    _buttonController = new AnimationController(
        vsync: this,
        duration: new Duration(
          milliseconds: 500,
        ));

    _circularProgressController = new AnimationController(
        vsync: this,
        duration: new Duration(
          milliseconds: 800,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new ScaleTransition(
          scale: new Tween(begin: 1.0, end: 0.0).animate(_buttonController),
          child: Center(
            child: new InkWell(
              child: widget.child,
              onTap: () {
                _buttonController.forward().then((_) {
                  _circularProgressController.forward();
                  widget.futureCall().then((_) {
                    _circularProgressController.reverse().then((_) {
                      _buttonController.reverse();
                    });
                  });
                });
              },
            ),
          ),
        ),
        new ScaleTransition(
          child: Center(child: new CircularProgressIndicator()),
          scale: new Tween(begin: 0.0, end: 1.0)
              .animate(_circularProgressController),
        )
      ],
    );
  }
}
