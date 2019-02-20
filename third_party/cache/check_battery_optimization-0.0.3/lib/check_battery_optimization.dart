import 'dart:async';

import 'package:flutter/services.dart';

class CheckBatteryOptimization {
  static const MethodChannel _channel =
      const MethodChannel('check_battery_optimization');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get reading async {
    final reading = await _channel.invokeMethod('checkBatteryOptimization');
    return reading;
  }
}
