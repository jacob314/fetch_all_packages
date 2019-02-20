import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/styles/colors.dart';

/// Used by screens that uses the App Theme's primaryColor as the background
///
/// Includes a blue background, white-bordered input fields, white text, and yellow highlight color
ThemeData buildPrimaryTheme(BuildContext context) {
  return Theme.of(context).copyWith(
      scaffoldBackgroundColor: kColorPrimary,
      hintColor: kColorWhite,
      textSelectionColor: kColorWhite,
      errorColor: kColorYellow,
      textTheme: Theme.of(context).textTheme.apply(
        bodyColor: kColorWhite,
        displayColor: kColorWhite,
      ),
      highlightColor: kColorGrayBare,
      splashColor: kColorWhite,
      primaryColor: kColorWhite,
      inputDecorationTheme: InputDecorationTheme(
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kColorYellow),
            borderRadius: BorderRadius.circular(2.0)
        ),
        helperStyle: TextStyle(color: kColorWhite)
      ),
      accentTextTheme: TextTheme(
        button: TextStyle(
          color: kColorWhite
        ),
        title: TextStyle(
          color: kColorWhite
        ),
        body1: TextStyle(
          color: kColorWhite
        )
      ),
      accentIconTheme: IconThemeData(
        color: kColorWhite
      ),
      accentColor: kColorYellow,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
      ),
      buttonColor: kColorWhite,
      iconTheme: IconThemeData(
        color: kColorOrange
      ),
      primaryIconTheme: IconThemeData(
        color: kColorWhite
      ),
      toggleableActiveColor: kColorWhite,
  );
}