import 'dart:async';

import 'package:flutter/services.dart';

class CognitoUserPool {
  static const MethodChannel _channel =
      const MethodChannel('cognito_user_pool');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
