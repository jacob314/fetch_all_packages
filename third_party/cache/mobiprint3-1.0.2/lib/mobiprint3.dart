import 'dart:async';

import 'package:flutter/services.dart';

class Mobiprint3 {
  //@ Initialize the method caller
  static const MethodChannel _channel = const MethodChannel('mobiprint3');

  //! Handle basic printing
  static Future<Map<String, dynamic>> print(String text) async {
    try {
      final String result =
          await _channel.invokeMethod('print', {"data": text});
      return {"success": (result == "1"), "message": result};
    } on PlatformException catch (e) {
      return {"success": false, "messge": e.message};
    }
  }

  //! Handle image printing
  static Future<Map<String, dynamic>> image(String text) async {
    try {
      final String result =
          await _channel.invokeMethod('image', {"data": text});
      return {"success": (result == "1"), "message": result};
    } on PlatformException catch (e) {
      return {"success": false, "messge": e.message};
    }
  }

  //! Handle printing with custom sizing
  static Future<Map<String, dynamic>> custom(String text, int size) async {
    try {
      final String result =
          await _channel.invokeMethod('custom', {"data": text, 'size': size});
      return {"success": (result == "1"), "message": result};
    } on PlatformException catch (e) {
      return {"success": false, "messge": e.message};
    }
  }

  //! Test the function of the plugin
  static Future<Map<String, dynamic>> test() async {
    try {
      final String result = await _channel.invokeMethod('test');
      return {"success": (result == "1"), "message": result};
    } on PlatformException catch (e) {
      return {"success": false, "messge": e.message};
    }
  }

  //! Print a blank line
  static Future<Map<String, dynamic>> space() async {
    try {
      final String result = await _channel.invokeMethod('space');
      return {"success": (result == "1"), "message": result};
    } on PlatformException catch (e) {
      return {"success": false, "messge": e.message};
    }
  }

  //! Check if paper is loaded on the device [also works to check if device can print]
  static Future<Map<String, dynamic>> paper() async {
    try {
      final String result = await _channel.invokeMethod('paper');
      return {"success": (result == "1"), "message": result};
    } on PlatformException catch (e) {
      return {"success": false, "messge": e.message};
    }
  }

  //! Print a trailing space [for easy paper tears on completion]
  static Future<Map<String, dynamic>> end() async {
    try {
      final String result = await _channel.invokeMethod('end');
      return {"success": (result == "1"), "message": result};
    } on PlatformException catch (e) {
      return {"success": false, "messge": e.message};
    }
  }
}
