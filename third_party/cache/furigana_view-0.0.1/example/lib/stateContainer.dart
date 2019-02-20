import 'package:flutter/material.dart';
import 'package:furigana_view/furigana_view.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final FuriganaState furiganaState;

  StateContainer({
    @required this.child,
    this.furiganaState,
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType
      (_InheritedStateContainer) as _InheritedStateContainer).state;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  FuriganaState furiganaState;

  void changeFontSize(double size) {
    setState(() {
      furiganaState.fontSize = size;
    });
  }

  void setTypeFurigana(int type) {
    setState(() {
      switch (type) {
        case type_hiragana:
          furiganaState.typeFurigana = type_hiragana;
          break;
        case type_katakana:
          furiganaState.typeFurigana = type_katakana;
          break;
        case type_romaji:
          furiganaState.typeFurigana = type_romaji;
          break;
        default:
          break;
      }
    });
  }

  void setShowingFurigana(bool isShowing) {
    setState(() {
      furiganaState.isShowFurigana = isShowing;
    });
  }

  void setTapColor(Color color) {
    setState(() {
      furiganaState.tapColor = color;
    });
  }

  void setTextColor(Color color) {
    setState(() {
      furiganaState.textColor = color;
    });
  }

  @override
  void initState() {
    if (widget.furiganaState == null) {
      furiganaState = new FuriganaState();
    } else {
      furiganaState = widget.furiganaState;
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(state: this, child: widget.child);
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState state;

  _InheritedStateContainer({
    Key key,
    @required this.state,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

