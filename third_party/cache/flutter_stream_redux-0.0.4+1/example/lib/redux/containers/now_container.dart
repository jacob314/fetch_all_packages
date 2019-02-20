library now_container;

import 'package:built_value/built_value.dart';
import 'package:example/redux/actions.dart';
import 'package:example/redux/containers/typedefs.dart';
import 'package:example/redux/models/app_state.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_logger/flutter_logger.dart';
import 'package:flutter_stream_redux/flutter_stream_redux.dart';
import 'package:meta/meta.dart';

part 'now_container.g.dart';

typedef void ListenToStream(Duration duration);

abstract class NowViewModel implements Built<NowViewModel, NowViewModelBuilder> {
  static final Log log = new Log('NowViewModel');

  factory NowViewModel([NowViewModelBuilder updates(NowViewModelBuilder b)]) = _$NowViewModel;

  factory NowViewModel.fromActions(AppActions actions, int state) {
    return new NowViewModel((NowViewModelBuilder b) {
      b
        ..now = state
        ..listenToStream = (Duration duration) {
          log.d(duration);
          if (duration == null) {
            actions.timeStream(SubscriptionPayload.unsubscribe);
            actions.setNow(0);
            actions.setIsStarted(false);
          } else {
            actions.setIsStarted(true);
            actions.timeStream(SubscriptionPayload.subscribe(duration));
          }
        };
    });
  }

  NowViewModel._();

  int get now;

  ListenToStream get listenToStream;
}

class NowConnector extends StoreConnector<AppState, AppActions, int> {
  NowConnector({@required this.builder});

  final ViewModelBuilder<NowViewModel> builder;

  @override
  int connect(AppState state) => state.now;

  @override
  Widget build(BuildContext context, int state, AppActions actions) {
    return builder(context, new NowViewModel.fromActions(actions, state));
  }
}
