import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/styles/colors.dart';

ThemeData BottomMenuItemTheme(BuildContext context) {
  return Theme.of(context).copyWith(
    backgroundColor: kColorWhiteGray,
    highlightColor: kColorPrimary,
    iconTheme: IconThemeData(
        color: kColorGrayDark
    ),
    textTheme: TextTheme(
      body1: TextStyle(
        color: kColorWhite,
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
      ),

    ),
  );
}