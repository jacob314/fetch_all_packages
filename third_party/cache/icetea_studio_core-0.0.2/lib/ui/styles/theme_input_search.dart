import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/styles/colors.dart';

/// Provides the background and other theme properties for a section within a screen
///
///
ThemeData buildSearchInputTheme(BuildContext context) {
  return Theme.of(context).copyWith(
    backgroundColor: kColorGrayLight,
    iconTheme: IconThemeData(
        color: kColorGrayDark
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: new EdgeInsets.all(0.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(0.0),
        gapPadding: 0.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(0.0),
        gapPadding: 0.0,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(0.0),
        gapPadding: 0.0,
      ),
    ),
    textTheme: TextTheme(
      title: TextStyle(
        fontSize: 14.0,
        color: kColorBlack
      )
    )

  );
}