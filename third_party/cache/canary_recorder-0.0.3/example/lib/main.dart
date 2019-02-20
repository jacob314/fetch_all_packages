import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:canary_recorder/canary_recorder.dart';
import 'package:flutter_permissions_helper/permissions_helper.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _outputFile = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            new Text('Recording Path: $_outputFile'),
            MaterialButton(
              child: Text('Request Permissions'),
              onPressed: () async {
                var res = await PermissionsHelper.requestPermission(Permission.RecordAudio);
                var res2 = await PermissionsHelper.requestPermission(Permission.WriteExternalStorage);
                print('Request res: ' + res.toString());
                print('Request res2: ' + res2.toString());
              },
            ),
            MaterialButton(
              child: Text('Start Recording'),
              onPressed: () async {
                var path = await CanaryRecorder.initializeRecorder('recordertester.wav');
                await CanaryRecorder.startRecording();

                setState(() { _outputFile = path; });
              },
            ),
            MaterialButton(
              child: Text('Stop Recording'),
              onPressed: () async {
                await CanaryRecorder.stopRecording();
                File testFile = new File(_outputFile);
                print('File:!!!!');
                print(await testFile.exists());
                List<int> bytes = testFile.readAsBytesSync();
                String base64 = base64Encode(bytes);
                print(base64.substring(0, 30));
                print(base64.substring(base64.length - 30));
                // testFile.delete();
                // print(await testFile.exists());
              },
            )
          ],
        ),
      ),
    );
  }
}
