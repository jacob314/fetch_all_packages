import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview/flutter_webview.dart';

const LAUNCH_BUTTON = const Key('launch-button');

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Webview example app'),
        ),
        body: new Center(
          child: new FlatButton(
            key: LAUNCH_BUTTON,
            child: new Text('Launch google'),
            onPressed: () async {
              String url = 'https://www.google.com';
              String result = await FlutterWebview.launch(url);
              print(result);
            },
          ),
        ),
      ),
    );
  }
}
