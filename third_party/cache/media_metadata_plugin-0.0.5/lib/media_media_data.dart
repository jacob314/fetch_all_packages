import 'dart:convert';

class AudioMetaData {
  String artistName = "";
  String authorName = "";
  String trackName = "";
  String album = "";
  String mimeTYPE = "";
  int trackDuration = 0;

  AudioMetaData.fromJson(Map<String, dynamic> json)
      : artistName = json['ArtistName'],
        authorName = json['AuthorName'],
        trackName = json['TrackName'],
        album = json['Album'],
        mimeTYPE = json['MimeTYPE'],
        trackDuration = json['TrackDuration'];
}
