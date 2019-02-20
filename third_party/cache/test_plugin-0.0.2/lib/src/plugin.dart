import 'dart:async';

import 'package:flutter/services.dart';

class TestPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutterplugins.markhamenterprises.com/test_plugin');

  static Future<String> kickBackValue([String _msg = "default"]) async {
    final String kickBackReturn =
        await _channel.invokeMethod('kickBack', {'kick': _msg});
    return kickBackReturn;
  }
}
