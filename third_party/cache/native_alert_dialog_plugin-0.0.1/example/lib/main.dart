import 'package:flutter/material.dart';
import 'package:native_alert_dialog_plugin/native_alert_dialog_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _userAnswer = false;
  String _title = 'Native Alert Dialog';
  String _body = 'Do you want to proceed?';
  String _positiveButtonText = 'OK';
  String _negativeButtonText = 'CANCEL';

  void _showNativeDialog() {
    showNativeDialog(
            title: _title,
            body: _body,
            positiveButtonText: _positiveButtonText,
            negativeButtonText: _negativeButtonText,
            buttonColor: Theme.of(context).primaryColor)
        .then((answer) => setState(() {
              _userAnswer = answer;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: _title,
                ),
                onSaved: (title) => _title = title,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Body',
                  hintText: _body,
                ),
                onSaved: (body) => _body = body,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Positive Button Text',
                  hintText: _positiveButtonText,
                ),
                onSaved: (positiveButtonText) =>
                    _positiveButtonText = positiveButtonText,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Negative Button Text',
                  hintText: _negativeButtonText,
                ),
                onSaved: (negativeButtonText) =>
                    _negativeButtonText = negativeButtonText,
              ),
              Text('Result = $_userAnswer'),
              RaisedButton(
                onPressed: _showNativeDialog,
                child: Text("show dialog"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
