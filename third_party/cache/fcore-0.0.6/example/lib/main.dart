import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fcore/fcore.dart';
import 'package:fcore/ui/sin_points.dart';
// import 'package:fcore/ui/loop_banner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _running = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Fcore.platformVersion;
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
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin Running on: $_platformVersion'),
        ),
        body: Center(
          child: MaterialButton(
            padding: EdgeInsets.all(0),
            onPressed: (){
              setState((){
                _running ^= true;
              });
            },
            child: SizedBox(
              width: 160,
              height: 160,
              child: SinPoints(
                running: _running,
              ),
            ),
          ),
        ),
        // body: Center(
        //   child: LoopBanner(
        //     duration: Duration(milliseconds: 2000),
        //     itemCount: 6,
        //     itemBuilder: (context, position){
        //       return Card(
        //         color: position % 3 == 0 ? Color(0xff33b5e5) : 
        //           position % 3 == 1 ? Color(0xffdd4400) : 
        //           Color(0xff44cc00),
        //         child: MaterialButton(
        //           onPressed: (){},
        //           child: Center(
        //             child: Text('${position + 1}',
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 40,
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ),
    );
  }
}
