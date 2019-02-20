import 'dart:async';

import 'package:flutter/services.dart';

class PhotoProvider {
  // static final PhotoManager _instance = new PhotoManager.internal();
  // factory PhotoManager() => _instance;
  // PhotoManager.internal();

  static const MethodChannel _channel =
      const MethodChannel('top.sp0cket.photo_provider');

  static Future<void> init() async => await _channel.invokeMethod('init');
  static Future<int> getImagesCount() async => await _channel.invokeMethod('imagesCount');
  static Future<bool> hasPermission() async => await _channel.invokeMethod('hasPermission');
  static Future<List<int>> getImage(int index,
          {int width, int height, int compress}) async =>
      await _channel.invokeMethod('getImage', <String, dynamic>{
        "index": index,
        "width": width,
        "height": height,
        "compress": compress,
      });
}
