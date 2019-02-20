import 'dart:async';

import 'package:flutter/services.dart';

class FlutterNowplayingPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_nowplaying_plugin');

  static Future<Track> get currentTrack async =>
      Track._fromMap(await _channel.invokeMethod('getCurrentTrack'));
}

class Track {
  Track._({this.album, this.artist, this.title});

  final String title;
  final String artist;
  final String album;

  static Track _fromMap(dynamic message) {
    final Map<dynamic, dynamic> map = message;
    return new Track._(
        title: map['title'], artist: map['artist'], album: map['album']);
  }

  const Track.empty()
      : title = "",
        artist = "",
        album = "";
}
