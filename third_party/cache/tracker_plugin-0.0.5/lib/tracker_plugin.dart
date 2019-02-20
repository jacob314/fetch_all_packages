import 'dart:async';

import 'package:flutter/services.dart';

class TrackerPlugin {
  static const MethodChannel _channel =
      const MethodChannel('plugins.servicewall.cn/tracker');

  static Future<bool> initSWSdk(String uniqueId, [String channel]) async {
    _channel.setMethodCallHandler(handler);
    return await _channel.invokeMethod(
        'initSWSdk', {'unique_id': '$uniqueId', 'channel': channel});
  }

  static StreamController<Map> _sdkStreamController =
      new StreamController.broadcast();

  static Stream<Map> get stream => _sdkStreamController.stream;

  static Future<dynamic> handler(MethodCall call) {
    String method = call.method;
    switch (method) {
      case "device_info":
        {
          _sdkStreamController.add(call.arguments);
        }
        break;
    }
    return new Future.value("");
  }
}
