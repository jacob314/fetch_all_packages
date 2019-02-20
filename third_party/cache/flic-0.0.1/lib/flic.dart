import 'dart:async';

import 'package:flutter/services.dart';

class Flic {
  static const MethodChannel _channel =
      const MethodChannel('flic');

  static Future<String> get platformVersion =>
      _channel.invokeMethod('getPlatformVersion');

  static Future<String> get init =>
      _channel.invokeMethod('init');

  static Future<String> get knownButtons =>
      _channel.invokeMethod('getKnownButtons');

  static Future<String> get grabButton =>
      _channel.invokeMethod('grabButton');

  static Future<String> get onButtonClick =>
      _channel.invokeMethod('onButtonClick');

}
