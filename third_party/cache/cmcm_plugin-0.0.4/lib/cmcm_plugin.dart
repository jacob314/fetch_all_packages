import 'dart:async';

import 'package:flutter/services.dart';

class CmcmPlugin {
  static const MethodChannel _channel =
      const MethodChannel('cmcm_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> init(String pageId, String gameId, String gameName) async {
    bool result = false;
    var params = <String, dynamic>{
      'pageId': pageId,
      'gameId': gameId,
      'gameName': gameName,
    };

    try {
      result = await _channel.invokeMethod('init', params);
    } on PlatformException catch (e) {
      throw 'Unable to init: ${e.message}';
    }
    return result;
  }
}
