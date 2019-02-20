import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/services.dart';
import 'package:flutter_plugin_zero/flutter_plugin_zero.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await FlutterPluginZero.showToast(54, 6);

      //await FlutterToast.sum("15", "5");
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new Text('Running on: $_platformVersion\n'),
              new RaisedButton(
                  child: new Text("Toast"),
                  onPressed: (){
                    FlutterPluginZero.showToast(6, 5);
                  }),
              new RaisedButton(
                child: new Text("Open Camera"),
                  onPressed: (){
                  FlutterPluginZero.openCamera();
              })
            ],
          ),
        ),
      ),
    );
  }
}
