import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:phonecall_log/phonecall_log.dart';

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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PhonecallLog.platformVersion;
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
              RaisedButton(
                child: Text('Request permission'),
                onPressed: () {
                  PhonecallLog.requestPermission().then((data) {
                    print('data 3 - ${data}');
                  });
                },
              ),
              RaisedButton(
                child: Text('Check permission'),
                onPressed: () {
                  PhonecallLog.checkPermission().then((isHasPerrmission) {
                    print('isHasPerrmission - ${isHasPerrmission}');
                  });
                },
              ),
              Padding(
                child: RaisedButton(
                  child: Text('Get call Logs'),
                  onPressed: () {
                    PhonecallLog.getPhoneLogs().then((data) {
                      print('data - ${data}');
                    });
                  },
                ),
                padding: EdgeInsets.all(10.0),
              ),
              new Text('Running on: $_platformVersion\n'),
            ],
          )
        ),
      ),
    );
  }
}
