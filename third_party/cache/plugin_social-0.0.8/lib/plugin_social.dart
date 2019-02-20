import 'dart:async';
import 'package:flutter/services.dart';

class PluginSocial {
  static const MethodChannel _channel = const MethodChannel('plugin_social');

  PluginSocial() {
    _channel.setMethodCallHandler((MethodCall call) {
      switch (call.method) {
        case "didFinishLoggedIn":
          print(call.arguments);
          break;
        default:
      }
    });
  }

  Future<Null> signInWithSMS() async {
    try {
      await _channel.invokeMethod('SignInWithSMS');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<Null> signInWithEmail() async {
    try {
      await _channel.invokeMethod('SignInWithEmail');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<dynamic> didFinishLoggedIn() async {
    _channel.setMethodCallHandler((MethodCall call) {
      print(call);
      if (call.method == 'didFinishLoggedIn') {
        print(call.arguments);
        return call.arguments;
      } else {
        return null;
      }
    });
  }
}
