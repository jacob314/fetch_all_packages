import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:android_multiple_identifier/android_multiple_identifier.dart';
import 'dart:async';
import 'package:flutter/services.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _imei = 'Unknown';
  String _serial = 'Unknown';
  String _androidID = 'Unknown';
  Map _idMap = Map();
  String _result = '...';
  Future<File> _imageFile;
  VoidCallback listener;
  String _qrPath;

  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    Map idMap;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AndroidMultipleIdentifier.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    bool requestResponse = await AndroidMultipleIdentifier.requestPermission();
    print("NEVER ASK AGAIN SET TO: ${AndroidMultipleIdentifier.neverAskAgain}");

    try {
      // imei = await AndroidMultipleIdentifier.imeiCode;
      // serial = await AndroidMultipleIdentifier.serialCode;
      // androidID = await AndroidMultipleIdentifier.androidID;

      idMap = await AndroidMultipleIdentifier.idMap;
    } catch (e) {
      idMap = Map();
      idMap["imei"] = 'Failed to get IMEI.';
      idMap["serial"] = 'Failed to get Serial Code.';
      idMap["androidId"] = 'Failed to get Android id.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _idMap = idMap;
      _imei = _idMap["imei"];
      _serial = _idMap["serial"];
      _androidID = _idMap["androidId"];
    });
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            
            _qrPath = snapshot.data.path;
            
            return Image.file(snapshot.data);
          } else if (snapshot.error != null) {
            return const Text(
              'Error picking image.',
              textAlign: TextAlign.center,
            );
          } else {
            return const Text(
              'You have not yet picked an image.',
              textAlign: TextAlign.center,
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '\nRunning on: $_platformVersion\n',
              textAlign: TextAlign.center,
            ),
            Text('IMEI: $_imei\n'),
            Text(
              'Serial Code: $_serial\n',
              textAlign: TextAlign.center,
            ),
            Text(
              'Android ID: $_androidID\n',
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              child: Text('openSettings'),
              onPressed: () async {
                AndroidMultipleIdentifier.openSettings();
              },
            )
          ],
        )),
        floatingActionButton :FloatingActionButton(
            onPressed: () {
              _onImageButtonPressed(ImageSource.gallery);
              _result = "...";
            },
            heroTag: 'image0',
            tooltip: 'Pick Image from gallery',
            child: const Icon(Icons.photo_library),
          ),
      ),
    );
  }
}
