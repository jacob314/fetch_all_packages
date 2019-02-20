import 'dart:async';

import 'package:flutter/services.dart';

class GmsPath {
  static const MethodChannel _channel =
      const MethodChannel('gms_path');

  static Future<String> get encodedPath async {
    final String encodedPath = await _channel.invokeMethod('getEncodedString');
    return encodedPath;
  }

  static Future<bool> createPathInstance() async {
    return await _channel.invokeMethod('createPathInstance');
  }

  static Future<bool> addCoordinate(double latitude, double longitude) async {
    Map<String, double> values = Map<String, double>();
    values['latitude'] = latitude;
    values['longitude'] = longitude;
    return await _channel.invokeMethod('addCoordinate', values);
  }

}
