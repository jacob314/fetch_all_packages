import 'package:example/redux/actions.dart';
import 'package:example/redux/containers/typedefs.dart';
import 'package:example/redux/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:meta/meta.dart';

class IsStartedConnector extends StoreConnector<AppState, AppActions, bool> {
  IsStartedConnector({@required this.builder});

  final ViewModelBuilder<bool> builder;

  @override
  bool connect(AppState state) => state.isStarted;

  @override
  Widget build(BuildContext context, bool isStarted, AppActions actions) {
    return builder(context, isStarted);
  }
}
