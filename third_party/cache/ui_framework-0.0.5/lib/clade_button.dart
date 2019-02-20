import 'package:flutter/material.dart';
import 'package:ui_framework/android/atomic/android_button.dart';
import 'package:ui_framework/ios/atomic/ios_button.dart';
import 'dart:io' show Platform;

class CladeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return checkButton();
  }

  Widget checkButton() {
    if (Platform.isAndroid) {
      return AndroidButton(
        text: "Android",
        onTap: () {},
      );
    } else if (Platform.isIOS) {
      return IOSButton(
        text: "iOS",
        onTap: () {},
      );
    }
    return Container(child: Text("Test"),);
  }
}
