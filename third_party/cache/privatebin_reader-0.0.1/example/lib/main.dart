import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'package:privatebin_reader/privatebin_reader.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String password = "jgSKYTb6RxJNucqKmSMX/Jo2ued7R5uB3v21fp7nut4=";
  String data = "";
  String decrypted = "waiting";
  String decompressed = "waiting";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    get("https://paste.fizi.ca/?89d0e6176ce55279#jgSKYTb6RxJNucqKmSMX/Jo2ued7R5uB3v21fp7nut4=&json",
            headers: {'X-Requested-With': 'JSONHttpRequest'})
        .then((Response r) async {

      var val = await PrivatebinReader.decrypt(json.decode(r.body)['data'], password);
      setState(() {
        decrypted = val;
      });

      var d = await PrivatebinReader.decompress(decrypted);
      
      setState(() {
        decompressed = d;
      });

    }).catchError((Object err) {
      print(err.toString());
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            Container(child: Text(decompressed), margin: EdgeInsets.only(left: 10.0, right: 10.0),)
          ],
        ),
      ),
    );
  }
}
