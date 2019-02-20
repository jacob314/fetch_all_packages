import 'dart:async';
import 'package:flutter/services.dart';

enum AlertType {
  NORMAL,
  ERROR,
  SUCCESS,
  WARNING,
  CUSTOM_IMAGE_TYPE,
  PROGRESS,
}

class SweetAlert {
  static const MethodChannel _channel = const MethodChannel('flutter_sweet_alert');

  static Future<bool> dialog(
      {AlertType type = AlertType.NORMAL,
      String title,
      String content,
      String confirmButtonText = "确定",
      bool showCancel = false,
      String cancelButtonText = "取消",
      bool cancelable = false,
      int autoClose = 0,
      bool closeOnConfirm = true,
      bool closeOnCancel = true}) async {
    Map<String, dynamic> args = <String, dynamic>{
      "type": type.index,
      "title": title,
      "content": content,
      "confirmButtonText": confirmButtonText,
      "showCancelButton": showCancel,
      "cancelButtonText": cancelButtonText,
      "cancelable": cancelable,
      "autoClose": autoClose,
      "closeOnConfirm": closeOnConfirm,
      "closeOnCancel": closeOnCancel
    };
    final bool result = await _channel.invokeMethod('showDialog', args);
    return result;
  }

  static Future<bool> update({
    AlertType type = AlertType.NORMAL,
    String title,
    String content,
    String confirmButtonText = "确定",
    bool showCancel = false,
    String cancelButtonText = "取消",
    bool cancelable = false,
    int autoClose = 0,
    bool closeOnConfirm = true,
    bool closeOnCancel = true,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{
      "type": type.index,
      "title": title,
      "content": content,
      "confirmButtonText": confirmButtonText,
      "showCancelButton": showCancel,
      "cancelButtonText": cancelButtonText,
      "cancelable": cancelable,
      "autoClose": autoClose,
      "closeOnConfirm": closeOnConfirm,
      "closeOnCancel": closeOnCancel
    };
    final bool result = await _channel.invokeMethod('updateDialog', args);
    return result;
  }

  static Future<bool> loading({
    cancelable = false,
    title,
    content,
  }) async {
    final bool result = await dialog(type: AlertType.PROGRESS, cancelable: cancelable, title: title, content: content);
    return result;
  }

  static close({closeWithAnimation = true}) {
    _channel.invokeMethod('close', {"closeWithAnimation": closeWithAnimation});
  }
}
