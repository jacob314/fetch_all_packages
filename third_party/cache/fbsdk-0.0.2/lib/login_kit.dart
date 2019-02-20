import 'dart:async';

import 'package:flutter/services.dart';

class FacebookLoginKit {
  static const MethodChannel _channel = const MethodChannel('FacebookLoginKit');

  static Future<Map<String, Object>> loginWithReadPermissions(List<String> permissions) {
    return _channel.invokeMethod('loginWithReadPermissions', <String, List<String>> {
      "permissions": permissions
    });
  }

  static Future<Map<String, Object>> logInWithPublishPermissions(List<String> permissions) {
    return _channel.invokeMethod('logInWithPublishPermissions', <String, List<String>> {
      "permissions": permissions
    });
  }
}
