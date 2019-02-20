import 'package:flutter/material.dart';
import 'package:observable_widgets/base_state.dart';
import 'package:observable_widgets/state_changed.dart';
void main() => runApp(new MyApp());

class AppState {
  int _intData;
  AppState(this._intData);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends BaseState<MyHomePage> {
  int _counter = 0;
  _MyHomePageState();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    //this will rebuild with +1 and then again with another +1
    //but is to fast so we only see +2
    var falseCounter = _counter +1;
    eventBus.fire(new StateChanged(new AppState(falseCounter)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void onStateChanged(Object newStateObject) {
    // I tried to did it Generic, but the editor don't recognize any model as a class in this overriden method
    // Cast object to the model
    var newState = newStateObject as AppState;
    // Compare previous state with the new one, if is not changed, is not rebuilded
    if (_counter != newState._intData) {
      // Call setstate to update the state
      if (mounted) {
        setState(() {
          _counter = newState._intData;
        });
      }
    }
  }
}
