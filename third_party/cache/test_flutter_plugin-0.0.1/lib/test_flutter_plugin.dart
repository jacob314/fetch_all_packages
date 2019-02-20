import 'dart:async';

import 'package:flutter/services.dart';

class TestFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('test_flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
