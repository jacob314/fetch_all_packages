import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folioreader/flutter_folioreader.dart';

typedef OnHighlightCallback = void Function(int style);

class HighlightPopup extends StatefulWidget {
  Function onShare, onNote, onDelete;
  OnHighlightCallback onHighlight;
  bool highlighted = false;
  int style = -1;

  HighlightPopup({this.onShare, this.onNote, this.onDelete, this.onHighlight, this.highlighted = false, this.style = -1});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print(this.highlighted);
    return _HighlightPopupState(highlighted: highlighted, style: style);
  }
}

class _HighlightPopupState extends State<HighlightPopup> {
  double TEXT_MENU_SIZE = 20;
  double COLOR_MENU_SIZE = 18;
  double POPUP_WIDTH_WITHOUT_DELETE = 150;
  double POPUP_WIDTH_WITH_DELETE = 200;
  bool highlighted = false;
  int style = -1;

  _HighlightPopupState({this.highlighted = false, this.style = -1});

  Widget _getColorMenuItem(Color color, bool selected) {
    if (!selected) {
      return Container(
        width: COLOR_MENU_SIZE,
        height: COLOR_MENU_SIZE,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle
        ),
      );
    } else {
      return Stack(
        children: <Widget>[
          Container(
            width: COLOR_MENU_SIZE + 8,
            height: COLOR_MENU_SIZE + 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle
            ),
          ),
          Positioned(
            top: 2,
            left: 2,
            child: Container(
              width: COLOR_MENU_SIZE + 4,
              height: COLOR_MENU_SIZE + 4,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              width: COLOR_MENU_SIZE,
              height: COLOR_MENU_SIZE,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _getTextMenu() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkResponse(
          onTap: () {
            if (widget.onShare != null) widget.onShare();
          },
          child: Container(
            child: Icon(Icons.share, size: TEXT_MENU_SIZE,), //Text("Share"),
          ),
        ),
        InkResponse(
          onTap: () {
            if (widget.onDelete != null) widget.onDelete();
          },
          child: Container(
            child: Icon(Icons.delete, size: TEXT_MENU_SIZE,),
          ),
        ),
        InkResponse(
          onTap: () {
            if (widget.onNote != null) widget.onNote();
          },
          child: Container(
            child: Icon(Icons.note, size: TEXT_MENU_SIZE,),
          ),
        ),
      ],
    );
  }

  Widget _getCloseCircleOutline() {
    return Stack(
      children: <Widget>[
        Container(
          width: COLOR_MENU_SIZE + 4,
          height: COLOR_MENU_SIZE + 4,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle
          ),
        ),
        Positioned(
          top: 2,
          left: 2,
          child: Container(
            width: COLOR_MENU_SIZE,
            height: COLOR_MENU_SIZE,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
            ),
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: Icon(Icons.close, size: COLOR_MENU_SIZE - 4,)
        ),
      ],
    );
  }

  Widget _getColorMenu() {
    List<Widget> widgets = [
      InkResponse(
        onTap: () {
          _handleHighlight(0);
        },
        child: _getColorMenuItem(Colors.yellow, this.style == 0),
      ),
      InkResponse(
        onTap: () {
          _handleHighlight(1);
        },
        child: _getColorMenuItem(Colors.green, this.style == 1),
      ),
      InkResponse(
        onTap: () {
          _handleHighlight(2);
        },
        child: _getColorMenuItem(Colors.redAccent, this.style == 2),
      ),
    ];

    if (this.highlighted) {
      widgets.add(InkResponse(
        onTap: () {
          _handleUnhighlight();
        },
        child: _getCloseCircleOutline(),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: widgets,
    );
  }

  void _handleHighlight(int style) {
    if (widget.onHighlight != null) widget.onHighlight(style);
    setState(() {
      highlighted = true;
      this.style = style;
    });
  }

  void _handleUnhighlight() {
    if (widget.onDelete != null) widget.onDelete();
    setState(() {
      highlighted = false;
      this.style = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(this.highlighted);
    var popupWidth = this.highlighted ? POPUP_WIDTH_WITH_DELETE : POPUP_WIDTH_WITHOUT_DELETE;
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            offset: Offset(1, 6),
            blurRadius: 4
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: <Widget>[
            Container(
              width: popupWidth,
              child: _getTextMenu(),
              padding: EdgeInsets.all(10),
            ),
            Container(
              color: Colors.black12,
              height: 1,
              width: popupWidth,
            ),
            Container(
              height: 2,
              width: popupWidth,
              decoration: BoxDecoration(
                color: Colors.white30
              ),
            ),
            Container(
              width: popupWidth,
              child: _getColorMenu(),
              padding: EdgeInsets.all(10),
            ),
          ]
        )
      ),
    );
  }
}