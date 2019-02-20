import 'package:flutter/material.dart';

class Styles {

  static final Styles _singleton = new Styles._internal();
  factory Styles() {
    return _singleton;
  }
  Styles._internal();

  TextStyle styleGrey() {
    return new TextStyle(
      color: Colors.grey[500],
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 20.0,
      height: 2.0,
    );
  }

  TextStyle styleBlueAccent() {
    return new TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent,
    );
  }

  TextStyle styleBlueAccent18() {
    return new TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 18.0,
      height: 2.0,
    );
  }

  TextStyle styleBlack() {
    return new TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 18.0,
      height: 2.0,
    );
  }

  TextStyle styleBlack16() {
    return new TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 16.0,
      height: 2.0,
    );
  }

  TextStyle styleRedAccentFont16() {
    return new TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      color: Colors.redAccent,
    );
  }

  TextStyle styleRedAccentFont18() {
    return new TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      color: Colors.redAccent,
    );
  }

  TextStyle styleBlackFont20() {
    return new TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 20.0,
    );
  }
}
