import 'dart:async';

import 'package:flutter/services.dart';

class MediaRefresh {
  static const MethodChannel _channel = const MethodChannel('media_refresh');

  static Future<bool> scanFile(String url) async {
    final bool success = await _channel.invokeMethod('scanFile', url);
    return success;
  }
}
