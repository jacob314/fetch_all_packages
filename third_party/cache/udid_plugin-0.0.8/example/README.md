# udid_plugin_example

## 使用
```
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:udid_plugin/udid_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _uuidPlugin = UdidPlugin();
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = _uuidPlugin.errorStream.listen((errorResult) {
      print(errorResult.retMsg);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _uuidPlugin.dispose();
    super.dispose();
  }

  Future<Null> startLivenessFlow() async {
    LivenessResult result = await _uuidPlugin.startLivenessFlow({"engineArg": ""});
    print(result.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
          children: <Widget>[
            new RaisedButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                _uuidPlugin.startOCRFlow({"": ""});
              },
              child: Center(
                // height: 44,
                child: Text("OCR"),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            new RaisedButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                startLivenessFlow();
              },
              child: Center(
                // height: 44,
                child: Text("活体检测"),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            new RaisedButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                _uuidPlugin.startIDAuthFlow({"engineArg": ""});
              },
              child: Center(
                // height: 44,
                child: Text("身份认证"),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            new RaisedButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                _uuidPlugin.startCompareFlow({"engineArg": ""});
              },
              child: Center(
                // height: 44,
                child: Text("人脸比对"),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            new RaisedButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                _uuidPlugin.startVideoFlow({"engineArg": ""});
              },
              child: Center(
                // height: 44,
                child: Text("视频存证"),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            new RaisedButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                _uuidPlugin.startCustomFlow({"engineArg": ""});
              },
              child: Center(
                // height: 44,
                child: Text("组合流程（身份认证+活体+比对）"),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            new RaisedButton(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {},
              child: Center(
                // height: 44,
                child: Text("拍照"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
