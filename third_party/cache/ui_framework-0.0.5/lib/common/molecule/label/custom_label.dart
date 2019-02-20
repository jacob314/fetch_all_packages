import 'package:flutter/material.dart';
import 'package:ui_framework/common/molecule/font/font_styles.dart';

class CustomLabel extends StatelessWidget {
  final String text;


  CustomLabel({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: FontStyles.mainFont,
    );
  }
}
