# ui_framework

An experiment for building UI across Android & iOS based on Atomic Design

## About

* Version: 0.0.4
* Compatible: sdk: ">=2.0.0-dev.68.0 <3.0.0"

This framework made with 3 directory. common, ios, android. Every directory contain atomic(Card, ListView, Slider, etc) and molecule(Text, Font, Button, etc) widget.

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:ui_framework/clade_listview.dart';
import 'package:ui_framework/clade_button.dart';
import 'package:ui_framework/common/atomic/custom_card/custom_card.dart';
import 'package:ui_framework/common/molecule/image_container/custom_image_container.dart';
import 'package:ui_framework/common/molecule/label/custom_label.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<CustomCard> cards = [
    CustomCard(
      children: <Widget>[
        CustomImageContainer(
          height: 300,
          radius: 5.0,
        ),
        SizedBox(height: 10.0,),
        CustomLabel(
          text: "A Fine Coffee.",
        ),
        CladeButton()
      ],
    )
  ];


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            centerTitle: false,
            title: Text("UI Framework"),
          ),
          backgroundColor: Colors.white,
          body: CladeListView(
            listCards: cards,
          )),
    );
  }
}
```

