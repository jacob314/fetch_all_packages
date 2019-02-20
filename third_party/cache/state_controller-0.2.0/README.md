# state_controller

https://pub.dartlang.org/packages/state_controller

A new Flutter package.

## About

This library is aimed at separating the logic of drawing a widget and changing its state.
Please look at the example in the project.

## Docs

### LifecycleCallback

'onInitState'  called when creating a controller in 'initState()' of your state.

'onUpdateWidget'  called after changing the widget and before the method 'build()' of your state.

'onDispose' called when the 'dispose()' of your state.

### mixin LifecycleSubject<W extends StatefulWidget>

'subscribe(LifecycleCallback callback)' subscribe to change lifecycle in this state. 

### StateController implements LifecycleCallback

'context' get BuildContext from ControllerCreator

'changeState' this method calls 'setState()' in itself, and therefore requires the same parameters.

### abstract class ControllerCreator<W extends StatefulWidget, T extends StateController> extends State<W>

This class is used to create and provide StateController 

### ControllerInjector<SC extends StateController>

This class injected your StateController.

### Custom provide controller

Use ControllerProvider.provide<YourStateController>(context);

## Example

```dart

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
  
  void increment() {
    changeState(() {
      _counter++;
    });
  }
}

```
