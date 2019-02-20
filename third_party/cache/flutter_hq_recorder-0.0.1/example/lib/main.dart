import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_hq_recorder/flutter_hq_recorder.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _curPath = '';
  File file;
  Permission permission = Permission.RecordAudio;
  Permission permission2 = Permission.WriteExternalStorage;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String curPath;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterHqRecorder.platformVersion;
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

  Future<Null> getDocDir() async {
    Directory dir = (await getApplicationDocumentsDirectory());
    String path = dir.path.toString();
    Directory newDir =
        await Directory(path + '/recordings1').create(recursive: true);
    path = newDir.path;
    setState(() {
      _curPath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    getDocDir();

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            new Text('Running on: $_platformVersion\n'),
            new Text('Doc Path: $_curPath\n'),
            MaterialButton(
              child: Text('Request Permissions'),
              onPressed: () async {
                bool res =
                    await SimplePermissions.requestPermission(permission);
                bool res2 =
                    await SimplePermissions.requestPermission(permission2);
                print('Request res: ' + res.toString());
                print('Request res2: ' + res2.toString());
              },
            ),
            MaterialButton(
              child: Text('Initialize Recorder'),
              onPressed: () {
                FlutterHqRecorder
                    .initializeRecorder(_curPath + '/recordertester.wav');
              },
            ),
            MaterialButton(
              child: Text('Start Recording'),
              onPressed: () {
                FlutterHqRecorder.startRecording();
              },
            ),
            MaterialButton(
              child: Text('Stop Recording'),
              onPressed: () async {
                await FlutterHqRecorder.stopRecording();
                File testFile = new File(_curPath + '/recordertester.wav');
                print('File:!!!!');
                print(await testFile.exists());
                List<int> bytes = testFile.readAsBytesSync();
                String base64 = base64Encode(bytes);
                print(base64.substring(0, 30));
                print(base64.substring(base64.length - 30));
                // testFile.delete();
                // print(await testFile.exists());
              },
            ),
          ],
        ),
      ),
    );
  }
}
