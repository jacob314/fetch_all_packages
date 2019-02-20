import 'dart:async';

import 'package:flutter/services.dart';

class FlutterCommonPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_common_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void close() async {
    _channel.invokeMethod('closeToNative');
  }
}
