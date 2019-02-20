import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:package_test/package_test.dart';

void main() => runApp(new MyAppTest());

class MyAppTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(title: new Text('Demo')),
          body: new Builder(builder: (BuildContext context) {
            return new FlatButton(
              child: new Text('BUTTON'),
              onPressed: () {
                // here, Scaffold.of(context) returns the locally created Scaffold
                showAlert(context);
              },
            );
          })),
    );
  }

  void showAlert(BuildContext context) {
    AlertDialog dialog;
    var title = " abcdhadasda ";
    var description = "dsakdjs dksajd klasjd lkasdjsald as";
    var confirm = "OK";

    dialog = new AlertDialog(
      contentPadding: new EdgeInsets.all(0.0),
      content: new Container(
        width: 300.0,
        height: 220.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          children: <Widget>[
            Container(
              height: 170.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "images/sapban.png",
                    height: 50.0,
                    width: 100.0,
                  ),
                  Container(
                    margin: title.isNotEmpty
                        ? EdgeInsets.all(8.0)
                        : EdgeInsets.all(0.0),
                    child: Text(
                      title != null ? title : "",
                      style: TextStyle(
                        color: Color(0xFFe5101d),
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: new Container(
                height: 50.0,
                decoration: new BoxDecoration(
                  color: const Color(0xFFd30c0c),
                ),
                child: new Center(
                  child: new Text(
                    confirm != null ? confirm : "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // showDialog(context: context, child: dialog);

    showDialog(context: context, builder: (_) => dialog);
  }
}
