import 'package:flutter/material.dart';
import 'package:statusbar/statusbar.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    StatusBar.color(Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Text(""),
    );
  }
}
