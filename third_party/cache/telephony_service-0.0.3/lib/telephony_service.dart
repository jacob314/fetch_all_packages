import 'dart:async';

import 'package:flutter/services.dart';

class TelephonyService {
  static const MethodChannel _channel =
      const MethodChannel('telephony_service');

  static Future<String> get simSerialNumber async {
    final String simSN = await _channel.invokeMethod('getSimSerialNumber');
    return simSN;
  }

  static Future<String> get imei async {
    final String imei = await _channel.invokeMethod('getImei');
    return imei;
  }
}
