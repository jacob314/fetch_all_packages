import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DemoHomeScreen(),
    );
  }
}

class DemoHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
             Card( 
               child: Text("Hello A"),
             ),
             Card(
               child: Text("Hello B"),
             ),
             Card(
               child: Text("Hello C"),
             ),
            ],
          ),
        ),
      ),
    );
  }
}
