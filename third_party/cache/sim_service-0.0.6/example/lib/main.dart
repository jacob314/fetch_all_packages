import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sim_service/sim_service.dart';

void main() async {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SimData _simData;
  bool isdata = false;
  @override
  void initState() {
    isdata = false;
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    SimData simData;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      simData = await SimService.getSimData;
      if (simData != null) {
        print(simData);
        setState(() {
          _simData = simData;
          isdata = true;
        });
      }
    } on PlatformException {
      print('error ecorred ');
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: const Text('Plugin example app'),
            ),
            body: Container(
                child: Padding(
              padding: EdgeInsets.all(20.0),
              child: isdata
                  ? buidDataColumn()
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ))));
  }

  buidDataColumn() {
    return Column(
      children: _simData.cards.map((SimCard card) {
        return Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(card.carrierName),
                Text(card.displayName),
                Text(card.countryCode),
                Text(card.deviceId),
                Text('data roaming is ${card.isDataRoaming}')
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
