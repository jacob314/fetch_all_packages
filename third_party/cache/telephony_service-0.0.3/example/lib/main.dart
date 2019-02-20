import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:telephony_service/telephony_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _simSN = 'Unknown';
  String _imei = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String simSN, imei;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      simSN = await TelephonyService.simSerialNumber;
    } on PlatformException {
      simSN = 'Failed to get simSN';
    }

    try {
      imei = await TelephonyService.imei;
    } on PlatformException {
      imei = 'Failed to get imei';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _simSN = simSN;
      _imei = imei;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Sim SN: $_simSN\n'),
              Text('IMEI: $_imei\n'),
            ],
          ),
        ),
      ),
    );
  }
}
