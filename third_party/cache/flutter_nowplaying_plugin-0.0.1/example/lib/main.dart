import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nowplaying_plugin/flutter_nowplaying_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Track _track = new Track.empty();

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Track track = new Track.empty();
    if (Platform.isAndroid) {
      try {
        track = await FlutterNowplayingPlugin.currentTrack;
        if (!mounted) return;
      } on PlatformException {}
      setState(() {
        _track = track;
      });
    }
  }

  updateCurrentTrack() async {
    Track track = new Track.empty();
    // Platform messages may fail, so we use a try/catch PlatformException.
    if (Platform.isAndroid) {
      try {
        track = await FlutterNowplayingPlugin.currentTrack;
      } on PlatformException {}
    }
    setState(() {
      _track = track;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_track.title);
    print(_track.album);
    print(_track.artist);
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
            child: new Text(
                'Title: ${_track.title.trim()}\nAlbum: ${_track
                    .album.trim()}\nArtist: ${_track.artist.trim()}',
                style: new TextStyle(fontSize: 18.0))
        ),
        floatingActionButton: new FloatingActionButton(
            onPressed: updateCurrentTrack,
            tooltip: "Update Current Track",
            child: new Icon(Icons.update)),
      ),
    );
  }
}
