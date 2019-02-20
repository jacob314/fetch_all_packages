import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Nav {
  static Future open(BuildContext context, dynamic screen) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static void close(BuildContext context) {
    Navigator.pop(context);
  }
}
