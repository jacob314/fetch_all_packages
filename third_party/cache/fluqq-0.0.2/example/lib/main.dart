import 'dart:convert';

import 'package:fluqq/fluqq.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Tencent tencent;
  String json = '';

  @override
  Widget build(BuildContext context) {
    Fluqq.register('1105851298', '1105851298');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fluqq'),
        ),
        body: Column(
          children: <Widget>[
            MaterialButton(
              onPressed: login,
              child: Text('Login'),
              color: Colors.blueAccent,
            ),
            Text(json),
          ],
        ),
      ),
    );
  }

  void login() async {
    var login = await Fluqq.login();
    tencent = Tencent.fromJson(login.msg);
    var userInfo = await Fluqq.userInfo(tencent);
    setState(() {
      json = userInfo.msg;
    });
    var map = JsonDecoder().convert(userInfo.msg);
  }
}
