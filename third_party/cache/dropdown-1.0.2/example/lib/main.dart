import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:dropdown/dropdown.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Dropdown.show("Hello world!", Colors.green, Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Text(""),
    );
  }
}
