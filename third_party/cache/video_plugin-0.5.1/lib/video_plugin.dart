import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class VideoCreator {
  static const MethodChannel _channel =
      const MethodChannel('video_creator');

  static Future<String> video({Int32List original, Int32List palette,String historyPath, int width, int height,int secondsPaint, int secondsShow}) async {



    dynamic params = {
      "original": original,
      "palette": palette,
      "history": historyPath,
      "width": width,
      "height": height,
      "secondsPaint": secondsPaint,
      "secondsShow": secondsShow,
    };
    //   VideoPlugin.video(params).then((val)=>print);
    /*
    await VideoPlugin.video(params);
    */

    final String version = await _channel.invokeMethod("makeVideo", params);
    return version;
  }

  static Future<String> share({String path}) async {

    print("going to share");
    dynamic params = {
      "path": path,
    };
    //   VideoPlugin.video(params).then((val)=>print);
    /*
    await VideoPlugin.video(params);
    */

    final String version = await _channel.invokeMethod("shareInsta", params);
    return version;
  }


}
