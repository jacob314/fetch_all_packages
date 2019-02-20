import 'dart:async';

import 'package:built_redux/built_redux.dart';
import 'package:example/redux/actions.dart';
import 'package:example/redux/models/app_state.dart';
import 'package:flutter_logger/flutter_logger.dart';
import 'package:flutter_stream_redux/flutter_stream_redux.dart';

Middleware<AppState, AppStateBuilder, AppActions> getStreamMiddleware() {
  final MiddlewareStreamBuilder<AppState, AppStateBuilder, AppActions> builder =
      new MiddlewareStreamBuilder<AppState, AppStateBuilder, AppActions>();

  builder..add(AppActionsNames.timeStream, new TimeStreamHandler());

  return builder.build();
}

class TimeStreamHandler extends MiddlewareStreamHandler<AppState, AppStateBuilder, AppActions, Duration, int> {
  static final Log log = new Log('TimeStreamHandler');

  /// We create the stream because we don't have a real one. you could use here a Firebase Database stream or any other stream. ;)

  @override
  Stream<int> getStream(Duration payload) {
    /// This is closed when we call this handler action with [SubscriptionPayload.unsubscribe]
    // ignore: close_sinks
    StreamController<int> controller;
    Timer timer;
    int counter = 0;

    void tick(Timer _) {
      counter++;
      controller.add(counter);
    }

    void startTimer() {
      timer = new Timer.periodic(payload, tick);
    }

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
    }

    controller = new StreamController<int>(onListen: startTimer, onPause: stopTimer, onResume: startTimer, onCancel: stopTimer);
    return controller.stream;
  }

  @override
  void onData(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, ActionHandler next,
      Action<SubscriptionPayload<Duration>> action, int event) {
    api.actions.setNow(event);
  }

  @override
  void onError(MiddlewareApi<AppState, AppStateBuilder, AppActions> api, dynamic error, StackTrace stackTrace) {
    log.d(error);
  }

  @override
  void onDone(MiddlewareApi<AppState, AppStateBuilder, AppActions> api) {
    log.d('done');
  }

  @override
  bool get cancelOnError => false;
}
