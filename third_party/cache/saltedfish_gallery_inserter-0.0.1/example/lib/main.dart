import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:saltedfish_gallery_inserter/saltedfish_gallery_inserter.dart';
import 'dart:ui' as ui;

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  GlobalKey globalKey = GlobalKey();

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
      platformVersion = await SaltedfishGalleryInserter.platformVersion;
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
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: RepaintBoundary(
            child: Container(
              child: Text('Can take a screenshot'),
              height: 300.0,width:300.0,
              color: Colors.orange,
            ),key: globalKey,
          ),
        ),floatingActionButton: FloatingActionButton(onPressed: (){

        _capturePngToSave();
      },child: Icon(Icons.add),),
      ),
    );
  }

  Future<void> _capturePngToSave() async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    SaltedfishGalleryInserter.insertImageToGallery(image).then((map){
      print('$map');
    });
   /* ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);*/
  }
}
