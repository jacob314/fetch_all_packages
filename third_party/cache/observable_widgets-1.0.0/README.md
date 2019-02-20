# observable_widgets

Base stateful widget that automatically subscribe itself to the app state change events.
Also automatically unsubscribe when the widget is disposed.

## Getting Started

You only have to do 3 things:
1. Your States have to extend 'BaseState'
2. This states have to implement the method 'onStateChanged', responsible of update the widget state and call set state if required.
3. When you update your app state, you have to raise the 'StateChanged' event with the new state.

This project purpose is to learn about the framework and make simpler ways to work with it.
Feel free to create pull request and create issues.

## Notes
- To raise events this library uses [event_bus](http:https://pub.dartlang.org/packages/event_bus// "event_bus")

TODO:
- Test
- Doc
