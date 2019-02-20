library actions;

import 'package:built_redux/built_redux.dart';
import 'package:flutter_stream_redux/flutter_stream_redux.dart';

part 'actions.g.dart';

abstract class AppActions extends ReduxActions {
  factory AppActions() => new _$AppActions();

  AppActions._();

  ActionDispatcher<SubscriptionPayload<Duration>> get timeStream;

  ActionDispatcher<Duration> get setDuration;

  ActionDispatcher<int> get setNow;

  ActionDispatcher<bool> get setIsStarted;
}
