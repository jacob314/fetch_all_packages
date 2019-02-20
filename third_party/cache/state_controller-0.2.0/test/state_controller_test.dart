import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:state_controller/state_controller.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

class App extends StatelessWidget {
// This widget is the root of your application.
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

class _MyHomePageState extends ControllerCreator<MyHomePage, _MyHomePageController> {

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${controller.counter}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: IncrementFab(),
    );
  }

  @override
  _MyHomePageController createController() => _MyHomePageController();
}

class IncrementFab extends StatefulWidget {
  @override
  _IncrementFabState createState() => _IncrementFabState();
}

class _IncrementFabState extends State<IncrementFab> with ControllerInjector<_MyHomePageController> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: controller.increment,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}


class _MyHomePageController extends StateController {
  int _counter = 0;

  int get counter => _counter;

  @override
  void onInitState() {
    // TODO: implement onCreate
  }

  @override
  void onUpdateWidget() {
    // TODO: implement onWidgetUpdate
  }

  void increment() {
    changeState(() {
      _counter++;
    });
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
    super.onDispose();
  }
}
