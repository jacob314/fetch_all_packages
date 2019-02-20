import 'package:built_redux/built_redux.dart';
import 'package:example/redux/actions.dart';
import 'package:example/redux/models/app_state.dart';
import 'package:flutter_logger/flutter_logger.dart';

final Log log = new Log('Reducer');

Reducer<AppState, AppStateBuilder, AppActions> get reducerBuilder {
  final ReducerBuilder<AppState, AppStateBuilder> builder = new ReducerBuilder<AppState, AppStateBuilder>();
  builder
    ..add(AppActionsNames.setDuration, setDuration)
    ..add(AppActionsNames.setNow, setNow)
    ..add(AppActionsNames.setIsStarted, setIsStarted);

  return builder.build();
}

void setDuration(AppState state, Action<Duration> action, AppStateBuilder builder) {
  log.d('setDuration: ${action.payload}');
  builder.duration = action.payload;
}

void setNow(AppState state, Action<int> action, AppStateBuilder builder) {
  log.d('setNow: ${action.payload}');
  builder.now = action.payload;
}

void setIsStarted(AppState state, Action<bool> action, AppStateBuilder builder) {
  log.d('setIsStarted: ${action.payload}');
  builder.isStarted = action.payload;
}
