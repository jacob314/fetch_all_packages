import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'photoLibrary.dart';
void main() => runApp(CupertinoApp(
home:MyApp()));

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
    return Scaffold(
        body: Center(
          child: MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new CupertinoPageRoute(builder: (context) => PhotoLibrary()));
            },
            child: Text("test"),
          ),
        ),
      );
  }
}
