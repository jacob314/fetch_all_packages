import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/services.dart';

class FlutterPluginZero {
  static const MethodChannel _channel = MethodChannel('flutter_plugin_zero');

  static showToast (int msg, int msg1) async {
    Map<String, dynamic> map=<String, dynamic>{};
    map.putIfAbsent("msg", ()=>msg);
    map.putIfAbsent("msg1", ()=>msg1);
    await _channel.invokeMethod("showToast", map);
    //await _channel.invokeMethod("showToast", {"msg": msg});
  }

  static openCamera(){
    _channel.invokeMethod(("openCamera"));

  }

  static deviceConnect(){
    _channel.invokeMethod("deviceConnect");
  }
}
