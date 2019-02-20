import 'dart:async';

import 'package:flutter/services.dart';

class NativeTimezone {
  static const MethodChannel _channel = const MethodChannel('native_timezone');

  static Future<String> getLocalTimezone() async {
    dynamic res = await _channel.invokeMethod("getLocalTimezone");
    return res.toString();
  }
}
