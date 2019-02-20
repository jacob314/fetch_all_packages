import 'dart:async';

import 'package:flutter/services.dart';

class LibWallpaper {
  static const MethodChannel _channel = const MethodChannel('lib_wallpaper');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> setWallpaper(String filePath) async {
    return _channel.invokeMethod("setWallpaper",{"filePath":filePath});
  }
}
