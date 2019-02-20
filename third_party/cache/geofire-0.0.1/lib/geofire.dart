import 'dart:async';

import 'package:flutter/services.dart';

class Geofire {
  static const MethodChannel _channel = const MethodChannel('geofire');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<String>> nearBy(double lat, double lng) async {
    final List<dynamic> response =
        await _channel.invokeMethod('getQuery', {"lat": lat, "lng": lng});

    List<String> r = [];
    response.forEach((value) {
      r.add(value.toString());
    });

    return r;
  }
}
