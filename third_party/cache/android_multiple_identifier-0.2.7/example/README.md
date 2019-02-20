```dart
import 'package:flutter/material.dart';
import 'package:android_multiple_identifier/android_multiple_identifier.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _imei = 'Unknown';
  String _serial = 'Unknown';
  String _androidID = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String imei;
    String serial;
    String androidID;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AndroidMultipleIdentifier.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    await AndroidMultipleIdentifier.requestPermission();

    try {
      imei = await AndroidMultipleIdentifier.imeiCode;
      serial = await AndroidMultipleIdentifier.serialCode;
      androidID = await AndroidMultipleIdentifier.androidID;
    } catch (e) {
      imei = 'Failed to get IMEI.';
      serial = 'Failed to get Serial Code.';
      androidID = 'Failed to get Android id.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _imei = imei;
      _serial = serial;
      _androidID = androidID;
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '\nRunning on: $_platformVersion\n',
              textAlign: TextAlign.center,
            ),
            Text('IMEI: $_imei\n'),
            Text(
              'Serial Code: $_serial\n',
              textAlign: TextAlign.center,
            ),
            Text(
              'Android ID: $_androidID\n',
              textAlign: TextAlign.center,
            ),
          ],
        )),
      ),
    );
  }
}
```
