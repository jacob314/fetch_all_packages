import 'package:flutter/material.dart';
import 'package:flutter_clevertap/flutter_clevertap.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  onPressed: () => Clevertap.pushEvent(),
                  child: Text('Push Event')
              ),
              RaisedButton(
                  onPressed: () => Clevertap.pushUser,
                  child: Text('Push User')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
