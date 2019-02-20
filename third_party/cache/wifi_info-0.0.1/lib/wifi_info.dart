import 'dart:async';

import 'package:flutter/services.dart';

class WifiInfo {
  static const MethodChannel _channel =
      const MethodChannel('samples.ly.com/wifiinfo');

  static Future<String> get ssid async {
    final String ssid = await _channel.invokeMethod('getWiFiName');
    return ssid;
  }
}
