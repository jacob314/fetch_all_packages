import 'dart:async';

import 'package:flutter/services.dart';

class NativeBrige {
  static const MethodChannel _channel =
      const MethodChannel('native_brige');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> saveValueToNativeDict(Map<String,Object> map,String namespace) async{
    return await _channel.invokeMethod('saveValueToNativeDict',[map,namespace]);
  }
  
  static Future<dynamic> getValueFromNativeDict(String namespace) async{
    return await _channel.invokeMethod('getValueFromNativeDict',[namespace]);
  }
}
