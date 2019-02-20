library duration_connector;

import 'package:built_value/built_value.dart';
import 'package:example/redux/actions.dart';
import 'package:example/redux/containers/typedefs.dart';
import 'package:example/redux/models/app_state.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_logger/flutter_logger.dart';
import 'package:meta/meta.dart';

part 'duration_connector.g.dart';

typedef void DurationChanged(Duration duration);

abstract class DurationViewModel implements Built<DurationViewModel, DurationViewModelBuilder> {
  static final Log log = new Log('DurationViewModel');

  factory DurationViewModel([DurationViewModelBuilder updates(DurationViewModelBuilder b)]) = _$DurationViewModel;

  factory DurationViewModel.fromActions(AppActions actions, Duration state) {
    return new DurationViewModel((DurationViewModelBuilder b) {
      b
        ..duration = state
        ..durationChanged = (Duration duration) {
          actions.setDuration(duration);
        };
    });
  }

  DurationViewModel._();

  Duration get duration;

  DurationChanged get durationChanged;
}

class DurationConnector extends StoreConnector<AppState, AppActions, Duration> {
  DurationConnector({@required this.builder});

  final ViewModelBuilder<DurationViewModel> builder;

  @override
  Duration connect(AppState state) => state.duration;

  @override
  Widget build(BuildContext context, Duration state, AppActions actions) {
    return builder(context, new DurationViewModel.fromActions(actions, state));
  }
}
