import 'dart:async';

import 'package:flutter/services.dart';

class MyBattLevelKotlinSwift {
  static const MethodChannel _channel =
      const MethodChannel('my_batt_level_kotlin_swift');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
