import 'package:built_redux/built_redux.dart';
import 'package:example/redux/actions.dart';
import 'package:example/redux/containers/typedefs.dart';
import 'package:example/redux/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logger/flutter_logger.dart';
import 'package:flutter_stream_redux/flutter_stream_redux.dart';
import 'package:meta/meta.dart';

class NowStreamConnector extends StreamedStoreConnector<AppState, AppActions, int, Duration> {
  static final Log log = new Log('NowStreamConnector');

  NowStreamConnector({@required this.builder, @required this.duration});

  final ViewModelBuilder<int> builder;

  final Duration duration;

  @override
  Duration get subscribePayload => duration;

  @override
  ActionDispatcher<SubscriptionPayload<Duration>> streamAction(AppActions actions) => actions.timeStream;

  @override
  int connect(AppState state) => state.now;

  @override
  Widget build(BuildContext context, int now, AppActions actions) {
    return builder(context, now);
  }
}
