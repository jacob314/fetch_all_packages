import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fluchar/fluchar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String txt = '';

  @override
  void initState() {
    super.initState();
    char('21508');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(txt),
        ),
      ),
    );
  }

  void char(String str) async {
    txt = await Fluchar.char(str);
    setState(() {
      txt;
    });
  }
}
