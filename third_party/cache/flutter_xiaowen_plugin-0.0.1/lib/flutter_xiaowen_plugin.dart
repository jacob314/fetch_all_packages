import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPlugin {
  static const MethodChannel _channel = const MethodChannel('flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get packageName async {
    final String packageName = await _channel.invokeMethod("getPackageName");
    return packageName;
  }

  static Future<String> get currentApplicationName async {
    final String packageName = await _channel.invokeMethod("getCurrentApplication");
    return packageName;
  }
}
