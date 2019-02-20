import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

enum StreamAction { subscribe, unsubscribe }

class SubscriptionPayload<P> {
  const SubscriptionPayload({@required this.action, this.payload}) : assert(action != null);

  static SubscriptionPayload unsubscribe = const SubscriptionPayload<Null>(action: StreamAction.unsubscribe);

  static SubscriptionPayload subscribe<P>(P payload) => new SubscriptionPayload<P>(action: StreamAction.subscribe, payload: payload);

  final StreamAction action;

  final P payload;
}

class MiddlewareStreamBuilder<State extends Built<State, StateBuilder>, StateBuilder extends Builder<State, StateBuilder>,
    Actions extends ReduxActions> {
  BuiltMap<String, StreamSubscription<dynamic>> _streams = new BuiltMap<String, StreamSubscription<dynamic>>();

  final Map<String, MiddlewareStreamHandler<State, StateBuilder, Actions, dynamic, dynamic>> _map =
      <String, MiddlewareStreamHandler<State, StateBuilder, Actions, dynamic, dynamic>>{};

  void add<Payload, StreamType>(ActionName<SubscriptionPayload<Payload>> aMgr,
      MiddlewareStreamHandler<State, StateBuilder, Actions, Payload, StreamType> handler) {
    if (!_map.containsKey(aMgr.name)) {
      _map[aMgr.name] = handler;
    }
  }

  /// [combine] combines this MiddlewareBuilder with another MiddlewareBuilder
  /// for the same type
  void combine(MiddlewareStreamBuilder<State, StateBuilder, Actions> other) {
    _map.addAll(other._map);
  }

  /// [build] returns a [Middleware] function that handles all actions added with [add]
  Middleware<State, StateBuilder, Actions> build() {
    return (MiddlewareApi<State, StateBuilder, Actions> api) {
      return (ActionHandler next) => (Action<dynamic> action) {
            final dynamic subscriptionAction = action.payload;
            final String actionName = action.name;

            if (subscriptionAction is SubscriptionPayload) {
              if (subscriptionAction.action == StreamAction.unsubscribe) {
                final StreamSubscription<dynamic> streamSubscription = _streams[actionName];
                streamSubscription?.cancel();

                final MapBuilder<String, StreamSubscription<dynamic>> mapBuilder = _streams.toBuilder();
                mapBuilder.remove(actionName);
                _streams = (mapBuilder).build();
              } else {
                final MiddlewareStreamHandler<State, StateBuilder, Actions, dynamic, dynamic> handler = _map[actionName];
                if (!_streams.containsKey(actionName) && handler != null) {
                  final MapBuilder<String, StreamSubscription<dynamic>> mapBuilder = _streams.toBuilder();

                  mapBuilder[actionName] = handler.getStream(subscriptionAction.payload).listen(
                    (dynamic event) {
                      handler.onData(api, next, action, event);
                    },
                    onError: (dynamic error, StackTrace stackTrace) {
                      if (handler.cancelOnError) {
                        final StreamSubscription<dynamic> streamSubscription = _streams[actionName];
                        streamSubscription.cancel();

                        final MapBuilder<String, StreamSubscription<dynamic>> mapBuilder = _streams.toBuilder();
                        mapBuilder.remove(actionName);
                        _streams = (mapBuilder).build();
                      }
                      handler.onError(api, error, stackTrace);
                    },
                    onDone: () => handler.onDone(api),
                    cancelOnError: handler.cancelOnError,
                  );

                  _streams = (mapBuilder).build();
                }
              }
            } else {
              next(action);
            }
          };
    };
  }
}

abstract class MiddlewareStreamHandler<State extends Built<State, StateBuilder>,
    StateBuilder extends Builder<State, StateBuilder>, Actions extends ReduxActions, Payload, StreamType> {
  /// The stream you want to listen for events.
  Stream<StreamType> getStream(Payload payload);

  /// see [Stream.listen]
  bool cancelOnError = false;

  /// This will be trigger every time the stream has new data.
  void onData(MiddlewareApi<State, StateBuilder, Actions> api, ActionHandler next, Action<SubscriptionPayload<Payload>> action, StreamType event);

  /// see [Stream.listen], this callback is optional
  void onDone(MiddlewareApi<State, StateBuilder, Actions> api) {}

  /// see [Stream.listen], this callback is optional
  void onError(MiddlewareApi<State, StateBuilder, Actions> api, dynamic error, StackTrace stackTrace) {}
}
