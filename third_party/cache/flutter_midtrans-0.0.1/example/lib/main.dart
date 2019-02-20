import 'package:flutter/material.dart';
import 'package:flutter_midtrans/flutter_midtrans.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    Midtrans.initSdkFlow(clientKey: 'SB-Mid-client-Iz_s_TejyRkYDWxn');
  }

  void testTransaction() {
    final user =
        MidtransUser('Ardiansyah Putra', 'putraxor@gmail.com', 'putraxor-01');
    final transId = 'trans-01';
    final items = [MidtransItem('01', 'Premium', 100000, 1)];
    Midtrans.createTransaction(transId: transId, items: items, user: user);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Text('Hello, Midtrans'),
        ),
      ),
    );
  }
}
