import 'dart:ui';

import 'package:flutter/services.dart';

class StatusBar {
  static const MethodChannel _channel =
  const MethodChannel('statusbar');

  static void color(Color color)
  {
    String r = "${color.red.toRadixString(16)}".padLeft(2, "0");
    String g = "${color.green.toRadixString(16)}".padLeft(2, "0");
    String b = "${color.blue.toRadixString(16)}".padLeft(2, "0");
    String hex = "#$r$g$b";
    if(hex == null || hex.length == 0)
    {
      _channel.invokeMethod('hide');
    }
    else
    {
      _channel.invokeMethod('color', {'hex':hex});
      _channel.invokeMethod('show');
    }
  }
}
