import 'dart:async';

import 'package:flutter/services.dart';

class Torch {
  static const MethodChannel _channel = const MethodChannel('io.siteplan.flutterplugins/torch');

	static Future turnOn() => _channel.invokeMethod('turnOn');

  static Future turnOff() => _channel.invokeMethod('turnOff');

  static Future<bool> get hasTorch async => await _channel.invokeMethod('hasTorch');

  static Future flash(Duration duration) => turnOn().whenComplete(() => Future.delayed(duration, () => turnOff()));
}
