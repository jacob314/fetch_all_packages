import 'dart:async';

import 'package:flutter/services.dart';

class Libvia {
  static const MethodChannel _channel =
      const MethodChannel('libvia');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
