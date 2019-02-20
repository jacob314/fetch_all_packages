import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:voice_recognition/voice_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String resultString;
  VoiceRecognitionController controller;
  bool isListening = true;
  @override
  void initState() {
    super.initState();
  }
  void stopListening() {
    if (isListening) {
      controller.stopListening();
    } else {
      controller.startListening();
    }
    isListening = !isListening;
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  @override
  Widget build(BuildContext context) {
//    double fullWidth = MediaQuery.of(context).size.width;
//    double fullHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
        home: Scaffold(
            body: new Container(
              width: 300,
              height: 500,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(colors: [Colors.purple[500], Colors.purple[700]],
                    begin: const FractionalOffset(0.5, 0.0),
                    end: const FractionalOffset(0.0, 0.5),
                    stops: [0.0,1.0],
                    tileMode: TileMode.clamp
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                      width: 250,
                      height: 100,
                      color: Color.fromARGB(255, 255, 0, 0),
                      child: VoiceRecognition(
                        onVoiceRecognitionCreated: _onVoiceRecognitionCreated,
                      ),
                  ),
                  FloatingActionButton(
                    onPressed: stopListening,
                  )
                ],
              )
            )


        )
    );
  }

  void _onVoiceRecognitionCreated(VoiceRecognitionController _controller) {
    controller = _controller;
    controller.setHandler(_handeler);
    controller.startListening();
  }

  Future<dynamic> _handeler(MethodCall call) async {
    switch(call.method) {
      case "voice.result":
        debugPrint(call.arguments);
        setState(() {
          resultString = call.arguments;
        });
        break;
      case "voice.permission":
        debugPrint(call.arguments);
        setState(() {
          if (call.arguments == false) {
            resultString = "Permission Denied";
          }
        });
        break;
      default:
        break;
    }
    return 0;
  }
}
