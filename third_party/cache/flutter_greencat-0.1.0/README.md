# flutter_greencat

[![build status](https://gitlab.com/brianegan/flutter_greencat/badges/master/build.svg)](https://gitlab.com/brianegan/flutter_greencat/commits/master)  [![coverage report](https://gitlab.com/brianegan/flutter_greencat/badges/master/coverage.svg)](https://brianegan.gitlab.io/flutter_greencat/coverage/)

A set of utilities that allow you to easily consume a [Greencat](https://pub.dartlang.org/packages/greencat) Store to build Flutter Widgets.

This package is built to work with [Greencat](https://pub.dartlang.org/packages/greencat). If you use the [Redux](https://pub.dartlang.org/packages/redux) library instead, check out [flutter_redux](https://pub.dartlang.org/packages/flutter_redux).

## Included Widgets 

  * `StoreProvider` - The base Widget. It will pass the given Greencat Store to all descendants that request it.
  * `StoreBuilder` - A descendant Widget that gets the Store from a `StoreProvider` and passes it to a Widget `builder` function.
  * `StoreConnector` - A descendant Widget that gets the Store from the nearest `StoreProvider` ancestor, converts the `Store` into a `ViewModel` with the given `converter` function, and passes the `ViewModel` to a `builder` function. Any time the Store emits a change event, the Widget will automatically be rebuilt. No need to manage subscriptions!

## Usage

Let's demo the basic usage with the all-time favorite: A counter example!

```dart
import 'package:flutter/material.dart';
import 'package:greencat/greencat.dart';
import 'package:flutter_greencat/flutter_greencat.dart';

// Start by creating your normal "Greencat Setup." 
// 
// First, we'll create one action: Increment.  Second, we need a reducer which
// can take this action and update the current count in response.

// One simple action type: Increment
enum ActionTypes { Increment }

// The action we'll dispatch
class IncrementAction extends Action<ActionTypes> {
  final ActionTypes payload = ActionTypes.Increment;
  final ActionTypes type = ActionTypes.Increment;
}

// The reducer, which takes the previous count and increments it in response
// to an Increment action.
int counterReducer(IncrementAction action, {int currentState}) {
  switch (action.type) {
    case ActionTypes.Increment:
      return (currentState + 1);
    default:
      return currentState;
  }
}

// This class represents the data that will be passed to the `builder` function.
//
// In our case, we need only two pieces of data: The current count and a
// callback function that we can attach to the increment button.
//
// The callback will be responsible for dispatching an Increment action.
//
// If you come from React, think of this as your PropTypes, but in a type-safe
// world!
class ViewModel {
  final int count;
  final VoidCallback onIncrementPressed;

  ViewModel(
    this.count,
    this.onIncrementPressed,
  );

  factory ViewModel.fromStore(Store<int, IncrementAction> store) {
    return new ViewModel(
      store.state,
      () => store.dispatch(new IncrementAction()),
    );
  }
}

void main() {
  runApp(new FlutterGreencatApp());
}

class FlutterGreencatApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FlutterGreencatAppState();
}

class FlutterGreencatAppState extends State<FlutterGreencatApp> {
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final Store<int, IncrementAction> store = new Store.createStore(
    counterReducer,
    initialState: 0,
  );

  @override
  Widget build(BuildContext context) {
    final title = 'Flutter Greencat Demo';

    return new MaterialApp(
      theme: new ThemeData.dark(),
      title: title,
      home: new StoreProvider(
        // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
        // Widgets will find and use this value as the `Store`.
        store: store,
        // Our child will be a `StoreConnector` Widget. The `StoreConnector`
        // will find the `Store` from the nearest `StoreProvider` ancestor,
        // convert it into a ViewModel, and pass that ViewModel to the
        // `builder` function.
        //
        // Every time the button is tapped, an action is dispatched and run
        // through the reducer. After the reducer updates the state, the Widget
        // will be automatically rebuilt. No need to manually manage
        // subscriptions or Streams!
        child: new StoreConnector<int, IncrementAction, ViewModel>(
          // Convert the store into a ViewModel. This ViewModel will be passed
          // to the `builder` below as the second argument.
          converter: (store) => new ViewModel.fromStore(store),

          // Take the `ViewModel` created by the `converter` function above and
          // build a Widget with the data!
          builder: (context, viewModel) {
            return new Scaffold(
              appBar: new AppBar(
                title: new Text(title),
              ),
              body: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text('You have pushed the button this many times:'),
                    new Text(
                      // Grab the latest count from the ViewModel
                      viewModel.count.toString(),
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ],
                ),
              ),
              floatingActionButton: new FloatingActionButton(
                // Attach the ViewModel's callback to the Floating Action Button
                // The callback simply dispatches the `Increment` action.
                onPressed: viewModel.onIncrementPressed,
                tooltip: 'Increment',
                child: new Icon(Icons.add),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // A Greencat store should be closed when the application shuts down.
    store.close();
    super.dispose();
  }
}
```  
