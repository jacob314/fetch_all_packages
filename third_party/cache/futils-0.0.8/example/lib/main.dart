import 'package:flutter/material.dart';
import 'dart:async';
//import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:futils/futils.dart';
import 'package:futils/fwebview.dart';
//import 'package:futils/sin_points.dart';
//import 'package:futils/loop_banner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
//  bool _running = false;

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
      platformVersion = await Futils.platformVersion;
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

//    // receiving message from message channel
//    FWebView.setMessageChannelCallback((message){
//      print('Received message: $message');
//      var msg = jsonDecode(message);
//      if (msg != null) {
//        String url = msg['ShouldOverrideUrl'];
//        if (url != null && url.startsWith('fgit:')) {
//          FWebView.closeWebView();
//          Uri uri = Uri.parse(url);
//          String code = uri.queryParameters['code'];
//          print('Received github code: $code');
//        }
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: _Home(platformVersion: _platformVersion,),
    );
  }
}

class _Home extends StatefulWidget {
  _Home({
    Key key,
    this.platformVersion,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

  final String platformVersion;
}

class _HomeState extends State<_Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plugin Running on: ${widget.platformVersion}'),
//          actions: <Widget>[
//            IconButton(
//              icon: Text('Load'),
//              onPressed: (){
//                Navigator.of(context).push(MaterialPageRoute(builder: (context){
//                  return Scaffold();
//                },),);
////                FWebView.launchUrlInWidget(context, 'https://github.com');
////                FWebView.launchUrlInWebView('https://github.com');
////                FWebView.launchUrlInWebView('https://github.com/login/oauth/authorize?client_id=980af8b605f82ea3f5cc');
//              },
//            ),
////            IconButton(
////              icon: Text('C'),
////              onPressed: (){
////                FWebView.closeWebView();
////              },
////            ),
//          ],
      ),
//        body: Center(
//          child: MaterialButton(
//            padding: EdgeInsets.all(0),
//            onPressed: (){
//              setState((){
//                _running ^= true;
//              });
//            },
//            child: SizedBox(
//              width: 160,
//              height: 160,
//              child: SinPoints(
//                running: _running,
//              ),
//            ),
//          ),
//        ),
//         body: Center(
//           child: LoopBanner(
//             duration: Duration(milliseconds: 2000),
//             itemCount: 6,
//             itemBuilder: (context, position){
//               return Card(
//                 color: position % 3 == 0 ? Color(0xff33b5e5) :
//                   position % 3 == 1 ? Color(0xffdd4400) :
//                   Color(0xff44cc00),
//                 child: MaterialButton(
//                   onPressed: (){},
//                   child: Center(
//                     child: Text('${position + 1}',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 40,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
      body: Center(
        child: MaterialButton(
          color: Colors.blue,
          onPressed: (){
//            Navigator.of(context).push(MaterialPageRoute(builder: (context){
//              return Container();
//            },),);
            FWebView.launchUrlInWidget(context, 'https://github.com/login/oauth/'
                'authorize?scope=user:email&client_id=980af8b605f82ea3f5cc', messageCallback:(message){
              print('Received message: $message');
            });
          },
          child: Text('load', style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}

