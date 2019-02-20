
import 'package:flutter/material.dart';

class UserControlEvent extends ValueNotifier<ControlEvent> {
  UserControlEvent(value) : super(value);
  Function function;
}

enum ControlEvent {
  PAUSE,
  PLAY
}

