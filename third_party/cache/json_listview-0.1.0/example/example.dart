import 'package:flutter/material.dart';
import 'package:json_listview/json_listview.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var list = JsonListView.getArray(
        'https://jsonplaceholder.typicode.com/todos/',
        headers: {},  ///// request headers
        parameters: {},
        padding: 8.0,
        height: 50.0,
        listItem: (json, index) {
          return Text(json["title"]);
        }, onTap: (index) {
          print("$index selected");
        });
    return Scaffold(body: list);
  }
}
