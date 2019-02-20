import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:media_metadata_plugin/image_color.dart';
import 'package:media_metadata_plugin/media_media_data.dart';

class MediaMetadataPlugin {
  static const MethodChannel _channel =
      const MethodChannel('media_metadata_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<AudioMetaData> getMediaMetaData(String filePath) async {
    final dynamic data = await _channel.invokeMethod('getMediaMetadata', {"filePath": filePath});
    Map metaData = jsonDecode(data);
    AudioMetaData audioMetaData = AudioMetaData.fromJson(metaData);
    return audioMetaData;
  }

  static Future<ImageColor> getImageColors(String filePath) async {
    final String metaData = await _channel.invokeMethod('getImageColors', {"filePath": filePath});
    Map colorJson = jsonDecode(metaData);
    ImageColor imageColors = ImageColor.fromJson(colorJson);
    return imageColors;
  }
}
