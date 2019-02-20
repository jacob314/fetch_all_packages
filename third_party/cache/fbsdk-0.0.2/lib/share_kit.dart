import 'dart:async';

import 'package:flutter/services.dart';

class FacebookShareKit {
  static const MethodChannel _channel = const MethodChannel('FacebookShareKit');

  static Future<Map<String, Object>> shareLinkWithShareDialog(Map<String, Object> content) {
    return _channel.invokeMethod('shareLinkWithShareDialog', <String, Object> {
      "content": content
    });
  }
}
