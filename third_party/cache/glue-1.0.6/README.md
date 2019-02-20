# glue

A library that allows you to easily pass a data Model from a one Widget to others using messaging system.
This will help avoid passing delegates.

A widget can subscribe to external events using on<Channel, Event>() method.

```dart
import 'package:flutter/material.dart';
import 'package:glue/glue.dart';
import 'package:glue_example/channels/counter_channel.dart';
import 'package:glue_example/channels/hello_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BuildContext _context;

  @override
  void initState() {
    Glue.on<HelloChannel, HelloEvent>(_onData);
    super.initState();
  }

  void _onData(event) {
    Scaffold.of(_context).showSnackBar(new SnackBar(
      content: new Text("Hello clicked"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Builder(builder: (context) {
          _context = context;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[CounterView()],
            ),
          );
        }),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => Glue.emit<CounterChannel>(PlusEvent()),
              tooltip: 'Plus',
              child: Icon(Icons.add),
            ),
            FloatingActionButton(
                onPressed: () => Glue.emit<CounterChannel>(MinusEvent()),
                tooltip: 'Minus',
                child: Icon(Icons.remove)),
          ],
        )
        );
  }

  @override
  void dispose() {
    Glue.off<HelloChannel, HelloEvent>(_onData);
    super.dispose();
  }
}

class CounterView extends StatefulWidget {
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  String _text = '';

  @override
  void initState() {
    Glue.on<CounterChannel, PlusEvent>(_onPlusRecieved);
    Glue.on<CounterChannel, MinusEvent>(_onMinusRecieved);
    // subscribe to events
    super.initState();
  }

  void _onPlusRecieved(PlusEvent event) {
    setState(() {
      _text = 'Plus Pushed';
    });
  }

  void _onMinusRecieved(MinusEvent event) {
    setState(() {
      _text = 'Minus Pushed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(_text),
      RaisedButton(
        child: Text('Push'),
        onPressed: () {
          Glue.emit<HelloChannel>(HelloEvent());
        },
      )
    ]);
  }

  @override
  void dispose() {
    Glue.off<CounterChannel, PlusEvent>(_onPlusRecieved);
    Glue.off<CounterChannel, MinusEvent>(_onMinusRecieved);
    super.dispose();
  }
}

```
