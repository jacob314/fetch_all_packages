import 'package:flutter/material.dart';
import 'package:clipboard_plugin/clipboard_plugin.dart';

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
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                children: <Widget>[
                  Text('Your coupon is xYZ1234AB'),
                  RaisedButton(
                    child: Text('Copy to Clipboard'),
                    onPressed: () {
                      ClipboardPlugin.copyToClipBoard("xYZ1234AB").then((result) {
                        final snackBar = SnackBar(
                          content: Text('Copied to Clipboard'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      });
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
