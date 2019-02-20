import 'dart:async';

import 'package:flutter/services.dart';

class GetIosDeviceIdfa {
  static const MethodChannel _channel =
      const MethodChannel('get_ios_device_idfa');

  static Future<String> get getIDFA async {
    final String version = await _channel.invokeMethod('getIDFA');
    return version;
  }
}
