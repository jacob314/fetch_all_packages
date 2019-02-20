import 'dart:async';

import 'package:flutter/services.dart';

/// Flutter plugin for iOS DeviceCheck.
///
/// See https://developer.apple.com/documentation/devicecheck
class IosDeviceCheck {
  IosDeviceCheck._();

  static const MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/ios_device_check');

  /// Boolean value derived from DCDevice's `isSupported`.
  static Future<bool> get isSupported async =>
      await _channel.invokeMethod('isSupported');

  /// The token string derived from DCDevice's `generateToken`.
  static Future<String> generateToken() async {
    String token = await _channel.invokeMethod('generateToken');
    return token;
  }
}
