import 'package:built_redux/built_redux.dart';
import 'package:example/redux/actions.dart';
import 'package:example/redux/models/app_state.dart';

//Nothing here for now
Middleware<AppState, AppStateBuilder, AppActions> createStoreMiddleware() {
  final MiddlewareBuilder<AppState, AppStateBuilder, AppActions> builder =
      new MiddlewareBuilder<AppState, AppStateBuilder, AppActions>();

  return builder.build();
}
