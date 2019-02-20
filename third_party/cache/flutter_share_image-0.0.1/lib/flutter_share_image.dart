/// A new Flutter plugin to easily share image from your flutter app.
/// Compatible in Android & iOS both.

import 'dart:async';
import 'package:flutter/services.dart';

class FlutterShareImage {
  static const MethodChannel _channel = const MethodChannel('flutter_share_image');

  static Future<bool> share({String title, String imagePath}) async {
    final bool success = await _channel.invokeMethod('shareImage', <String, dynamic>{
      'title': title,
      'fileUrl': imagePath,
    });
    return success;
  }
}
