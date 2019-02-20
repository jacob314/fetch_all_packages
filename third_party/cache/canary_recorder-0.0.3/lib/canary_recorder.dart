import 'dart:async';

import 'package:flutter/services.dart';

class CanaryRecorder {
  static const MethodChannel _channel = const MethodChannel('canary_recorder');

  static Future<String> initializeRecorder(String fileLoc) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'outputFile': fileLoc
    };

    final absPath = await _channel.invokeMethod('initializeRecorder', params);
    return absPath;
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

  static Future<Null> playRecording() async {
    await _channel.invokeMethod('playRecording');
  }
}
