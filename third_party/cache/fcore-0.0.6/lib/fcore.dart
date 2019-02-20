import 'dart:async';

import 'package:flutter/services.dart';

class Fcore {
  static const MethodChannel _channel =
      const MethodChannel('fcore');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
