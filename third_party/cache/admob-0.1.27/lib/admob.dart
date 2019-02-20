import 'dart:async';

import 'package:flutter/services.dart';

class Admob {

  static const MethodChannel _channel =
      const MethodChannel('admob');

  static Future<String> get showInterstitial =>
      _channel.invokeMethod('showInterstitial');

  static Future<String> loadInterstitial(String APP_ID, String AD_UNIT_ID, String DEVICE_ID, bool TESTING) {
    String s = APP_ID + "," + AD_UNIT_ID + "," + DEVICE_ID + "," + TESTING.toString();
    return _channel.invokeMethod('loadInterstitial', s);
  }

  static Future<String> showBanner(String APP_ID, String AD_UNIT_ID, String DEVICE_ID, bool TESTING, String PLACEMENT) {
    String s = APP_ID + "," + AD_UNIT_ID + "," + DEVICE_ID + "," + TESTING.toString() + ',' + PLACEMENT;
    return _channel.invokeMethod('showBanner', s);
  }

  static Future<String> closeBanner() {
    return _channel.invokeMethod('closeBanner');
  }

}
