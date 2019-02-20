import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum ImageSource {
  /// Opens up the device camera, letting the user to take a new picture.
  camera,

  /// Opens the user's photo gallery.
  gallery,
}

class FbSharePlugin {
  static const MethodChannel _channel =
      const MethodChannel('com.sheikhsoft.share_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> shareContent(String url) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'videoUrl': url,
    };
    await _channel.invokeMethod('shareContent',params);

  }

  static Future<void> shareVideo(String videoPath) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'videoPath': videoPath,
    };
    await _channel.invokeMethod('shareVideo',params);

  }

  static Future<void> shareImageFb(String videoPath) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'imagePath': videoPath,
    };
    await _channel.invokeMethod('shareImageFb',params);

  }
  static Future<void> shareImageMessenger(String videoPath) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'imagePath': videoPath,
    };
    await _channel.invokeMethod('shareImageMessenger',params);

  }



  static Future<void> shareVideoWhatsApp(String videoPath) async {
    final Map<String, dynamic> param = <String, dynamic>{
      'videoPath': videoPath,
    };
    await _channel.invokeMethod('shareVideoWhatsApp',param);

  }

  static Future<void> shareVideoMessenger(String videoPath) async {
    final Map<String, dynamic> param = <String, dynamic>{
      'videoPath': videoPath,
    };
    await _channel.invokeMethod('shareVideoMessenger',param);

  }

  static Future<void> shareVideoTwitter(String videoPath) async {
    final Map<String, dynamic> param = <String, dynamic>{
      'videoPath': videoPath,
    };
    await _channel.invokeMethod('shareVideoTwitter',param);

  }

  static Future<File> pickImage({
    @required ImageSource source,
    double maxWidth,
    double maxHeight,
  }) async {
    assert(source != null);

    if (maxWidth != null && maxWidth < 0) {
      throw new ArgumentError.value(maxWidth, 'maxWidth can\'t be negative');
    }

    if (maxHeight != null && maxHeight < 0) {
      throw new ArgumentError.value(maxHeight, 'maxHeight can\'t be negative');
    }

    final String path = await _channel.invokeMethod(
      'pickImage',
      <String, dynamic>{
        'source': source.index,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
      },
    );
    return path != null ? new File(path) : null;
  }

  static Future<File> pickVideo({
    @required ImageSource source,
    double maxWidth,
    double maxHeight,
  }) async {
    assert(source != null);

    if (maxWidth != null && maxWidth < 0) {
      throw new ArgumentError.value(maxWidth, 'maxWidth can\'t be negative');
    }

    if (maxHeight != null && maxHeight < 0) {
      throw new ArgumentError.value(maxHeight, 'maxHeight can\'t be negative');
    }

    final String path = await _channel.invokeMethod(
      'pickVideo',
      <String, dynamic>{
        'source': source.index,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
      },
    );
    return path != null ? new File(path) : null;
  }




}
