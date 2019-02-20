import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_plugin/flutter_xiaowen_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _packageName = "unKonwn PackageName";
  String _applicationName = "unknown APplicationName";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initPackageName();
    initApplicationName();
  }

  Future<void> initApplicationName() async {
    String applicationName;
    try {
      applicationName = await FlutterPlugin.currentApplicationName;
    } on PlatformException {
      _applicationName = "获取应用名称失败";
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _applicationName = applicationName;
    });
  }

  Future<void> initPackageName() async {
    String packageName;
    try {
      packageName = await FlutterPlugin.packageName;
    } on PlatformException {
      packageName = " 获取包名失败";
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _packageName = packageName;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterPlugin.platformVersion;
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Running on: $_platformVersion\n+'),
              Text('Running on: $_packageName\n+'),
              Text('Running on: $_applicationName\n+'),
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: initPackageName,
          tooltip: "获取包名",
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
