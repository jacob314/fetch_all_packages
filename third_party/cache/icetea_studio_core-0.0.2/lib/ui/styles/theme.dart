import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/styles/colors.dart';

/// Build the App-wide theme
ThemeData buildAppTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
      platform: defaultTargetPlatform == TargetPlatform.iOS ? TargetPlatform.iOS : TargetPlatform.android,
      accentColor: kColorOrangeDark,
      accentColorBrightness: Brightness.dark,
      scaffoldBackgroundColor: kColorWhite,
      backgroundColor: kColorWhite,
      primaryColor: kColorPrimary,
      primaryColorDark: kColorPrimaryDark,
      primaryColorLight: kColorPrimaryLight,
      errorColor: kColorRed,
      toggleableActiveColor: kColorOrangeDark,
      disabledColor: kColorGrayLight,
      unselectedWidgetColor: kColorGray,
      highlightColor: kColorTransparent,    // WHY?
      bottomAppBarColor: kColorWhite,
      hintColor: kColorGray,
      splashColor: kColorGrayBareA1,
      cardColor: kColorWhite,
      canvasColor: kColorWhite,
      dividerColor: kColorGrayLight,
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kColorPrimary, width: 2.0),
              borderRadius: BorderRadius.circular(2.0)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kColorGray),
              borderRadius: BorderRadius.circular(2.0)
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kColorRed, width: 2.0),
              borderRadius: BorderRadius.circular(2.0)
          ),
      ),
      iconTheme: IconThemeData(
        color: kColorOrangeDark
      ),
      accentIconTheme: IconThemeData(
        color: kColorWhite
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
      textTheme: TextTheme(
          body1: TextStyle(
              color: kColorBlack
          ),
          body2: TextStyle(
              color: kColorGray
          ),
          subhead: TextStyle(
              color: kColorGrayDark
          ),
          title: TextStyle(
              color: kColorGrayDark
          )
      ),
      chipTheme: ChipThemeData(
          backgroundColor: kColorGrayBare,
          disabledColor: kColorGrayLighter,
          selectedColor: kColorGrayDark,
          secondarySelectedColor: kColorOrangeDark,
          labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
          padding: EdgeInsets.all(0.0),
          shape: StadiumBorder() ,
          labelStyle: TextStyle(
              color: kColorGrayDark
          ),
          secondaryLabelStyle: TextStyle(
              color: kColorGrayDark
          ),
          brightness: Brightness.dark
      ),


      // Text
      // textSelectionColor → Color
      // textSelectionHandleColor → Color
      // textTheme → TextTheme
  );
}



