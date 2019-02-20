import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWebview {
  static const MethodChannel _channel = const MethodChannel('flutter_webview');

  static Future<String> launch(String url) {
    Map<String, String> args = {
      "url": url
    };
    return _channel.invokeMethod('launch', args);
  }
}
