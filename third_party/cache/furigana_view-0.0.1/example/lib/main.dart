import 'package:flutter/material.dart';
import 'stateContainer.dart';
import 'package:furigana_view/furigana_view.dart';
import 'package:furigana_view/entity/word.dart';

void main() {
  runApp(StateContainer(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FuriganaSample(),
    );
  }
}

class FuriganaSample extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    StateContainerState containerState = StateContainer.of(context);
    FuriganaState furiganaState = containerState.furiganaState;
    List<Word> atomics = [];
    Word atomic = new Word("ノーベル", "ノーベル", "", "", "", true, true, false, 2);
    atomics.add(atomic);
    atomic = new Word("賞", "賞", "しょう", "ショウ", "shou", true, true, false, 2);
    atomics.add(atomic);
    atomic = new Word("本庶", "本庶", "ほんじょ", "ホンジョ", "honjo", true, true, false, 2);
    atomics.add(atomic);
    atomic = new Word("さん", "さん", "", "", "", false, false, false, 2);
    atomics.add(atomic);
    atomic = new Word("晩さん会", "晩さん会", "ばんさんかい", "バンサンカイ", "bansankai", true, true, false, 2);
    atomics.add(atomic);
    atomic = new Word("で", "で", "", "", "", false, false, false, 2);
    atomics.add(atomic);
    atomic = new Word("スピーチ", "スピーチ", "", "", "", false, true, true, 2);
    atomics.add(atomic);
    atomic = new Word("ノーベル", "ノーベル", "", "", "", true, true, false, 1);
    atomics.add(atomic);
    atomic = new Word("賞", "賞", "しょう", "ショウ", "shou", true, true, false, 1);
    atomics.add(atomic);
    atomic = new Word("の", "の", "", "", "", true, false, false, 1);
    atomics.add(atomic);
    atomic = new Word("受賞者", "受賞者", "じゅしょうしゃ", "ジュショウシャ", "jushousha", true, true, false, 1);
    atomics.add(atomic);
    atomic = new Word("を", "を", "", "", "", true, false, false, 1);
    atomics.add(atomic);
    atomic = new Word("祝福", "祝福", "しゅくふく", "シュクフク", "shukufuku", true, true, false, 1);
    atomics.add(atomic);
    atomic = new Word("する", "する", "", "", "", false, false, false, 1);
    atomics.add(atomic);
    atomic = new Word("恒例", "恒例", "こうれい", "コウレイ", "kourei", true, true, false, 1);
    atomics.add(atomic);
    atomic = new Word("の", "の", "", "", "", true, false, false, 1);
    atomics.add(atomic);
    atomic = new Word("晩さん会", "晩さん会", "ばんさんかい", "バンサンカイ", "bansankai", true, true, false, 1);
    atomics.add(atomic);
    atomic = new Word("スウェーデン", "スウェーデン", "", "", "", true, false, false, 1);
    atomics.add(atomic);
    atomic = new Word("の", "の", "", "", "", true, false, false, 1);
    atomics.add(atomic);
    atomic = new Word("ストックホルムで", "ストックホルムで", "", "", "", true, true, false, 1);
    atomics.add(atomic);
    atomic = new Word("始まり", "始まる", "はじまり", "ハジマリ", "hajimari", true, true, false, 1);
    atomics.add(atomic);
    atomic = new Word("。", "。", "", "", "", true, true, false, 1);
    atomics.add(atomic);

    return MaterialApp(
      title: 'Furigana View Demo',
      theme: new ThemeData(
        primaryColor: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Furigana View Demo'),
        ),
        body: Builder(builder: (context) =>
            Column(
              children: <Widget>[
                new FuriganaView(atomics: atomics,
                  onTapFurigana: (baseForm){
                    final snackBar = SnackBar(content: Text('click to $baseForm'));
                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                  fontSize: furiganaState.fontSize,
                  isShowFurigana: furiganaState.isShowFurigana,
                  typeFurigana: furiganaState.typeFurigana,
                  tapColor: furiganaState.tapColor,
                  textColor: furiganaState.textColor,
                  padding: EdgeInsets.all(10.0),
                ),
                RaisedButton(
                  child: const Text('Change Text Size'),
                  elevation: 4.0,
                  onPressed: (){
                    if (furiganaState.fontSize == 16.0) {
                      containerState.changeFontSize(32.0);
                    } else {
                      containerState.changeFontSize(16.0);
                    }
                  },
                ),
                RaisedButton(
                  child: const Text('On/Off Furigana'),
                  elevation: 4.0,
                  onPressed: (){
                    if (furiganaState.isShowFurigana) {
                      containerState.setShowingFurigana(false);
                    } else {
                      containerState.setShowingFurigana(true);
                    }
                  },
                ),
                RaisedButton(
                  child: const Text('Change Type Furigana'),
                  elevation: 4.0,
                  onPressed: (){
                    if (furiganaState.typeFurigana == 1) {
                      containerState.setTypeFurigana(2);
                    } else if (furiganaState.typeFurigana == 2) {
                      containerState.setTypeFurigana(3);
                    } else {
                      containerState.setTypeFurigana(1);
                    }
                  },
                ),
                RaisedButton(
                  child: const Text('Change Text Color'),
                  elevation: 4.0,
                  onPressed: (){
                    if (furiganaState.textColor == Colors.red) {
                      containerState.setTextColor(Colors.black87);
                    } else {
                      containerState.setTextColor(Colors.red);
                    }
                  },
                )
              ],
            ),
        ),
      ),
    );
  }
}
