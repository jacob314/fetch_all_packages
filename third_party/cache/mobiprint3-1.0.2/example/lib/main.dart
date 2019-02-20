import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mobiprint3/mobiprint3.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';


  final ThemeData _themeData = new ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blueGrey,
    accentColor: Colors.greenAccent,
    buttonColor: Colors.green,
  );

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    dynamic rsp;
    dynamic rsp2;
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      rsp = await Mobiprint3.print('This is a really simplistic implementation of the mobiprint3 plugin for flutter\n\nOn spotting issues please contribute.');
      rsp2 = await Mobiprint3.custom("ianmin2", 2);
      await Mobiprint3.end();
      // print(rsp);
      print(rsp2);
      platformVersion = 'Flutter@ianmin2';
      // platformVersion = rsp['message'];
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: [
      //     const Locale('en', 'US'),
      // ],
      theme: _themeData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mobiprint3 by @ianmin2'),
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            RaisedButton(
              child: Text("Print"),
              onPressed: () async {
                final Map<String,dynamic> rsp = await Mobiprint3.print("I am sample text\n");
                print(rsp);
              },
            ),
            SizedBox(height: 6),
            RaisedButton(
              child: Text("Space"),
              onPressed: () async {
                final Map<String,dynamic> rsp = await Mobiprint3.space();
                print(rsp);
              },
            ),
            SizedBox(height: 6),
            RaisedButton(
              child: Text("Custom, 2"),
              onPressed: () async {
                final Map<String,dynamic> rsp = await Mobiprint3.custom("@ianmin2\n\n\n",2);
                print(rsp);
              },
            ),
            SizedBox(height: 6),
            RaisedButton(
              child: Text("Custom, 3"),
              onPressed: () async {
                final Map<String,dynamic> rsp = await Mobiprint3.custom("@ianmin2\n\n\n",3);
                print(rsp);
              },
            ),
            SizedBox(height: 6),
            // RaisedButton(
            //   child: Text("Check Paper"),
            //   onPressed: () async {
            //     Map<String,dynamic>  resp = await Mobiprint3.paper();
            //     print(resp);
            //      return showDialog<void>(
            //        context: context,
            //        barrierDismissible: false,
            //         builder: (BuildContext context) => AlertDialog(
            //           title: Text((resp['success'] == true) ? "GOOD TO GO" : "OOPS!"),
            //           content: Text((resp['success'] == true) ? "Paper is loaded": "No paper is loaded for printing"),
            //           actions: <Widget>[
            //             RaisedButton(
            //               child: Text("CONTINUE"),
            //               onPressed: ()
            //               {
            //                 Navigator.of(context).pop();
            //               },)
            //           ],
            //         )
            //       );
                
            //   },
            // ),
            // SizedBox(height: 6),
          ],
        )
      ),
    );
  }
}
