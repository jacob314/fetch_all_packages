import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class SaltedfishGalleryInserter {
  static const MethodChannel _channel =
      const MethodChannel('saltedfish_gallery_inserter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> insertFileToGallery(File file) async{
//    (file.readAsBytes() as Uint8List).buffer
    Uint8List uint8list = Uint8List.fromList(await file.readAsBytes());
   return _channel.invokeMethod('insertToGallery',uint8list);
  }
  static Future<dynamic>  insertImageToGallery(ui.Image file) async{
    ByteData byteData = await file.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
   return _channel.invokeMethod('insertToGallery',pngBytes);
  }

}
