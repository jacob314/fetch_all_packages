import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc/nfc.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _tagData = 'Unknown';

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String tagData;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _tagData = await Nfc.readTag;
    } on PlatformException {
      _tagData = 'Failed to read NFC tag';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;

    setState(() {
      _tagData = tagData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Text('Running on: $_tagData\n'),
        ),
      ),
    );
  }
}
