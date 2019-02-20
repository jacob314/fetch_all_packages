import 'dart:async';

import 'package:flutter/services.dart';

class CompressImage {
  static const MethodChannel _channel =
      const MethodChannel('compressimage');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> compress({String imageSrc, int desiredQuality}) async {
    final Map<String, dynamic> params = <String, dynamic> {
      'filePath': imageSrc,
      'desiredQuality': desiredQuality
    };
    final String filePath = await _channel.invokeMethod('compressImage', params);
    return filePath;
  }

  //0.1.1

}
