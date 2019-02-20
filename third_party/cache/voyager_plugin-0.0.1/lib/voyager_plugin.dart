import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class VoyagerPlugin {

  static const MethodChannel _channel = const MethodChannel('voyager_plugin');

  static void connectSocket(String socketChannel, [String socketStatusCallback]) async {
    await _channel.invokeMethod(
        MethodCallName.SOCKET_CONNECT,
        {
          MethodCallArgumentsName.SOCKET_CHANNEL : socketChannel,
          MethodCallArgumentsName.SOCKET_STATUS_CALLBACK : socketStatusCallback
        });
  }

  /// Map subscribes: key is event name, value [optional] is callback event function
  ///
  static void socketSubscribes(Map<String, String> subscribes) async {
    await _channel.invokeMethod(MethodCallName.SOCKET_SUBSCRIBES, subscribes);
  }

  /// Map unsubscribes: key is event name, value [optional] is callback event function
  ///
  static void socketUnsubscribes(Map<String, String> unsubscribes) async {
    await _channel.invokeMethod(MethodCallName.SOCKET_UNSUBSCRIBES, unsubscribes);
  }

  static void sendMessage(String event, String message) async {
    await _channel.invokeMethod(
        MethodCallName.SOCKET_SEND_MESSAGE,
        {
          MethodCallArgumentsName.SOCKET_EVENT : event,
          MethodCallArgumentsName.SOCKET_MESSAGE : message
        });
  }

  static void disconnectSocket() async {
    await _channel.invokeMethod(MethodCallName.SOCKET_DISCONNECT);
  }

}

class MethodCallArgumentsName {
  static final String SOCKET_CHANNEL = "socketChannel";
  static final String SOCKET_STATUS_CALLBACK = "socketStatusCallback";
  static final String SOCKET_EVENT = "socketEvent";
  static final String SOCKET_MESSAGE = "socketMessage";
}

class MethodCallName {
  static final String SOCKET_CONNECT = "socketConnect";
  static final String SOCKET_DISCONNECT = "socketDisconnect";
  static final String SOCKET_SUBSCRIBES = "socketSubcribes";
  static final String SOCKET_UNSUBSCRIBES = "socketUnsubcribes";
  static final String SOCKET_SEND_MESSAGE = "socketSendMessage";
}
