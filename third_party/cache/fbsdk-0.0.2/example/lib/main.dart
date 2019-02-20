import 'package:flutter/material.dart';
import 'package:fbsdk/login_kit.dart';
import 'package:fbsdk/share_kit.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Column(children: [
            new Container(
              child: new RaisedButton(
                  child: new Text("Login to Facebook"),
                  onPressed: () async {
                    final response = await FacebookLoginKit
                        .loginWithReadPermissions(["public_profile"]);
                    print(response);
                  }),
              margin: const EdgeInsets.only(top: 32.0),
            ),
            new Container(
              child: new RaisedButton(
                child: new Text("Share some content"),
                onPressed: () async {
                  final response =
                      await FacebookShareKit.shareLinkWithShareDialog({
                    "contentType": 'link',
                    "contentUrl": "https://facebook.com",
                    "contentDescription": 'Wow, check out this great site!'
                  });
                  print(response);
                },
              ),
              margin: const EdgeInsets.only(top: 32.0),
            )
          ]),
        ),
      ),
    );
  }
}
