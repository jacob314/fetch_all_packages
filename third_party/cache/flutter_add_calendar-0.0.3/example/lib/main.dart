import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_add_calendar/flutter_add_calendar.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  FlutterAddCalendar flutterAddCalendar = new FlutterAddCalendar();
  StreamSubscription<StatusCalendar> _onStatusAdd;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _onStatusAdd =
        flutterAddCalendar.onStatusAdd.listen((StatusCalendar status) {
            print("New status ${status.code} ${status.message}");
        });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onStatusAdd.cancel();
    flutterAddCalendar.dispose();

    super.dispose();
  }

  Future<void> initPlatformState() async {
    print("call initPlatformState");
    Map<String, String> event = {"title": "event add calendar", "desc": "test add event to canlendar of device", "startDate": "1545184862000", "endDate": "1545189862000", "alert": "180000"};
    flutterAddCalendar.setEventToCalendar(event);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app add calendar'),
        ),
        body: new Center(
          child: new Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
