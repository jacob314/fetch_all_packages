import 'dart:async';
import 'package:flutter/services.dart';

class Futils {
  static const MethodChannel _methodChannel =
      const MethodChannel('futils_method');
  static const BasicMessageChannel<String> _messageChannel =
      const BasicMessageChannel('futils_message', StringCodec());

  // global MethodChannel
  static get methodChannel => _methodChannel;
  // global BasicMessageChannel
  static get messageChannel => _messageChannel;

  // get platform version
  static Future<String> get platformVersion async {
    final String version = await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }
}
