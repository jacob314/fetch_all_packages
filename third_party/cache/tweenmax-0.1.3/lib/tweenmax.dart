library tweenmax;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tweenmax/tween_data.dart';
import 'package:tweenmax/tween_container.dart';

// Exports:
export 'package:tweenmax/tween_data.dart';
export 'package:tweenmax/tween_container.dart';

typedef void OnUpdateCallback(double);

class TweenMax implements TickerProvider {
  final TweenContainer target;
  final TweenData data;
  final double duration; // in seconds
  final double delay;
  final bool autoplay;
  final bool yoyo;
  final int repeat;
  final Curve ease;
  final VoidCallback onComplete;
  final OnUpdateCallback onUpdate;

  TweenMax(
    this.target, {
    this.data,
    this.duration,
    this.delay,
    this.yoyo = false,
    this.autoplay = true,
    this.repeat = 0,
    this.ease,
    this.onComplete,
    this.onUpdate,
  }){
    init();
  }

  Ticker _ticker;

  TweenData oldData;

  AnimationController controller;
  Animation<double> animation;
  Animation<Color> animationColor;
  Animation<BorderRadius> animationBorderRadius;
  Animation<EdgeInsets> animationPadding;
  Animation<EdgeInsets> animationMargin;
  Animation<Border> animationBorder;
  
  // bool shouldTweenPosition = false;
  @override
    Ticker createTicker(onTick) {
      _ticker = Ticker(onTick);
      return _ticker;
    }
  
  static TweenMax to(
    TweenContainer target,
    {
      TweenData data,
      double duration,
      double delay,
      int repeat = 0,
      bool autoplay = true,
      bool yoyo = false,
      Curve ease,
      VoidCallback onComplete,
      OnUpdateCallback onUpdate,
    }
  ){
    TweenMax tween = TweenMax(
      target,
      data: data,
      duration: duration,
      delay: delay,
      repeat: repeat,
      yoyo: yoyo,
      autoplay: autoplay,
      ease: ease,
      onComplete: onComplete,
      onUpdate: onUpdate
    );

    target.tweens.add(tween);

    return tween;
  }

  static killTweensOf(TweenContainer target){
    if(target.tweens.length > 0){
      for(int i=0; i<target.tweens.length; i++){
        target.tweens[i].dispose();
      }
      target.tweens = [];
    }
  }

  void init() {

    oldData = target.data.clone();

    if(data.transformOrigin != null) target.data.transformOrigin = data.transformOrigin;

    int speed = (duration != null) ? (duration * 1000).toInt() : 1000;
    
    controller = AnimationController(
      duration: Duration(milliseconds: speed), 
      vsync: this
    );

    CurvedAnimation curve = CurvedAnimation(parent: controller, curve: ease);

    // Animations

    if(data.color != null){
      animationColor = ColorTween(begin: target.data.color, end: data.color).animate(curve);
      animationColor.addListener(onColorAnimating);
    }

    if(data.border != null){
      animationBorder = BorderTween(begin: target.data.border, end: data.border).animate(curve);
      animationBorder.addListener(onBorderAnimating);
    }

    if(data.borderRadius != null){
      animationBorderRadius = BorderRadiusTween(begin: target.data.borderRadius, end: data.borderRadius).animate(curve);
      animationBorderRadius.addListener(onBorderRadiusAnimating);
    }

    if(data.padding != null){
      animationPadding = EdgeInsetsTween(begin: target.data.padding, end: data.padding).animate(curve);
      animationPadding.addListener(onPaddingAnimating);
    }

    if(data.margin != null){
      animationMargin = EdgeInsetsTween(begin: target.data.margin, end: data.margin).animate(curve);
      animationMargin.addListener(onMarginAnimating);
    }

    animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    animation.addStatusListener(onAnimationStatus);
    animation.addListener(onAnimating);

    // 

    if(autoplay){
      if(delay != null){
        Future.delayed(Duration(milliseconds: (delay * 1000).toInt() ), play);
      } else {
        play();
      }
    }
  }

  void dispose() {
    controller.dispose();
    _ticker.dispose();
  }

  void onAnimating(){
    double progress = animation.value;

    if(data.top != null) target.data.top = oldData.top + progress * (data.top - oldData.top);
    if(data.left != null) target.data.left = oldData.left + progress * (data.left - oldData.left);
    if(data.right != null) target.data.right = oldData.right + progress * (data.right - oldData.right);
    if(data.bottom != null) target.data.bottom = oldData.bottom + progress * (data.bottom - oldData.bottom);
    if(data.width != null) target.data.width = oldData.width + progress * (data.width - oldData.width);
    if(data.height != null) target.data.height = oldData.height + progress * (data.height - oldData.height);
    if(data.opacity != null) target.data.opacity = oldData.opacity + progress * (data.opacity - oldData.opacity);
    if(data.rotation != null) target.data.rotation = oldData.rotation + progress * (data.rotation - oldData.rotation);

    if(data.scale != null) {
      target.data.scale = Offset(
        oldData.scale.dx + progress * (data.scale.dx - oldData.scale.dx), 
        oldData.scale.dy + progress * (data.scale.dy - oldData.scale.dy)
      );
    }
    
    // print("Current size: $currentWidth x $currentHeight");
    
    target.update();

    if(onUpdate != null) onUpdate(progress);
  }

  void onColorAnimating(){
    target.data.color = animationColor.value;
  }

  void onBorderAnimating(){
    target.data.border = animationBorder.value;
  }

  void onBorderRadiusAnimating(){
    target.data.borderRadius = animationBorderRadius.value;
  }

  void onPaddingAnimating(){
    target.data.padding = animationPadding.value;
  }

  void onMarginAnimating(){
    target.data.margin = animationMargin.value;
  }

  void onAnimationStatus(status){
    // print("a");
    if (status == AnimationStatus.completed) {
      if(onComplete != null){
        onComplete();
      }

      if(repeat == 0){
        target.killTween(this);
      } else {
        if(yoyo){
          controller.reverse();
        } else {
          controller.reset();
          // print(oldData.scale);
          target.data = oldData.clone();
          target.update();
        }
      }
    } else if (status == AnimationStatus.dismissed) {
      // print("dismissed");
      if(repeat != 0) controller.forward();
    }
  }

  TweenMax stop(){
    if(controller != null) controller.stop();
    return this;
  }

  TweenMax play(){
    if(controller != null) controller.forward();
    return this;
  }

  TweenMax seek(double timeScalePosition){
    if(controller != null){
      if(timeScalePosition > 1) timeScalePosition = 1;
      if(timeScalePosition < 0) timeScalePosition = 0;
      controller.value = timeScalePosition;
    }
    return this;
  }

}

