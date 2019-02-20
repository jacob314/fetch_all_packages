import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice_tea_studio_plugins/ice_tea_studio_plugins.dart';
import 'package:icetea_studio_core/ui/styles/theme.dart';

String _toRGBFromKColor(Color color) {
  return "#${color.toString().substring(10).replaceAll(')', '')}";
}

class ToastUtils {
  static final themeData = buildAppTheme();
  static final String defaultColor =  _toRGBFromKColor(themeData.hintColor);
  static final String infoColor =  _toRGBFromKColor(themeData.accentColor);
  static final String warningColor =  _toRGBFromKColor(themeData.accentColor);
  static final String errorColor =  _toRGBFromKColor(themeData.errorColor);
  static final String textColor =  _toRGBFromKColor(themeData.accentTextTheme.title.color);


  static showToast(String message, {int duration = 3}) {
    try {
      NativeUtilsPlugin.showToast(msg: message,
          isFullWidth: true,
          gravity: ToastGravity.TOP,
          backgroundColor: infoColor,
          toastLength: Toast.LENGTH_SHORT,
          time: duration,
          textColor: textColor,
          textSize: 14
      );
    } on PlatformException {
      print('Failed to get platform version.');
    }
  }

  static showWarningToast(String message, {int duration = 2}) {
    try {
      NativeUtilsPlugin.showToast(msg: message,
          isFullWidth: true,
          gravity: ToastGravity.TOP,
          backgroundColor: warningColor,
          toastLength: Toast.LENGTH_SHORT,
          time: duration,
          textColor: textColor,
          textSize: 14);
    } on PlatformException {
      print('Failed to get platform version.');
    }
  }

  static showInfoToast(String message, {int duration = 3}) {
    try {
      NativeUtilsPlugin.showToast(msg: message,
          isFullWidth: true,
          gravity: ToastGravity.TOP,
          backgroundColor: infoColor,
          toastLength: Toast.LENGTH_SHORT,
          time: duration,
          textColor: textColor,
          textSize: 14);
    } on PlatformException {
      print('Failed to get platform version.');
    }
  }

  static showErrorToast(String message, {int duration = 3}) {
    try {
      NativeUtilsPlugin.showToast(msg: message,
          isFullWidth: true,
          gravity: ToastGravity.TOP,
          backgroundColor: errorColor,
          toastLength: Toast.LENGTH_SHORT,
          time: duration,
          textColor: textColor,
          textSize: 14);
    } on PlatformException {
      print('Failed to get platform version.');
    }
  }


  /// For more information: https://github.com/burhanrashid52/WhatTodo/blob/master/lib/pages/tasks/task_complted.dart
  static showSnackBar(GlobalKey<ScaffoldState> scaffoldState, String message, {MaterialColor materialColor}) {
    if (message.isEmpty)
      return;

    scaffoldState.currentState.showSnackBar(new SnackBar(content: new Text(message), backgroundColor: materialColor));
  }
}