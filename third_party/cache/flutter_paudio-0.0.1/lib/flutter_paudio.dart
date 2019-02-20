import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FlutterPaudio {
  static const MethodChannel _channel =
      const MethodChannel('flutter_paudio');

  static Future<double> play(Uint8List bytes) async {
    final double duration = await _channel.invokeMethod('playAudio', bytes);
    return duration;
  }
  static Future stop() async {
    return _channel.invokeMethod('stopAudio');
  }
}
