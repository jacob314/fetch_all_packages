import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice_tea_studio_plugins/ice_tea_studio_plugins.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _platformMessage = '';

  int radioValue = 0;
  bool switchValue = false;
  ToastGravity toastGravity = ToastGravity.TOP;
  String toastMessage = "Looks like you cancelled the login request. Please try again.";

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
      print('value $radioValue');
      switch (radioValue) {
        case 0:
          toastGravity = ToastGravity.TOP;
          break;
        case 1:
          toastGravity = ToastGravity.CENTER;
          break;
        default :
          toastGravity = ToastGravity.BOTTOM;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await NativeUtilsPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  showToastMessage() async {
    try {
      await NativeUtilsPlugin.showToast(
          msg: toastMessage,
          backgroundColor: "#84db00",
          textSize: 18,
          gravity: toastGravity,
          isFullWidth: switchValue);

      if (!mounted) return;

      setState(() {
        _platformMessage = 'ok';
      });
    } on PlatformException {
      _platformMessage = 'Failed to call show toast message.';
    }
  }

  showToastMessage2() async {
    try {
      await NativeUtilsPlugin.showToast(
          msg: toastMessage,
          backgroundColor: "#d77d00",
          textSize: 25,
          gravity: toastGravity,
          isFullWidth: switchValue);

      if (!mounted) return;

      setState(() {
        _platformMessage = 'ok';
      });
    } on PlatformException {
      _platformMessage = 'Failed to call show toast message.';
    }
  }

  showToastMessage3() async {
    try {
      await NativeUtilsPlugin.showToast(
          msg: toastMessage,
          backgroundColor: "#B71C1C",
          textSize: 25,
          gravity: toastGravity,
          isFullWidth: switchValue);

      if (!mounted) return;

      setState(() {
        _platformMessage = 'ok';
      });
    } on PlatformException {
      _platformMessage = 'Failed to call show toast message.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app x'),
        ),
        body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text('Running status: $_platformMessage'),
                new Container(
                  child: new Text('Running on: $_platformVersion'),
                ),
                new Container(
                  width: 250.0,
                  padding: new EdgeInsets.all(20.0),
                  child: buildRadio(),),
                new Container(
                    width: 250.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Text('isFullWidth'),
                        _buildSwitch(),
                      ],
                    )),
                new Padding(padding: const EdgeInsets.only(top: 10.0)),
                _buildButton('Show Toast', showToastMessage),
                new Padding(padding: const EdgeInsets.only(top: 10.0)),
                _buildWarningButton('Show Warning Toast', showToastMessage2),
                new Padding(padding: const EdgeInsets.only(top: 10.0)),
                _buildErrorButton('Show Error Toast', showToastMessage3),
              ],
            )
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback callBack) {
    return new Material(
      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(new Radius.circular(100.0))),
      color: Colors.green[400],
      child: new InkWell(
        splashColor: Colors.green[900],
        borderRadius: new BorderRadius.circular(100.0),
        onTap: callBack,
        child: new Container(
            width: 250.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            child: new Text(text.toUpperCase(), style: new TextStyle(color: Colors.white),)),
      ),
    );
  }

  Widget _buildWarningButton(String text, VoidCallback callBack) {
    return new Material(
      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(new Radius.circular(100.0))),
      color: Colors.orange[400],
      child: new InkWell(
        splashColor: Colors.orange[900],
        borderRadius: new BorderRadius.circular(100.0),
        onTap: callBack,
        child: new Container(
            width: 250.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            child: new Text(text.toUpperCase(), style: new TextStyle(color: Colors.white),)),
      ),
    );
  }

  Widget _buildErrorButton(String text, VoidCallback callBack) {
    return new Material(
      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(new Radius.circular(100.0))),
      color: Colors.red[400],
      child: new InkWell(
        splashColor: Colors.red[900],
        borderRadius: new BorderRadius.circular(100.0),
        onTap: callBack,
        child: new Container(
            width: 250.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            child: new Text(text.toUpperCase(), style: new TextStyle(color: Colors.white),)),
      ),
    );
  }

  Widget buildRadio() {
    return new Align(
        alignment: const Alignment(0.0, -0.2),
        child: new Column(
            children: <Widget>[
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text('TOP'),
                    new Text('CENTER'),
                    new Text('BOTTOM'),
                  ]
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Radio<int>(
                        value: 0,
                        groupValue: radioValue,
                        onChanged: handleRadioValueChanged
                    ),
                    new Radio<int>(
                        value: 1,
                        groupValue: radioValue,
                        onChanged: handleRadioValueChanged
                    ),
                    new Radio<int>(
                        value: 2,
                        groupValue: radioValue,
                        onChanged: handleRadioValueChanged
                    )
                  ]
              ),
            ]
        )
    );
  }

  Widget _buildSwitch() {
    return new Align(
      alignment: const Alignment(0.0, -0.2),
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Switch(
              value: switchValue,
              onChanged: (bool value) {
                setState(() {
                  switchValue = value;
                });
              }
          ),
        ],
      ),
    );
  }

}