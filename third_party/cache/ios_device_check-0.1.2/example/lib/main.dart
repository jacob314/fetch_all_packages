import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ios_device_check/ios_device_check.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = 'Unknown';

  @override
  void initState() {
    super.initState();
    _generateToken();
  }

  Future<void> _generateToken() async {
    String result;

    try {
      result = await IosDeviceCheck.generateToken();
    } on PlatformException catch (e) {
      result = 'Code: ${e.code}\nMessage: ${e.message}\nDetails: ${e.details}';
    }

    if (!mounted) return;

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new SingleChildScrollView(
          child: new Text(_result),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: _generateToken,
          child: new Icon(Icons.refresh),
        ),
      ),
    );
  }
}
