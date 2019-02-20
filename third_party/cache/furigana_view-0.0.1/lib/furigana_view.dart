
import 'package:flutter/material.dart';
import 'package:furigana_view/entity/word.dart';
import 'package:flutter/foundation.dart';

const int type_normal = 1;
const int type_bold = 2;
const int type_italic = 4;

const int type_hiragana = 1;
const int type_katakana = 2;
const int type_romaji = 3;

const double default_font_size = 16.0;
const Color default_tap_color = Color(0xFFBDBDBD);
const Color default_text_color = Color(0xFF070707);

typedef FuriganaTapCallback = void Function(String baseForm);

class FuriganaView extends StatelessWidget {
  final List<Word> atomics;
  final double fontSize;
  final int typeFurigana;
  final bool isShowFurigana;
  final FuriganaTapCallback onTapFurigana;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color tapColor;
  final Color textColor;

  FuriganaView({
    Key key,
    @required this.atomics,
    this.fontSize = default_font_size,
    this.isShowFurigana = true,
    this.typeFurigana = type_hiragana,
    this.onTapFurigana,
    this.padding,
    this.margin,
    this.tapColor = default_tap_color,
    this.textColor = default_text_color,
  }) : assert(atomics != null),
        super(key: key);

  List<Widget> buildParagraphFurigana(List<Word> chunk) {
    List<Widget> widgets = [];
    for (Word atomic in chunk) {
      SingleWord word = new SingleWord(
        atomic: atomic,
        fontSize: fontSize,
        isShowFurigana: isShowFurigana,
        typeFurigana: typeFurigana,
        onTapFurigana: onTapFurigana,
        textColor: textColor,
        tapColor: tapColor,
      );
      widgets.add(word);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    List<List<Word>> chunks = [];
    for (var i = 0; i < atomics.length;) {
      List<Word> chunk = [];
      for (; i < atomics.length; i++) {
        chunk.add(atomics[i]);
        if (atomics[i].isBreak) {
          i++;
          break;
        }
      }
      chunks.add(chunk);
    }

    List<Wrap> wraps = [];
    for (List<Word> chunk in chunks) {
      List<Widget> widgets = buildParagraphFurigana(chunk);
      Wrap wrap = new Wrap(
          children: widgets
      );
      wraps.add(wrap);
    }

    return Container(
      padding: padding,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: wraps,
      ),
    );
  }
}

class SingleWord extends StatefulWidget {
  final Word atomic;
  final double fontSize;
  final int typeFurigana;
  final bool isShowFurigana;
  final FuriganaTapCallback onTapFurigana;
  final Color tapColor;
  final Color textColor;

  SingleWord({
    Key key,
    @required this.atomic,
    this.fontSize,
    this.isShowFurigana,
    this.typeFurigana,
    this.onTapFurigana,
    this.tapColor,
    this.textColor,
  }) : assert(atomic != null),
        super(key: key);

  @override
  _SingleWordState createState() => _SingleWordState();
}

class _SingleWordState extends State<SingleWord> {
  bool _highlight = false;

  void handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void handleTap() {
    if (widget.onTapFurigana != null && widget.atomic.hasMeaning) {
      widget.onTapFurigana(widget.atomic.baseForm);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pairs = [];
    FontStyle fontStyle = widget.atomic.style & type_italic == type_italic
        ? FontStyle.italic : FontStyle.normal;
    FontWeight fontWeight = widget.atomic.style & type_bold == type_bold
        ? FontWeight.bold : FontWeight.normal;
    if (widget.isShowFurigana) {
      String furiganaText = widget.atomic.hasFurigana ? widget.atomic.hiragana : "";
      if (widget.typeFurigana == type_katakana) {
        furiganaText = widget.atomic.katakana;
      } else if (widget.typeFurigana == type_romaji) {
        furiganaText = widget.atomic.romaji;
      }

      Text above = Text(
        furiganaText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: (widget.fontSize*2/3),
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          color: widget.textColor,
        ),
      );
      pairs.add(above);
    }

    Text below = Text(
      widget.atomic.text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        color: widget.textColor,
      ),
    );
    pairs.add(below);

    return GestureDetector(
      onTapDown: handleTapDown,
      onTapUp: handleTapUp,
      onTapCancel: handleTapCancel,
      onTap: handleTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(1.5, 1.5, 1.5, 1.5),
        child: Column(
          children: pairs,
        ),
        color: _highlight ? widget.tapColor : null,
      ),
    );
  }
}

class FuriganaState {
  double fontSize;
  int typeFurigana;
  bool isShowFurigana;
  Color tapColor;
  Color textColor;

  FuriganaState({
    this.fontSize = default_font_size,
    this.typeFurigana = type_hiragana,
    this.isShowFurigana = true,
    this.tapColor = default_tap_color,
    this.textColor = default_text_color,
  });
}
