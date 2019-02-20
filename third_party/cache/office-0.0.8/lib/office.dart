import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class Office {
  static const MethodChannel _channel = const MethodChannel('plugins.ly.com/office');

  static Future<T> createWorkbook<T>(String path) async {
    final Map<String, dynamic> params = {
      'path': path,
    };
    return _channel.invokeMethod('createWorkbook', params);
  }

  static Future<T> createSheet<T>(String n, int w) async {
    final Map<String, dynamic> params = {
      'name': n,
      'which': w,
    };
    return _channel.invokeMethod('createSheet', params);
  }

  static Future<T> addCell<T>(int c, int r, String cont) async {
    final Map<String, dynamic> params = {
      'column': c,
      'row': r,
      'content': cont,
    };
    return _channel.invokeMethod('addCell', params);
  }

  static Future<T> setColumnView<T>(int c, int w) async {
    final Map<String, dynamic> params = {
      'column': c,
      'width': w,
    };
    return _channel.invokeMethod('setColumnView', params);
  }

  static Future<T> write<T>() async {
    return _channel.invokeMethod('write');
  }

  static Future<T> close<T>() async {
    return _channel.invokeMethod('close');
  }
}
