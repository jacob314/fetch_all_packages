import 'package:flutter/material.dart';

class ExLoading {
  static tetrisLoading() {
    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            height: 1000.0,
            color: Colors.white,
            child: Image.asset("assets/images/loading-tetris.gif"),
          ),
        ),
      ),
    );
  }
}
