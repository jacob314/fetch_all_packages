import 'package:flutter/material.dart';

class DialogUtils {
  static void showCustomDialog<T>({ BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        Navigator.pop(context, value);
      }
    });
  }
}
