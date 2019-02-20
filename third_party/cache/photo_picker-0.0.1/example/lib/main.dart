import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:photo_picker/photo_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List _photos = [];
  Directory _tempDirectory;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    List photos = [];
    _tempDirectory = await getTemporaryDirectory();
    if (!mounted) return;

    setState(() {
      _photos = photos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: GridView.count(
          crossAxisCount: 4,
          children: _photos.map((m) {
            return Padding(
              child: Image.file(File(_tempDirectory.path + '/' + m['t']),
                  fit: BoxFit.cover, width: 40, height: 40),
              padding: EdgeInsets.all(10),
            );
          }).toList()),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FloatingActionButton(
            onPressed: () {
              PhotoPicker.camera({"edit": false}).then((onValue) {
                setState(() {
                  _photos.addAll(onValue);
                });
              });
            },
            tooltip: '拍照',
            child: Icon(Icons.photo_camera),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FloatingActionButton(
            onPressed: () {
              PhotoPicker.pickPhoto({
                "limit": 8,
                "cameraRollFirst": true,
                "mode": "fit",
              }).then((onValue) {
                setState(() {
                  _photos.addAll(onValue);
                });
              });
            },
            tooltip: '相册',
            child: Icon(Icons.photo_album),
          ),
        ),
      ]),
    ));
  }
}
