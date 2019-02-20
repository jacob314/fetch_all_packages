import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folioreader/flutter_folioreader.dart';
import 'package:flutter_folioreader/components/highlight_popup.dart';
import 'package:tuple/tuple.dart';

class FolioBookWidget extends StatefulWidget {
  String path;
  double width;
  double height;

  FolioBookWidget(this.path, this.width, this.height);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FolioBookState();
  }
}

class _FolioBookState extends State<FolioBookWidget> {
  bool showMenu = false;
  double menuTop = 0;
  double menuLeft = 0;
  String selectedHighlightId = null;

  FlutterFolioreader folioreader = FlutterFolioreader();

  _FolioBookState() {
    folioreader.onTriggerHighlight.listen((Tuple2<Rect, String> tuple) {
      print(tuple.item1);
      print(widget.height);
      setState(() {
        showMenu = true;
        menuTop = tuple.item1.top / MediaQuery.of(context).devicePixelRatio;
        menuLeft = tuple.item1.left / MediaQuery.of(context).devicePixelRatio;
        selectedHighlightId = tuple.item2;
      });
    });

    folioreader.onDismissPopup.listen((Null) {
      setState(() {
        showMenu = false;
      });
    });

    folioreader.onHighlight.listen((Highlight highlight) {
      print(highlight);
    });

    folioreader.onDeleteHighlight.listen((String id) {
      setState(() {
        showMenu = false;
        print("onDeleteHighlight ${id}");
      });
    });
  }

  Widget _getFolioWiget() {
    if (widget.path == null) return Text("Loading...");
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.flutterfolioreader/FlutterFolioViewPager',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: widget.path,
        creationParamsCodec: StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  Widget _getMenuWidget() {
    if (this.showMenu)
      return Positioned(
        left: menuLeft,
        top: menuTop,
        child: HighlightPopup(
          highlighted: selectedHighlightId != null,
          style: selectedHighlightId != null ? 0 : -1,
          onHighlight: (style) {
            folioreader.highlight(style);
          },
          onDelete: () {
            folioreader.deleteHighlight();
          },
        ),
      );
    else
      return Positioned(
        child: Container(),
      );
  }

  void _onPlatformViewCreated(int id) {
    //TODO
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Container(
          width: widget.width,
          height: widget.height,
          child: _getFolioWiget(),
        ),
        _getMenuWidget()
      ],
    );
  }

}