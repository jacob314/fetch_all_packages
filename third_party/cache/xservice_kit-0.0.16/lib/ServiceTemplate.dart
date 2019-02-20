import 'dart:async';
import 'package:flutter/services.dart';
import 'ServiceCallHandler.dart';

class ServiceTemplate {
  MethodChannel _channel = null;
  EventChannel _eventChannel = null;
  String _serviceName = "root";

  Map<String, ServiceCallHandler> _callHandlers = new Map();

  Map<int, StreamSubscription<dynamic>> _subscriptions =
      new Map<int, StreamSubscription<dynamic>>();
  int _subscriptionCounter = 0;
  Stream<dynamic> _stream = null;

  ServiceTemplate(String serviceName) {
    _serviceName = serviceName;
    _channel = new MethodChannel(serviceName + "_method_channel");
    _eventChannel = new EventChannel(serviceName + "_event_channel");

    _channel.setMethodCallHandler((MethodCall call) {
      final ServiceCallHandler handler = _callHandlers[call.method];
      if (handler != null) {
        return handler.onMethodCall(call);
      } else {
        return null;
      }
    });
  }

  String serviceName() {
    return _serviceName;
  }

  void regiserHandler(ServiceCallHandler handler) {
    _callHandlers[handler.name()] = handler;
  }

  //Return a unique id for subscription.
  int listenEvent(void onData(dynamic event)) {
    if (_stream == null) {
      _stream = _eventChannel.receiveBroadcastStream();
    }
    final dynamic subscription = _stream.listen(onData);
    _subscriptions[_subscriptionCounter] = subscription;
    return _subscriptionCounter++;
  }

  //For older usage.
  void cancelEvent() {
    cancelEventForSubscription(0);
  }

  //Cancel event for subscription with ID.
  void cancelEventForSubscription(int subID) {
    StreamSubscription<dynamic> sub = _subscriptions[subID];
    if (sub != null) {
      sub.cancel();
      _subscriptions.remove(subID);
    }
  }


  MethodChannel methodChannel() {
    return _channel;
  }

  EventChannel eventChannel() {
    return _eventChannel;
  }
}
