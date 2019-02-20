import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

typedef bool LoadingButtonTapCallback();

class LoadingButton extends StatefulWidget {

  final String label;
  final LoadingButtonTapCallback onPress;
  final double width;
  final double height;
  final Color textColor;
  final Color backgroundColor;

  LoadingButton(this.label, {
    Key key,
    this.onPress,
    this.width = 120.0,
    this.height = 40.0,
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  LoadingButtonState createState() => new LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation<double> _animation;
  bool _isPressed = false;
  bool _isPlayingAnimation = false;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        duration: new Duration(milliseconds: 1500),
        vsync: this
    );

    _animation = new Tween(begin: widget.width, end: 40.0).animate(new CurvedAnimation(
      parent: _animationController,
      curve: new Interval(0.0, 0.150,),
    ));

    _animation.addListener((){
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<Null> startLoading() async {
    try {
      if (_isPlayingAnimation){
        return;
      }

      _isPlayingAnimation = true;
      await _animationController.forward();
    } on TickerCanceled {}
  }

  Future<Null> stopLoading() async {
    try {
      setState(() {
        _isPressed = false;
        _isPlayingAnimation = false;
      });
      await _animationController.reverse();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {

    bool showIndicator = _animation.value <= 45.0;
    var indicator = new SizedBox(
      height: widget.height,
      width: widget.height,
      child: new CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).iconTheme.color),
        strokeWidth: 2.0,
      ),
    );

    return InkWell(
      enableFeedback: true,
      onTap: () {
        bool pressSucceed = true;
        if (!_isPressed && widget.onPress != null){
          pressSucceed = widget.onPress();
        }

        setState(() {
          _isPressed = pressSucceed;
        });
      },
      borderRadius: new BorderRadius.all(Radius.circular(widget.height/2)),
//      radius:0.0,
      child: new Container(
        width: _animation.value,
        height: widget.height,
        alignment: FractionalOffset.center,
        decoration: new BoxDecoration(
          color: widget.backgroundColor??Theme.of(context).buttonColor,
          borderRadius: new BorderRadius.all(Radius.circular(widget.height/2)),
        ),
        child: new Padding(
          padding: EdgeInsets.all(10.0),
          child: showIndicator ? indicator : new AnimatedOpacity(
            opacity: _animation.value < widget.width ? 0.0 : 1.0,
            duration: const Duration(microseconds: 100),
            child: new Text(
              widget.label,
              style: new TextStyle(fontSize: 14.0,
                  color: widget.textColor??Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        )
      ),
    );


  }

}