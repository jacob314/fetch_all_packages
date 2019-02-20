import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/styles/theme.dart';

class EmptyFieldTextSpan extends TextSpan{
  @override
  final String text;

  EmptyFieldTextSpan({this.text}):super(text: text, style: TextStyle(
      color: buildAppTheme().hintColor,
      fontStyle: FontStyle.italic
  ));
}
