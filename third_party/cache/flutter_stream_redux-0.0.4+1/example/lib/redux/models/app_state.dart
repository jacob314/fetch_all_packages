library app_state;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  factory AppState([AppStateBuilder updates(AppStateBuilder b)]) = _$AppState;

  factory AppState.initialState() {
    return new AppState((b) {
      b
        ..now = 0
        ..isStarted = false
        ..duration = const Duration(milliseconds: 200);
    });
  }

  AppState._();

  int get now;

  bool get isStarted;

  Duration get duration;

  static Serializer<AppState> get serializer => _$appStateSerializer;
}
