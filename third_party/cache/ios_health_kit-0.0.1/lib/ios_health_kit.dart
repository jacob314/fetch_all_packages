import 'dart:async';

import 'package:flutter/services.dart';

class HKHealthStore {
  static const MethodChannel _channel = const MethodChannel('ios_health_kit');

  static Future<bool> get isHealthDataAvailable async =>
      await _channel.invokeMethod('isHealthDataAvailable');

  Future<String> authorizationStatus(String type) async {
    String s = await _channel.invokeMethod('authorizationStatus', {
      "type": type
    });
    return s;
  }

  Future<bool> requestAuthorization(Set<String> share, Set<String> read) async {
    bool b = await _channel.invokeMethod('requestAuthorization', {
      "share": share?.toList() ?? [],
      "read": read?.toList() ?? []
    });
    return b;
  }

  Future<String> biologicalSex() async {
    String s = await _channel.invokeMethod('biologicalSex');
    return s;
  }

  Future<String> bloodType() async {
    String s = await _channel.invokeMethod('bloodType');
    return s;
  }

  Future<DateTime> dateOfBirth() async {
    String s = await _channel.invokeMethod('dateOfBirth');
    return DateTime.parse(s);
  }

  Future<String> fitzpatrickSkinType() async {
    String s = await _channel.invokeMethod('fitzpatrickSkinType');
    return s;
  }

  Future<String> wheelchairUse() async {
    String s = await _channel.invokeMethod('wheelchairUse');
    return s;
  }
}
