import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tt_image/tt_image_provider.dart';

class TTImage extends Image {
  static const MethodChannel _channel = const MethodChannel('tt_image');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  TTImage.network(url, {
    List<String> urlList,
    Key key,
    scale: 1.0,
    double width,
    double height,
    Color color,
    BlendMode colorBlendMode,
    BoxFit fit,
    alignment: Alignment.center,
    repeat: ImageRepeat.noRepeat,
    Rect centerSlice,
    matchTextDirection: false,
    gaplessPlayback: false,
  }) : super(
      image: new TTImageProvider(url, _channel, urlList: urlList),
      key: key,
      width: width,
    height: height,
    color: color,
    colorBlendMode: colorBlendMode,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
    centerSlice: centerSlice,
    matchTextDirection: matchTextDirection,
    gaplessPlayback: gaplessPlayback,
  );
}
