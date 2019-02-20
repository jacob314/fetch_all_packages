import 'package:flutter/material.dart';
import 'package:compassion/compassion.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final compass = Compass({
    "/": (c, a) => MyHomePage(title: a),
  });

  @override
  Widget build(BuildContext context) => CompassProvider(
        compass: compass,
        child: MaterialApp(
          onGenerateRoute: compass,
          home: MyHomePage(),
        ),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "No arguments"),
        ),
        body: Center(
          child: Text(widget.title ?? "No arguments"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.of(context).pushNamed("/", arguments: "Hi!"),
          tooltip: 'Change text',
          child: Icon(Icons.arrow_forward),
        ),
      );
}
