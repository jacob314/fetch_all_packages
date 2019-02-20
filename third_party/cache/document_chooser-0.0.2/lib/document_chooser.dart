import 'dart:async';

import 'package:flutter/services.dart';

class DocumentChooser {
  static const MethodChannel _channel =
      const MethodChannel('document_chooser');

  /*static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }*/

  static Future<String>  chooseDocument() async {
    final String path = await _channel.invokeMethod('chooseDocument');
    return path;
  }

  static Future<List<String> >  chooseDocuments() async {
    final List<String> paths = await _channel.invokeMethod('chooseDocuments');
    return paths;
  }
}
