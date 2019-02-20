import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

enum Log { DEBUG, WARNING, ERROR }

class FlutterPlugin {
  static const MethodChannel _channel = const MethodChannel('flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> printLog(
      {Log logType, @required String tag, @required String msg}) async {
    String log = "debug";
    if (logType == Log.WARNING) {
      log = "warning";
    } else if (logType == Log.ERROR) {
      log = "error";
    } else {
      log = "debug";
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'tag': tag,
      'msg': msg,
      'logType': log
    };

    final String result = await _channel.invokeMethod('printLog', params);
    return result;
  }
}
