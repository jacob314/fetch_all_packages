import 'dart:async';

import 'package:flutter/services.dart';

/// Platform-independend vibration methods.
class Vibration {
  /// Method channel to communicate with native code.
  static const MethodChannel _channel = const MethodChannel('vibration');

  /// Check if vibrator is available on device.
  /// 
  /// ```dart
  /// if (Vibration.hasVibrator()) {
  ///   Vibration.vibrate();
  /// }
  /// ```
  static Future hasVibrator() => _channel.invokeMethod("hasVibrator");

  /// Vibrate with [duration] or [pattern].
  /// The default vibration duration is 500ms.
  /// 
  /// ```dart
  /// Vibration.vibrate(duration: 1000);
  /// ```
  static Future<void> vibrate(
          {int duration = 500,
          List<int> pattern = const [],
          int repeat = -1}) =>
      _channel.invokeMethod("vibrate",
          {"duration": duration, "pattern": pattern, "repeat": repeat});

  /// Cancel ongoing vibration.
  /// 
  /// ```dart
  /// Vibration.vibrate(duration: 10000);
  /// Vibration.cancel();
  /// ```
  static Future<void> cancel() => _channel.invokeMethod("cancel");
}
