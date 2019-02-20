import 'package:flutter/material.dart';

class TheList extends StatefulWidget {
  TheList({
    this.scrollDirection: Axis.vertical,
  });

  final Axis scrollDirection;
  _TheListState createState() => new _TheListState();
}

class _TheListState extends State<TheList> {
  int itemCount;

  @override
  initState() {
    super.initState();
    itemCount = 10;
  }

  Widget build(BuildContext context) {
    return new ListView.builder(
        scrollDirection: widget.scrollDirection,
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            onTap: () {},
            child: new Ink(
              height: widget.scrollDirection == Axis.horizontal ? null : 100.0,
              width: widget.scrollDirection == Axis.horizontal ? 50.0 : null,
              decoration: new BoxDecoration(
                  color: Colors.grey, border: new Border.all()),
              child: new Center(
                child: new Text("$index"),
              ),
            ),
          );
        });
  }
}

class TheApp extends StatelessWidget {
  Widget build(BuildContext context) {
    // return new TheList(
    //   scrollDirection: Axis.vertical,
    // );
    return new Column(
      children: <Widget>[
        new Container(
          height: 100.0,
          child: new TheList(
            scrollDirection: Axis.horizontal,
          ),
        ),
        new Container(
          height: MediaQuery.of(context).size.height - 200,
          child: new TheList(
            scrollDirection: Axis.vertical,
          ),
        ),
      ],
    );
  }
}

void main() => runApp(
      new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(title: const Text("Ink Bug"), elevation: 0.0),
          body: new TheApp(),
        ),
      ),
    );
