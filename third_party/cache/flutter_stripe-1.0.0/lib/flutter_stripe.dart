import 'dart:async';

import 'package:flutter/services.dart';

class FlutterStripe {
  static const MethodChannel _channel = const MethodChannel('flutter_stripe');

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<bool> promptNativePayment(String token) async {
    final String result = await _channel.invokeMethod("promptNativePayment", {
      token: 0.1,
    });
    return result != null;
  }
}
