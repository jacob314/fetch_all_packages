import 'dart:async';

import 'package:flutter/services.dart';

class ClipboardPlugin {
  static const MethodChannel _channel =
      const MethodChannel('clipboard_plugin');

  static Future<bool> copyToClipBoard(String text) async {
    final bool result = await _channel.invokeMethod('copyToClipBoard',
        <String,String>{
          'text':text
        });
    return result;
  }
}
