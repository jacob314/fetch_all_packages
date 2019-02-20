import 'dart:async';

import 'package:flutter/services.dart';

class PrivatebinReader {
  static const MethodChannel _channel =
      const MethodChannel('privatebin_reader');

  static Future<String>  decrypt(String data, String pw) async {
    final Map<String, dynamic> params = <String, dynamic> {
      'data': data,
      'pw': pw,
    };
    final String decrypted = await _channel.invokeMethod('decrypt',params);
    return decrypted;
  }


  static Future<String>  decompress(String data) async {
    final Map<String, dynamic> params = <String, dynamic> {
      'data': data,
    };
    final String decompressed = await _channel.invokeMethod('decompress',params);
    return decompressed;
  }
}
