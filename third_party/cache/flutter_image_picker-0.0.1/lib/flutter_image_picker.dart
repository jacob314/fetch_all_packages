import 'dart:async';

import 'package:flutter/services.dart';

class FlutterImagePicker {
  static const MethodChannel _channel =
      const MethodChannel('flutter_image_picker');

  static Future<List> get albumEntries async {
    final List entries = await _channel.invokeMethod('getAlbumEntries');
    return entries;
  }
  static Future<String> get anyPicturePath async{
    final String picPath = await _channel.invokeMethod('getAnyPicturePath');
    return picPath;
  }
}
