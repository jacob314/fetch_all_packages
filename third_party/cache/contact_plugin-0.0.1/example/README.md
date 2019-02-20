# contact_plugin_example


```
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:contact_plugin/contact_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String name = "name";
  String phone = "phone";

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getSelectContact() async {
    Map contact = await ContactPlugin.selectContact;
    setState(() {
      name = contact["name"];
      phone = contact["phone"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: <Widget>[
              ListTile(
                title: Text(name),
                subtitle: Text(phone),
              ),
              RaisedButton(
                onPressed: () {
                  getSelectContact();
                },
                child: Text("选择联系人"),
              ),
            ],
          )),
    );
  }
}

```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
