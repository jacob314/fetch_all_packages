import 'dart:async';

import 'package:flutter/services.dart';

class CamsnapPlugin {
  static const MethodChannel _channel =
      const MethodChannel('camsnap_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
