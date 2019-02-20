import 'package:flutter/material.dart';
import 'package:flutter_plugin_youtubeplayer/flutter_plugin_youtubeplayer.dart';

void main() => runApp(YoutubePlayerViewApp());


class YoutubePlayerViewApp extends StatefulWidget {
  @override
  YoutubePlayerViewState createState() {
    return YoutubePlayerViewState();
  }
}

class YoutubePlayerViewState extends State<YoutubePlayerViewApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          Center(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  width: 400.0,
                  height: 300.0,
                  child: YoutubePlayerView(
                    onYoutubePlayerCreated: _onTextViewCreated,
                  )
              )
          ),
          Expanded(
              flex: 3,
              child: Container(
                  color: Colors.blue[100],
                  child: Center(child: Text("Hello from Flutter!"))))
        ])
      ),
    );
  }

  void _onTextViewCreated(YoutubePlayerViewController controller) {
    //controller.setText('Hello from Android!');
  }

}

//
//class YoutubePlayerViewState extends State<YoutubePlayerViewApp> {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: const Text('Plugin example app'),
//        ),
//        body: Center(
//          child: Text('Running on:'),
//        ),
//      ),
//    );
//  }
//
//}