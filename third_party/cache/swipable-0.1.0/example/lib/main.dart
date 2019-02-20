import 'package:flutter/material.dart';
import 'package:swipable/swipable.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Swipable Test',
      home: new MyHomePage(title: 'Swipable Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = 0;

  bool onFling(SwipableInfo swipe, DragEndDetails event) {
    setState(() {
      _count++;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(widget.title),
      ),
      body: new Container(
          child: new Swipable(
        onFling: onFling,
        tweenTranslation: (swipe) => Offset(2.0 * swipe.fractionalDelta, 0.0),
        child: new Card(
          child: new Center(child: new Text('Swipes: $_count')),
        ),
      )),
    );
  }
}
