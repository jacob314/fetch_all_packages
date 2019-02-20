import 'dart:async';

import 'package:flutter/services.dart';

class FlutterApplovin {
  static const MethodChannel _channel = const MethodChannel('flutter_applovin');

  static Future<String> get showInterstitial async {
    final String version = await _channel.invokeMethod('showInterstitial');
    return version;
  }

  static Future<String> get loadInterstitial async {
    final String version = await _channel.invokeMethod('loadInterstitial');
    return version;
  }
}
