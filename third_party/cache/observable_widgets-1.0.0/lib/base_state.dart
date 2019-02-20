import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:observable_widgets/state_changed.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  StreamSubscription stream;
  EventBus eventBus;
  BaseState() {
    eventBus = new EventBus();
    this.stream = eventBus.on<StateChanged>().listen((event) {
      onStateChanged(event.newState);
    });
  }

  /// Map the app state to your stateful widget state before rebuild.
  void onStateChanged(Object newStateObject);

  @protected
  void dispose() {
    this.stream.cancel();
    super.dispose();
  }

  Widget build(BuildContext context);
}
