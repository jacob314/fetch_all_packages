import 'dart:async';

import 'package:flutter/services.dart';

class FlutterHqRecorder {
  static const MethodChannel _channel =
      const MethodChannel('flutter_hq_recorder');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Null> startRecording() async {
    try {
      await _channel.invokeMethod('startRecording');
    } on PlatformException catch (e) {
      print('PLATFORM EXCEPTION: ' + e.message);
    }
  }

  static Future<Null> stopRecording() async {
    await _channel.invokeMethod('stopRecording');
    print('We stopped!');
  }

  static Future<Null> initializeRecorder(String fileLoc) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'outputFile': fileLoc
    };

    await _channel.invokeMethod('initializeRecorder', params);
  }

  static Future<Null> playRecording() async {
    await _channel.invokeMethod('playRecording');
  }
}
