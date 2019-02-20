import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amaze_button/amaze_button.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home Page'),
      ),
      body: new ListView(
        children: <Widget>[
          new FutureAmazeButton(
            child: new Container(
              child: new Text(
                'Some Text',
                style: new TextStyle(fontSize: 20.0),
              ),
              padding: new EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                  border: new Border.all(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid),
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(10.0))),
            ),
            futureCall: () {
              return new Future.delayed(Duration(seconds: 2));
            },
          ),
        ],
      ),
    );
  }
}
