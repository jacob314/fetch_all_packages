import 'dart:async';
import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

class Common {
  /* flutter 版本号 */
  static const VERSION_FLUTTER = 24;

  /*全局适配参数*/
  static const double STANDARD_SCREEN_WIDTH = 375.0;
  static const double STANDARD_SCREEN_HEIGHT = 667.0;

  /* 当前版本状态 */
  static const STATUS_VERSION_NEW = 100; //最新版本
  static const STATUS_VERSION_UPDATE = 200; //可更新版本
  static const STATUS_VERSION_ABANDONED = 300; //废弃版本


  static int VERSION_APP = -1;
  static String VERSION_NAME = '';
  static Map listIcon;

  /*app调试功能*/
  static const isReleaseMode = false;
  static const forcePrint = false;


  /* 是否为新版本*/
  static bool isNewRootNavigator = false;

  /* 是否开启开发者模式*/
  static bool isDeveloperMode = false;


  /*static getNavigatorObserver(){
    NavigatorObserver observer=new NavigatorObserver();
    observer.didPop(route, previousRoute){

    }
    
  }*/

  static bool isAndroid() {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  static bool isIOS() {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  static double getHeight() {
    return window.physicalSize.height / window.devicePixelRatio;
  }

  static double getPaddingBottom() {
    return window.padding.bottom / window.devicePixelRatio;
  }

  static double getWidth() {
    return window.physicalSize.width / window.devicePixelRatio;
  }

  static double getStandardHeight(double height,{double lowerLimit:-1.0,double upperLimit:-1.0}) {

    double _height = window.physicalSize.height / window.devicePixelRatio / STANDARD_SCREEN_HEIGHT*height;
    if(lowerLimit>=0&&lowerLimit>_height){
      _height=lowerLimit;
    }
    if(upperLimit>=0&&upperLimit<_height){
      _height=upperLimit;
    }

/*    print('getStandardHeight');
    print(window.physicalSize.height / window.devicePixelRatio);
    print(STANDARD_SCREEN_HEIGHT);
    print(_height);*/
    return _height;
  }

  static double getStandardWidth(double width,{double lowerLimit:-1.0,double upperLimit:-1.0}) {
    double _width =window.physicalSize.width / window.devicePixelRatio / STANDARD_SCREEN_WIDTH*width;

    if(lowerLimit>=0&&lowerLimit>_width){
      _width=lowerLimit;
    }
    if(upperLimit>=0&&upperLimit<_width){
      _width=upperLimit;
    }

    return _width;
  }

  static bool isDebug() {
    bool isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());

    if(isReleaseMode){
      isDebug=false;
    }
    return isDebug;
  }

  static var baseUrl;

//  static String getBaseUrl() {
//    return (baseUrl != null && baseUrl != false && baseUrl != '')
//        ? baseUrl
//        : isDebug() ? devBaseUrl : prodBaseUrl;
//  }
//
//  static String getSecret() {
//    return isAndroid() ? ANDROID_API_SECRET : IOS_API_SECRET;
//  }
//
//  static String getApiKey() {
//    return isAndroid() ? ANDROID_API_KEY : IOS_API_KEY;
//  }
}
