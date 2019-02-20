import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class _NativeAlertDialogPlugin {
  static const MethodChannel channel =
      const MethodChannel('native_alert_dialog_plugin');
}

Future<bool> showNativeDialog({
  String title,
  String body,
  String positiveButtonText,
  String negativeButtonText,
  Color buttonColor,
}) async {
  Map<String, dynamic> data = {
    'title': title,
    'body': body,
    'positiveButtonText': positiveButtonText = 'OK',
    'negativeButtonText': negativeButtonText = 'CANCEL',
  };

  if (buttonColor != null) {
    data['buttonColor'] = {
      'red': buttonColor.red,
      'green': buttonColor.green,
      'blue': buttonColor.blue,
      'alpha': buttonColor.alpha,
    };
  }

  return await _NativeAlertDialogPlugin.channel
      .invokeMethod('showNativeDialog', data);
}
