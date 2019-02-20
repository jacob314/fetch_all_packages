import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tracker_plugin/tracker_plugin.dart';

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
    initServiceWallSdk();
  }

  Future<void> initServiceWallSdk() async {

    bool success = await TrackerPlugin.initSWSdk("MdOp67_T7Vo");
    if(success) {
      print("servicewall sdk initialize success.");
    }
    TrackerPlugin.stream.listen((Map data) {
      setState(() {
        String deviceInfo = data['device_info'];
        String newString = deviceInfo.substring(9000);
          print('deviceInfo=$newString');
        _platformVersion = data["fingerprint_id"];
      });
    });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;


  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
