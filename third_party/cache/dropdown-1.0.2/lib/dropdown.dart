import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class Dropdown
{
  static const MethodChannel _channel =
      const MethodChannel('dropdown');

  static void show(String message, Color background, Color foreground)
  {
    if(message != null && message.length > 0)
    {
      String bg = (background != null ? _hex(background) : "#ff0000");
      String fg = (foreground != null ? _hex(foreground) : "#ffffff");

      _channel.invokeMethod(
          "show", {"message": message, "foreground": fg, "background": bg});
    }
  }

  static String _hex(Color color)
  {
    if(color != null)
    {
      String r = "${color.red.toRadixString(16)}".padLeft(2, "0");
      String g = "${color.green.toRadixString(16)}".padLeft(2, "0");
      String b = "${color.blue.toRadixString(16)}".padLeft(2, "0");
      return "#$r$g$b";
    }
    return null;
  }
}
