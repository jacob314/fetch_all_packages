import 'dart:async';
import 'package:flutter/services.dart';

class EpubReader {
  static const MethodChannel _channel = const MethodChannel('epub_reader');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get searchAsset async {
    final String asset_path = await _channel.invokeMethod('onSearchAsset');
    return asset_path;
  }
}
