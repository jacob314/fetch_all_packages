import 'package:flutter/material.dart';

class Utils {
  static Widget waiting() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 64.0,
          height: 64.0,
          child: CircularProgressIndicator(),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text('This may take a few seconds...'),
      ],
    ));
  }

  static Widget empty() {
    return Center(
      child: Text('No results were found.'),
    );
  }
}
