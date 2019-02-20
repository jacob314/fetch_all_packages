import 'package:flutter/material.dart';

import 'package:example_simple/app/label.dart' show NameLabel;
import 'package:example_simple/app/button.dart' show SetNameButton;

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      title: 'Basal simple example',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: _Homepage(
        title: 'Basal simple example'
      )
    );
}

class _Homepage extends StatelessWidget {
  final String title;

  _Homepage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NameLabel(),
            SizedBox(height: 100.0),
            SetNameButton(firstName: 'Dusan', lastName: 'Kovacevic'),
            SizedBox(height: 100.0),
            SetNameButton(firstName: 'Johnny', lastName: 'Rocketfingers')
          ]
        )
      )
    );
}
