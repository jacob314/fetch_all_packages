import 'dart:async';

import 'package:built_redux/built_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter_stream_redux/src/stream_middleware.dart';
import 'package:meta/meta.dart';

/// [StreamedStoreConnector] is a widget that rebuilds when the redux store
/// has triggered and the connect function yields a new result and automatically
/// connects to the stream you defined in the Stream Middleware.
///
/// see [StoreConnector] and [MiddlewareStreamBuilder]
abstract class StreamedStoreConnector<StoreState, Actions extends ReduxActions, LocalState, Payload> extends StatefulWidget {
  StreamedStoreConnector({Key key}) : super(key: key);

  /// [streamAction] give you all the actions available and it requires you to return the action that will trigger subscribe
  /// and unsubscribe for the stream you want to listen to. The payload of the action bust be of type [SubscriptionPayload]
  ActionDispatcher<SubscriptionPayload<Payload>> streamAction(Actions actions);

  /// Provide the payload you want to pass to the [MiddlewareStreamHandler.getStream]
  Payload get subscribePayload;

  /// [connect] takes the current state of the redux store and retuns an object that contains
  /// the subset of the redux state tree that this component cares about.
  /// It requires that you return a comparable type to ensure your props setState is only called when necessary.
  /// Primitive types, built values, and collections are recommended.
  /// The result of [connect] is what gets passed to the build function's second param
  @protected
  LocalState connect(StoreState state);

  @override
  _StreamedStoreConnectorState<StoreState, Actions, LocalState, Payload> createState() {
    return new _StreamedStoreConnectorState<StoreState, Actions, LocalState, Payload>();
  }

  @protected
  Widget build(BuildContext context, LocalState state, Actions actions);
}

class _StreamedStoreConnectorState<StoreState, Actions extends ReduxActions, LocalState, Payload>
    extends State<StreamedStoreConnector<StoreState, Actions, LocalState, Payload>> {
  StreamSubscription<SubstateChange<LocalState>> _storeSub;

  /// [LocalState] is an object that contains the subset of the redux state tree that this component
  /// cares about.
  LocalState _state;

  /// The action that ties the stream
  ActionDispatcher<SubscriptionPayload<Payload>> _action;

  Store get _store {
    // get the store from the ReduxProvider ancestor
    final ReduxProvider reduxProvider = context.inheritFromWidgetOfExactType(ReduxProvider);

    // if it is not found raise an error
    assert(reduxProvider != null, 'Store was not found, make sure ReduxProvider is an ancestor of this component.');

    assert(reduxProvider.store.state is StoreState,
        'Store found was not the correct type, make sure StoreConnector\'s generic for StoreState matches the state type of your built_redux store.');

    assert(reduxProvider.store.actions is Actions,
        'Store found was not the correct type, make sure StoreConnector\'s generic for Actions matches the actions type of your built_redux store.');

    return reduxProvider.store;
  }

  @override
  void didUpdateWidget(StreamedStoreConnector<StoreState, Actions, LocalState, Payload> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ActionDispatcher<SubscriptionPayload<Payload>> oldAction = oldWidget.streamAction(_store.actions);
    final ActionDispatcher<SubscriptionPayload<Payload>> newAction = widget.streamAction(_store.actions);

    if (oldAction != newAction || oldWidget.subscribePayload != widget.subscribePayload) {
      oldAction(SubscriptionPayload.unsubscribe);
      newAction(SubscriptionPayload.subscribe(widget.subscribePayload));
    }
  }

  /// sets up a subscription to the store and the stream
  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if the store has already been subscribed to return early. didChangeDependencies
    // will be called every time the dependencies of the widget change, but we only
    // want to subscribe to the store the first time it is called. Subscriptions are setup
    // in didChangeDependencies, rather than initState, because inheritFromWidgetOfExactType
    // cannot be called before initState completes.
    // See https://github.com/flutter/flutter/blob/0.0.20/packages/flutter/lib/src/widgets/framework.dart#L3721
    if (_storeSub != null) return;
    _action = widget.streamAction(_store.actions);
    _action(SubscriptionPayload.subscribe(widget.subscribePayload));

    // set the initial state
    _state = widget.connect(_store.state as StoreState);

    // listen to changes
    _storeSub = _store.substateStream((state) => widget.connect(state as StoreState)).listen((change) {
      setState(() {
        _state = change.next;
      });
    });
  }

  /// Cancels the store subscription.
  @override
  @mustCallSuper
  void dispose() {
    _action(SubscriptionPayload.unsubscribe);
    _storeSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _state, _store.actions as Actions);
}
