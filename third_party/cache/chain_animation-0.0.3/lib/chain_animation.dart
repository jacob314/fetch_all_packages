library chain_animation;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';


class ChainAnimation extends AnimatedWidget {
  static final _opacity = Tween<double>(begin: 0.0,end: 1.0);
  static final _size = Tween<double>(begin: 0.0,end: 150.0);
  Widget child;
  ChainAnimation({
    Key key,Animation<double> animation,
    @required this.child
  }) : super(key:key,listenable:animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    // TODO: implement build
    return Center(
      child: Opacity(
          opacity: _opacity.evaluate(animation),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            //height: _size.evaluate(animation),
            width: _size.evaluate(animation),
            child: child,
          ),
      ),
    );
  }
  

}
