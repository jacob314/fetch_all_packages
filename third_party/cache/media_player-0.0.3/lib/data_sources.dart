class Source {
  String sourceType;
  Source({this.sourceType});

  get count => 1;
}

class MediaFile extends Source {
  String type;
  String source;
  String title;
  String desc;

  MediaFile({this.type, this.source, this.title, this.desc})
      : super(sourceType: "single");
  Map toMap() {
    return {"type": type, "source": source, "title": title, "desc": desc};
  }

  get count => 1;
}

class Playlist extends Source {
  List<MediaFile> mediaFiles;

  Playlist(this.mediaFiles) : super(sourceType: "playlist");

  List<dynamic> toMap() {
    List list = mediaFiles.map((value) => value.toMap()).toList();
    print(list);
    return list;
  }

  get contents => mediaFiles;
  get count => mediaFiles.length;
}
