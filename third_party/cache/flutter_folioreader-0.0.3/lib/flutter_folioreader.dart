import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

class FlutterFolioreader {
  static const MethodChannel _channel =
      const MethodChannel('flutter_folioreader');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  final _onHighlight = StreamController<Highlight>.broadcast();
  final _onHighlightNote = StreamController<Highlight>.broadcast();
  final _onUpdateHighlight = StreamController<Highlight>.broadcast();
  final _onUpdateHighlightNote = StreamController<Highlight>.broadcast();
  final _onDeleteHighlight = StreamController<String>.broadcast();
  final _onShareHighlight = StreamController<Highlight>.broadcast();
  final _onClose = StreamController<Null>.broadcast();
  final _onTriggerHighlight = StreamController<Tuple2<Rect, String>>.broadcast();
  final _onDismissPopup = StreamController<Null>.broadcast();

  static final FlutterFolioreader _instance = FlutterFolioreader._internal();

  factory FlutterFolioreader() {
    return _instance;
  }

  FlutterFolioreader._internal() {
    _channel.setMethodCallHandler((MethodCall m) {
      switch(m.method) {
        case "highlight":
          _onHighlight.add(Highlight.fromHashMap(m.arguments));
          break;
        case "highlightNote":
          _onHighlightNote.add(Highlight.fromHashMap(m.arguments));
          break;
        case "updateHighlight":
          _onUpdateHighlight.add(Highlight.fromHashMap(m.arguments));
          break;
        case "updateHighlightNote":
          _onUpdateHighlightNote.add(Highlight.fromHashMap(m.arguments));
          break;
        case "deleteHighlight":
          _onDeleteHighlight.add(m.arguments["highlightId"]);
          break;
        case "shareHighlight":
          _onShareHighlight.add(Highlight.fromHashMap(m.arguments));
          break;
        case "closed":
          _onClose.add(null);
          break;
        case "trigger_highlight":
          try {
            _onTriggerHighlight.add(Tuple2(Rect.fromLTRB(
              m.arguments["left"] * 1.0, m.arguments["top"] * 1.0,
              m.arguments["right"] * 1.0, m.arguments["bottom"] * 1.0), m.arguments["id"]));
          } catch(e) {
            print(e);
          }
          break;
        case "dismiss_popup":
          _onDismissPopup.add(null);
      }
    });
  }

  Stream<Highlight> get onHighlight => _onHighlight.stream;
  Stream<Highlight> get onHighlightNote => _onHighlightNote.stream;
  Stream<Highlight> get onUpdateHighlight => _onUpdateHighlight.stream;
  Stream<Highlight> get onUpdateHighlightNote => _onUpdateHighlightNote.stream;
  Stream<String> get onDeleteHighlight => _onDeleteHighlight.stream;
  Stream<Highlight> get onShareHighlight => _onShareHighlight.stream;
  Stream<Null> get onClose => _onClose.stream;
  Stream<Tuple2<Rect, String>> get onTriggerHighlight => _onTriggerHighlight.stream;
  Stream<Null> get onDismissPopup => _onDismissPopup.stream;

  Future<Null> openBook(String path) async {
    await _channel.invokeMethod("openbook", {'path': path});
  }

  Future<Null> back() async {
    await _channel.invokeMethod("back");
  }

  Future<Null> open() async {
    await _channel.invokeMethod("open");
  }

  Future<Null> highlight(int style) async {
    await _channel.invokeMethod("highlight", {'style': style});
  }

  Future<Null> deleteHighlight() async {
    await _channel.invokeMethod("delete_highlight");
  }
}

class Highlight {
  final String bookId;
  final String content;
  final String type;
  final int pageNumber;
  final String pageId;
  final String rangy;
  final String uuid;
  final String note;

  Highlight(this.bookId, this.content, this.type, this.pageNumber, this.pageId, this.rangy, this.uuid, this.note);

  static Highlight fromHashMap(dynamic info) {
    return Highlight(
        info['bookId'], info['content'],
        info['type'], info['pageNumber'],
        info['pageId'], info['rangy'],
        info['uuid'], info['note']);
  }
}
