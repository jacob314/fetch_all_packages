import 'dart:async';

import 'package:flutter/services.dart';

class PhonecallLog {
  static const MethodChannel _channel =
      const MethodChannel('phonecall_log');

  static Future<bool> checkPermission() async {
    final bool isGranted = await _channel.invokeMethod("checkPermission", null);
    return isGranted;
  }

  static Future<bool> requestPermission() async {
    final bool isGranted = await _channel.invokeMethod("requestPermission", null);
    return isGranted;
  }

  static Future getPhoneLogs() async {
    final Iterable  logs = await _channel.invokeMethod('getPhoneLogs');
    return logs.toList();
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
