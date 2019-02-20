import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum Toast { LENGTH_SHORT, LENGTH_LONG }

enum ToastGravity { TOP, BOTTOM, CENTER }

class NativeUtilsPlugin {

  static const MethodChannel _channel = const MethodChannel('ice_tea_studio_plugins');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Null> showToast({@required String msg, String backgroundColor,
    String textColor, int textSize, bool isFullWidth, int time, Toast toastLength, ToastGravity gravity}) async {
    String toast = "short";

    if (toastLength != null && toastLength == Toast.LENGTH_LONG) {
      toast = "long";
    }

    String gravityToast = "bottom";

    if (gravity != null) {
      switch (gravity) {
        case ToastGravity.TOP:
          gravityToast = "top";
          break;

        case ToastGravity.CENTER:
          gravityToast = "center";
          break;

        default:
          gravityToast = "bottom";
          break;
      }
    }

    String fullWidth = 'false';
    if (isFullWidth != null && isFullWidth) {
      fullWidth = 'true';
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'backgroundColor': backgroundColor ?? '#84bd00',
      'textColor': textColor ?? '#ffffff',
      'length': toast,
      'time': time,
      'isFullWidth': fullWidth,
      'gravity': gravityToast,
      'textSize': textSize ?? 12
    };
    await _channel.invokeMethod('showToast', params);
  }

}
