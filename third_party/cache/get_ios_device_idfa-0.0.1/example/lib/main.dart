import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_ios_device_idfa/get_ios_device_idfa.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _idfa = 'Unknown';

  @override
  void initState() {
    super.initState();
    getIDFA();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getIDFA() async {
    String idfa;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      idfa = await GetIosDeviceIdfa.getIDFA;
    } on PlatformException {
      idfa = 'Failed to get idfa.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _idfa = idfa;
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
          child: Text('IDFA: $_idfa\n'),
        ),
      ),
    );
  }
}
