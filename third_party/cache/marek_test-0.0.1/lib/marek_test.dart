import 'dart:async';

import 'package:flutter/services.dart';

class MarekTest {
  static const MethodChannel _channel =
      const MethodChannel('marek_test');

  static Future<String> get platformVersion =>
      _channel.invokeMethod('getPlatformVersion');
}
