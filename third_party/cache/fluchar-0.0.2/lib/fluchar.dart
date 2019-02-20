import 'dart:async';

import 'package:flutter/services.dart';

class Fluchar {
  static const MethodChannel _channel = const MethodChannel('fluchar');

  static Future<String> char(String str) async {
    return await _channel.invokeMethod('char', {'str': str});
  }
}
